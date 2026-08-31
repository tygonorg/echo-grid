# Echo Grid — Technical Architecture v1

## 1. Mục tiêu kiến trúc

Tài liệu này mô tả kiến trúc kỹ thuật cho Echo Grid theo hướng iOS-native, ưu tiên độ phản hồi thấp, khả năng mở rộng rule engine, dễ test, và tách biệt rõ gameplay simulation khỏi rendering/feedback.

Mục tiêu chính:
- Cho phép mở rộng rule logic mà không sửa UI nhiều.
- Cho phép tuning haptic/audio/visual độc lập.
- Hỗ trợ data-driven levels và daily seed generation.
- Tối ưu cho maintainability, testability và iteration nhanh trong SwiftUI.

---

## 2. Nguyên tắc kiến trúc

1. **Simulation first**: gameplay correctness không phụ thuộc UI.
2. **Feedback is derived**: haptic, audio, visual luôn được suy ra từ simulation output.
3. **Data-driven content**: level, rule, difficulty, progression phải cấu hình được.
4. **Deterministic core**: cùng seed và input phải cho cùng kết quả.
5. **Graceful degradation**: haptic/audio/render phải có fallback khi thiết bị hạn chế.

---

## 3. Layered Architecture

### 3.1 Presentation Layer
Chịu trách nhiệm hiển thị UI SwiftUI, routing, screen state nhỏ và accessibility presentation.

**Thành phần**
- `HomeView`
- `DailyChallengeView`
- `GameplayView`
- `ResultView`
- `SettingsView`
- `CalibrationView`

### 3.2 Interaction Layer
Nhận input gesture, chuyển thành domain action, điều phối state machine màn chơi.

**Thành phần**
- `GameplayCoordinator`
- `InputInterpreter`
- `BoardGestureHandler`
- `GameplaySessionController`

### 3.3 Simulation Layer
Lõi nghiệp vụ của game. Không phụ thuộc SwiftUI.

**Thành phần**
- `BoardState`
- `NodeState`
- `RuleFactExtractor`
- `LevelRuleEngine`
- `ResonanceEvaluator`
- `MoveValidator`
- `LevelGenerator`
- `HintEngine`

### 3.4 Feedback Layer
Biến simulation output thành haptic, audio, visual instructions.

**Thành phần**
- `FeedbackMapper`
- `HapticFeedbackOrchestrator`
- `AudioFeedbackOrchestrator`
- `SpatialWaveRendererModel`
- `AccessibilityFeedbackMapper`

### 3.5 Persistence Layer
Lưu level definitions, progress, settings và daily records.

**Thành phần**
- `LevelRepository`
- `ProgressRepository`
- `SettingsRepository`
- `DailyChallengeRepository`
- `CloudSyncCoordinator`

---

## 4. Data Flow tổng quát

```text
User Gesture
  -> InputInterpreter
  -> GameplaySessionController
  -> LevelRuleEngine / ResonanceEvaluator
  -> FeedbackMapper
  -> Haptic / Audio / Visual Orchestrators
  -> SwiftUI updates UI state
  -> Persistence save checkpoints/progress
```

Luồng này phải chạy rất nhẹ cho mỗi interaction. Tránh bind trực tiếp mọi thay đổi gesture vào re-render lớn của SwiftUI.

---

## 5. Core domain model

### 5.1 Entities
- `BoardState`
- `CellPosition`
- `NodeState`
- `LevelDefinition`
- `RuleDefinition`
- `MoveAction`
- `EvaluationResult`
- `FeedbackVector`
- `GameplaySession`

### 5.2 Example structs

```swift
struct CellPosition: Hashable {
    let row: Int
    let col: Int
}

struct NodeState: Identifiable {
    let id: UUID
    let type: NodeType
    var position: CellPosition
    var orientation: Orientation
    var isLocked: Bool
}

struct BoardState {
    let size: Int
    var nodes: [NodeState]
    var blockers: Set<CellPosition>
}
```

### 5.3 EvaluationResult

```swift
struct EvaluationResult {
    let resonanceScore: Double
    let ruleScores: [RuleID: Double]
    let solved: Bool
    let feedbackVector: FeedbackVector
}
```

---

## 6. Gameplay session lifecycle

### 6.1 State machine
Dùng `GKStateMachine` hoặc abstraction tương đương.

```text
Idle
 -> Dragging
 -> SnapEvaluating
 -> StableEvaluating
 -> Solved
 -> Result
```

### 6.2 Triggers
- `startLevel`
- `beginDrag(nodeID)`
- `moveDrag(position)`
- `snapToGrid(position)`
- `dwellThresholdReached`
- `completeLevel`
- `pause`
- `resume`

### 6.3 Lý do tách SnapEvaluating và StableEvaluating
- `SnapEvaluating`: phản hồi nhanh, nhẹ, tactile.
- `StableEvaluating`: phân tích sâu hơn, cập nhật audio/visual detail.

Điều này giảm chi phí tính toán liên tục và tăng cảm giác “nảy” của interaction.

---

## 7. Rule engine design

### 7.1 Rule abstraction

```swift
protocol RuleEvaluator {
    var id: RuleID { get }
    var weight: Double { get }
    var outputChannel: FeedbackChannel { get }
    func evaluate(board: BoardState, context: EvaluationContext) -> RuleEvaluation
}
```

### 7.2 RuleEvaluation

```swift
struct RuleEvaluation {
    let score: Double
    let hints: [HintFragment]
    let affectedZones: [BoardZone]
}
```

### 7.3 Rule families
- Geometry rules: symmetry, alignment, spacing.
- Topology rules: continuity, isolation, crossing avoidance.
- Rhythm rules: sequence order, phase alignment.
- Balance rules: quadrant load, node distribution.

### 7.4 ResonanceEvaluator
Nhiệm vụ:
- Gọi toàn bộ rule evaluators.
- Tính weighted score.
- Sinh `ruleScores`.
- Tạo `FeedbackVector`.
- Quyết định `solved` theo threshold hoặc exact constraints.

---

## 8. Feedback architecture

### 8.1 Feedback channels
- **Haptic**: tổng quan mức độ cộng hưởng.
- **Audio**: phản hồi theo rule hoặc trạng thái tiến triển.
- **Visual**: chỉ báo vùng/trục cần chú ý.

### 8.2 FeedbackMapper

```swift
protocol FeedbackMapping {
    func map(result: EvaluationResult, profile: SensoryProfile) -> FeedbackInstructions
}
```

### 8.3 Haptic pipeline
- `EvaluationResult`
- `HapticFeedbackOrchestrator`
- intensity/sharpness shaping
- CHHapticPattern runtime hoặc AHAP preset
- cooldown / debounce / thermal scaling

### 8.4 Audio pipeline
- map rule score thành harmonic layer volume
- trộn 2–3 lớp audio tối đa
- tránh audio spam khi drag nhanh

### 8.5 Visual pipeline
- wave pulse theo trục X/Y
- glow ở affected zones
- board lines thay đổi theo continuity

---

## 9. Rendering strategy

### 9.1 SwiftUI responsibilities
- Screen composition
- Gesture binding
- Animation orchestration mức cao
- Accessibility labels

### 9.2 Canvas responsibilities
- Waveforms
- Board glow overlay
- Energy propagation effects
- Fingerprint preview

### 9.3 Performance rules
- Không render effect nặng mỗi frame nếu state chưa đổi đáng kể.
- Dùng caching cho static board layers.
- Tách node layer khỏi effect layer.
- Ưu tiên state nhỏ, immutable snapshots cho board updates.

---

## 10. Persistence & sync

### 10.1 SwiftData responsibilities
- Lưu progress local.
- Lưu settings và sensory calibration.
- Lưu daily attempts và history.

### 10.2 Cloud sync boundaries
Nên sync:
- progress
- settings
- streak
- unlocks

Không cần sync bắt buộc:
- debug traces
- raw move history quá lớn
- tạm thời waveform intermediate data

### 10.3 Conflict policy
- Best score wins cho level progress.
- Latest write wins cho settings.
- Daily challenge merge theo ngày + best completion.

---

## 11. Calibration & adaptation

### 11.1 HapticCalibrationService
Chức năng:
- Chạy sequence 5 mức rung.
- Người dùng chọn cảm giác phù hợp.
- Lưu `hapticScale`.

### 11.2 ThermalGuardService
- Theo dõi `ProcessInfo.thermalState`.
- Khi `.serious`: giảm haptic update rate, giảm visual bloom.
- Khi `.critical`: tắt effect phụ, giữ gameplay core.

### 11.3 BatteryAwarePolicy
- Pin thấp: giảm polling, giảm particle/glow layers.
- Low Power Mode: gợi ý bật low sensory mode.

---

## 12. Level generation architecture

### 12.1 Inputs
- seed
- difficulty tier
- rule family mix
- allowed node palette
- entropy budget

### 12.2 Outputs
- deterministic `LevelDefinition`
- estimated solve complexity
- metadata cho tutorial/hint

### 12.3 Safety checks
- không tạo level vô nghiệm
- không tạo level có nhiều nghiệm nếu mode yêu cầu unique solution
- không tạo opening state quá gần nghiệm

---

## 13. Social share architecture

### 13.1 ResonanceFingerprintGenerator
Input:
- move history
- score deltas
- solve time
- attempt count

Output:
- SVG waveform
- PNG preview
- share summary text

### 13.2 Share flow
```text
Result Screen
 -> Generate fingerprint
 -> Cache artifact
 -> Present Share Sheet
 -> Optional save share record
```

---

## 14. Testing strategy

### 14.1 Unit tests
- Rule evaluators
- Resonance score aggregation
- Level generator determinism
- Hint engine output

### 14.2 Integration tests
- Drag -> snap -> evaluate -> feedback
- Save progress -> restore session
- Daily seed reproducibility

### 14.3 Device testing
Bắt buộc test trên:
- iPhone SE class
- iPhone standard class
- iPhone ProMotion class
- máy có ốp dày và không ốp

---

## 15. Observability

### 15.1 Metrics
- average evaluation time
- frame drops on gameplay screen
- haptic fallback rate
- thermal downgrade frequency
- share conversion rate

### 15.2 Debug overlays
- current state machine state
- resonanceScore
- per-rule score bars
- active feedback channel indicators
- thermal mode badge

---

## 16. Implementation roadmap

### Milestone A
- BoardState, NodeState, MoveAction
- Rule engine base
- ResonanceEvaluator
- Debug overlay

### Milestone B
- Gameplay coordinator
- Drag/snap interaction
- Haptic orchestrator
- Canvas wave layer

### Milestone C
- SwiftData persistence
- Daily challenge pipeline
- Calibration screen
- Thermal guard

### Milestone D
- Fingerprint share
- Widget integration
- Cloud sync polish
- TestFlight hardening

---

## 17. Open questions

- Có cần unique solution cho mọi level hay chỉ daily mode?
- Audio có vai trò bắt buộc hay optional assist?
- Có nên đưa tilt interaction vào core release hay để expansion?
- Dữ liệu share có cần server-side leaderboard hay không?
- Có nên dùng package nội bộ tách rule engine khỏi app target ngay từ đầu?
