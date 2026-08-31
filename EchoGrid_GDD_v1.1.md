# Echo Grid — Game Design Document v1.1

## 1. Tầm nhìn sản phẩm

**Echo Grid** là một game puzzle tối giản, nơi người chơi giải đố không chỉ bằng thị giác mà còn bằng xúc giác. Trọng tâm thiết kế là biến phản hồi haptic từ vai trò hiệu ứng phụ thành một **gameplay mechanic** cốt lõi: người chơi quan sát, chạm, kéo, xoay và cảm nhận “độ cộng hưởng” của một cấu trúc trên lưới để suy luận ra quy luật ẩn.

Game được thiết kế theo tinh thần iOS-native: gọn, mượt, phản hồi nhanh, thời lượng chơi ngắn 1–3 phút, phù hợp với thói quen chơi hàng ngày. Sản phẩm hướng tới cảm giác thiền định, tinh tế, nhưng vẫn đủ chiều sâu để tạo ra các lớp chiến lược và khám phá lâu dài.

---

## 2. Product Pillars

### 2.1 Sensory Reasoning
Người chơi không nhận đáp án trực tiếp. Họ suy luận thông qua rung, ánh sáng, chuyển động và nhịp phản hồi.

### 2.2 Minimal Surface, Deep System
Bề ngoài rất tối giản: lưới nhỏ, ít node, ít màu, ít chữ. Bên dưới là hệ quy tắc đủ giàu để tạo hàng trăm màn chơi khác nhau.

### 2.3 iOS-native Delight
Game tận dụng tốt Taptic Engine, SwiftUI animation, hiệu ứng ánh sáng, sync iCloud, widget daily challenge và accessibility của iOS.

### 2.4 Short Session, Long Retention
Mỗi màn ngắn, nhưng có daily seed, streak, collections và progression nhẹ để giữ người chơi quay lại.

---

## 3. High Concept

Trên một lưới năng lượng, người chơi điều chỉnh các node để tạo ra một cấu hình “cộng hưởng”. Mỗi thao tác làm thay đổi điểm cộng hưởng của toàn bộ bàn cờ. Game phản hồi bằng nhiều lớp tín hiệu:

- Haptic: độ sắc, độ dày, nhịp rung.
- Visual: phát sáng, gợn sóng, độ ổn định của đường nối.
- Audio: tone ngắn, ambient pulse, harmonic click.

Luật đúng của từng màn không được giải thích đầy đủ ngay từ đầu. Người chơi phải khám phá dần dựa trên phản hồi mà hệ thống phát ra.

---

## 4. Core Gameplay Loop

1. Vào màn chơi.
2. Quan sát trạng thái lưới và các node hiện có.
3. Thực hiện thao tác: kéo node, xoay cụm, đổi hướng, thay đổi vị trí.
4. Hệ thống tính `resonanceScore` theo rule set của màn.
5. Game trả về phản hồi haptic + visual + audio theo mức điểm hiện tại.
6. Người chơi lặp lại cho đến khi đạt ngưỡng hoàn thành.
7. Kết thúc màn, ghi nhận số bước, thời gian, hint đã dùng, quality rank.

Session mục tiêu: 60–180 giây/màn.

---

## 5. USP

### 5.1 Haptic as Mechanic
Haptic không chỉ báo đúng/sai mà đóng vai trò ngôn ngữ hệ thống.

### 5.2 Multi-sensory Puzzle
Game tạo quá trình suy luận đa giác quan thay vì chỉ matching bằng mắt.

### 5.3 Device-aware Interaction
Có thể tích hợp hướng cầm máy, rung theo cường độ, và các chế độ “silent visual / silent haptic” để tạo biến thể gameplay độc đáo.

---

## 6. Target Audience

- Người chơi thích puzzle tối giản, suy luận, thiền định.
- Người dùng iPhone yêu trải nghiệm tinh tế, premium.
- Nhóm người chơi daily puzzle như Wordle, mini games, brain training.
- Người thích app/game “đẹp, nhỏ, mượt” hơn là game nhiều content nặng.

---

## 7. Core Mechanics

### 7.1 Board
- Kích thước MVP: 5x5.
- Mở rộng: 6x6, 7x7 cho mode nâng cao.
- Một số ô có thể là fixed anchor, blocker, relay, inverter.

### 7.2 Node Types
- Source node: phát xung.
- Receiver node: nhận xung, cần đúng điều kiện.
- Modifier node: đảo pha, nhân tần số, đổi hướng.
- Locked node: không di chuyển.
- Ghost node: chỉ hiện khi gần đúng hoặc qua hint.

### 7.3 Actions
- Drag để di chuyển node.
- Tap để chọn.
- Rotate để xoay hướng node.
- Long press để xem footprint ảnh hưởng.
- Có thể thêm tilt mode ở expansion phase.

### 7.4 Hidden Rules
Ví dụ rule templates:
- Đối xứng theo trục.
- Khoảng cách Manhattan đúng ngưỡng.
- Chuỗi cộng hưởng theo thứ tự.
- Cân bằng số node trong từng quadrant.
- Hướng truyền xung không được giao thoa.
- Tần số tổng hợp phải đạt pattern mục tiêu.

---

## 8. Resonance System

Thay vì chỉ có đúng/sai, mỗi cấu hình sinh ra một `resonanceScore` từ 0.0 đến 1.0.

### 8.1 Score Bands
- 0.00–0.24: lệch xa.
- 0.25–0.49: có một phần tín hiệu đúng.
- 0.50–0.74: đúng hướng rõ ràng.
- 0.75–0.94: gần hoàn chỉnh.
- 0.95–1.00: cộng hưởng toàn phần, clear level.

### 8.2 Multi-channel Feedback Mapping
- Score thấp: rung ngắn, sắc, đứt nhịp; ánh sáng rời rạc.
- Score trung bình: rung pulse có chu kỳ; đường nối ổn định hơn.
- Score cao: rung mềm, liền; glow mượt; audio harmonic rõ.
- Hoàn thành: một haptic phrase đặc trưng + visual bloom ngắn.

### 8.3 Design Principle
Phản hồi phải **đủ thông tin để suy luận**, nhưng không được quá trực tiếp đến mức biến game thành “máy chỉ đáp án”.

### 8.4 Multi-Channel Feedback Architecture
Để tránh gameplay rơi vào trạng thái dò dẫm mù, hệ thống phản hồi không chỉ dùng một scalar score mà phải tách thành nhiều kênh nhận thức.

```swift
struct FeedbackVector {
    let macroHaptic: Double
    let ruleHarmonics: [RuleID: Double]
    let spatialWaveform: Waveform
}
```

- `macroHaptic`: báo mức độ cộng hưởng tổng thể.
- `ruleHarmonics`: mỗi rule có một “nốt” hoặc lớp âm thanh riêng.
- `spatialWaveform`: cho biết tín hiệu mạnh ở trục, vùng, hay hướng nào.

Nguyên tắc: người chơi phải biết mình đang tiến gần theo **chiều logic nào**, không chỉ biết tổng điểm đang tăng.

---

## 9. Accessibility & Fallback Design

Đây là phần bắt buộc ngay từ MVP.

### 9.1 Haptic Disabled Fallback
Nếu người dùng tắt rung hoặc máy ở trạng thái không phản hồi haptic tốt:
- Hiển thị sóng lan tỏa tương ứng.
- Dùng glow intensity và border thickness thay cho cường độ rung.
- Audio cue có thể bật tùy chọn.

### 9.2 Haptic Fatigue Prevention
- Không rung liên tục trong khi kéo.
- Áp dụng debounce khi finger move.
- Chỉ phát rung khi score band thay đổi hoặc có delta đủ lớn.
- Có “Low Sensory Mode” giảm cường độ haptic và hiệu ứng động.

### 9.3 Color & Vision Accessibility
- Không phụ thuộc màu đơn thuần để truyền thông tin.
- Có high contrast mode.
- Symbol overlays cho node states.

### 9.4 Cognitive Clarity
- 10 màn đầu phải dạy từng pattern riêng lẻ.
- Hint diễn giải bằng hình học, không spoiler toàn bộ đáp án.
- Có move budget hoặc checkpoint constraints ở một số mode để hạn chế brute-force.

---

## 10. Rủi ro thiết kế và cách khóa sớm

### 10.1 Ambiguity Risk
**Nguy cơ:** Người chơi thấy game quá mơ hồ, thành trial-and-error.

**Giải pháp:**
- Rule score phải phân rã được theo chiều cạnh logic, không chỉ tổng điểm.
- Tutorial phải cho người chơi thấy vì sao gần đúng.
- Mỗi level chỉ nên giới thiệu tối đa 1 rule mới trong giai đoạn đầu.
- Audio harmonic và visual waveform phải gợi đúng chiều sửa lỗi.

### 10.2 Performance Risk
**Nguy cơ:** SwiftUI re-render nặng khi drag nhiều node + hiệu ứng đồng thời.

**Giải pháp:**
- Board rendering ưu tiên `Canvas` cho lớp hiệu ứng.
- Node interaction dùng lightweight view model.
- Tách simulation state khỏi view state.
- Chỉ animate những phần cần thiết.
- Evaluate mạnh nhất tại snap-to-grid hoặc dwell event thay vì mỗi frame.

### 10.3 Novelty Risk
**Nguy cơ:** Ý tưởng mới nhưng chỉ hấp dẫn vài lần đầu.

**Giải pháp:**
- Bổ sung progression bằng biome/theme.
- Daily challenge có seed khác nhau.
- Weekly mechanics rotation.
- Có collection những resonance patterns đẹp để người chơi mở khóa.

### 10.4 Hardware Fragmentation Risk
**Nguy cơ:** Taptic Engine, ốp lưng, nhiệt độ máy và pin làm trải nghiệm không đồng đều giữa thiết bị.

**Giải pháp:**
- Có haptic calibration trong settings.
- Có fallback visual/audio tương đương.
- Theo dõi thermal state để giảm effect nặng.
- Lưu user sensory profile để cá nhân hóa phản hồi.

---

## 11. Kiến trúc kỹ thuật

### 11.1 Tech Stack
- UI: SwiftUI.
- Game logic: GameplayKit.
- Persistence: SwiftData.
- Sync: CloudKit thông qua SwiftData-compatible schema.
- Haptics: Core Haptics.
- Audio: AVAudioEngine hoặc system audio layer nhẹ.
- Analytics: custom lightweight events.

### 11.2 Architecture Style
Đề xuất kiến trúc phân lớp:
- Presentation Layer.
- Interaction Layer.
- Simulation Layer.
- Persistence Layer.
- Feedback Layer.

### 11.3 Suggested Modules
- `BoardSceneModel`
- `LevelRuleEngine`
- `ResonanceEvaluator`
- `HapticFeedbackOrchestrator`
- `AudioFeedbackOrchestrator`
- `SpatialWaveRenderer`
- `LevelRepository`
- `DailyChallengeService`
- `ProgressionService`
- `AccessibilityFeedbackMapper`
- `HapticCalibrationService`
- `ThermalGuardService`
- `ResonanceFingerprintGenerator`

---

## 12. GameplayKit Design

### 12.1 State Machine
Dùng `GKStateMachine` cho flow màn chơi:
- `IdleState`
- `DraggingState`
- `EvaluatingState`
- `SolvedState`
- `PausedState`
- `HintState`

### 12.2 Rule System
Dùng `GKRuleSystem` để mô hình hóa luật và facts.

Ví dụ facts:
- `distanceAlignment`
- `axisSymmetry`
- `signalContinuity`
- `quadrantBalance`
- `frequencyMatch`

Mỗi rule không chỉ assert đúng/sai mà đóng góp trọng số vào `resonanceScore`, đồng thời khai báo `outputChannel` để biết rule đó phản hồi mạnh qua haptic, audio hay visual.

### 12.3 Scoring Model
Đề xuất:
- Mỗi rule trả điểm con 0.0–1.0.
- Có trọng số theo độ quan trọng.
- Tổng hợp thành score cuối cùng.
- Có optional dimension breakdown để tutorial/hint sử dụng.

Pseudo formula:

`resonanceScore = sum(ruleScore[i] * weight[i]) / sum(weight[i])`

### 12.4 Level Generation
Level được tạo từ:
- Seed.
- Rule template.
- Difficulty budget.
- Allowed node types.
- Max move entropy.

Daily challenge chỉ cần lưu seed + version rule set.

---

## 13. Core Haptics Design

### 13.1 Engine Lifecycle
- Tạo `CHHapticEngine` sớm khi vào gameplay flow.
- Warm engine trước khi vào level để tránh latency.
- Resume engine khi app active trở lại.
- Fallback nếu engine unavailable.

### 13.2 Pattern Strategy
Dùng 2 loại pattern:
- Pre-authored `.ahap` cho success/failure phrases.
- Runtime-generated patterns cho feedback liên tục theo score.

### 13.3 Mapping Proposal
- `intensity` phản ánh độ chắc chắn.
- `sharpness` phản ánh độ lệch hoặc độ gắt.
- `tempo` phản ánh trạng thái tiến gần hay thụt lùi.

Ví dụ:
- Sai xa: intensity thấp-trung bình, sharpness cao.
- Gần đúng: intensity tăng dần, sharpness giảm dần.
- Gần hoàn thành: smooth pulse, khoảng nghỉ ngắn hơn.
- Success: phrase mềm, tròn, có cadence dễ nhớ.

### 13.4 Throttling Rules
- Không trigger mỗi frame.
- Chỉ update khi score delta vượt threshold.
- Có cooldown ngắn 60–120ms tùy interaction mode.
- Ưu tiên feedback ở snap-to-grid events hoặc khi dwell time vượt ngưỡng.

### 13.5 Hardware Adaptation Layer
- `HapticCalibrationService`: bài test 5 mức rung, lưu `userHapticScale` từ 0.5x đến 1.5x.
- `ThermalGuardService`: đọc `ProcessInfo.thermalState`, giảm hiệu ứng nặng khi máy nóng.
- `CaseCompensation`: cho phép người dùng chọn cảm giác rung yếu/vừa/mạnh để bù cho ốp lưng dày.
- `BatteryAwareMode`: khi pin yếu, giảm update frequency và tắt bớt phản hồi phụ.

---

## 14. Data Model

### 14.1 SwiftData Entities
- `PlayerProfile`
- `LevelDefinition`
- `LevelProgress`
- `DailyChallengeRecord`
- `HintUsage`
- `SettingsProfile`
- `UnlockedPattern`
- `SensoryCalibrationProfile`
- `ShareFingerprintRecord`

### 14.2 Example Fields
`LevelProgress`
- `levelID`
- `bestMoves`
- `bestTime`
- `stars`
- `solvedAt`
- `usedHint`

`DailyChallengeRecord`
- `date`
- `seed`
- `completed`
- `attemptCount`
- `bestScore`

`SensoryCalibrationProfile`
- `hapticScale`
- `audioAssistEnabled`
- `visualAssistLevel`
- `lowSensoryMode`

### 14.3 Sync Strategy
- Local-first.
- Auto-sync qua CloudKit khi có network.
- Conflict strategy: best-result merge hoặc latest-settings win.

---

## 15. UI/UX Direction

### 15.1 Visual Language
- Nền tối hoặc trung tính.
- Node là hình học đơn giản.
- Glow và wave là visual feedback chính.
- Typography ít, rõ, không gây áp lực.

### 15.2 Main Screens
- Home.
- Daily Challenge.
- Level Map / Collections.
- Gameplay Screen.
- Result Screen.
- Settings / Accessibility.
- Haptic Calibration.

### 15.3 Gameplay Screen Layout
- Top: level info, pause, hint.
- Center: board.
- Bottom: minimal controls, mode toggles nếu cần.

### 15.4 Delight Details
- Transition giữa màn như tuning frequency.
- Level clear animation ngắn, premium.
- Widget hiển thị daily streak hoặc daily seed.

---

## 16. Content Strategy

### 16.1 MVP Content
- 20 curated levels.
- 1 gameplay mode.
- 3 rule families.
- 1 daily challenge generator đơn giản.

### 16.2 Post-MVP Expansion
- 60–100 levels.
- Multi-theme biomes.
- Mirror mode.
- Silent mode.
- Tilt mode.
- Community seed sharing.

### 16.3 Difficulty Curve
- Màn 1–5: một rule duy nhất.
- Màn 6–10: kết hợp 2 rule nhưng feedback rất rõ.
- Màn 11–20: nhiễu nhẹ, blocker, modifier.

### 16.4 Viral Loop & Social Share
- `ResonanceFingerprintGenerator` sinh đồ thị hoặc waveform chia sẻ từ move history.
- Daily result share không lộ đáp án nhưng thể hiện phong cách giải.
- Có seed code để bạn bè mở cùng thử thách.
- Widget và streak ring tăng động lực quay lại hàng ngày.

---

## 17. Monetization

Đề xuất premium nhẹ hoặc hybrid tinh tế:
- Free core game + daily challenge.
- One-time unlock full level pack.
- Không nên quảng cáo chen giữa các màn vì phá mood.

Có thể thêm:
- Cosmetic themes.
- Expansion packs.
- Optional supporter pack.

---

## 18. Analytics cần theo dõi

### 18.1 Funnel
- Install.
- First session.
- First level clear.
- Day 1 / Day 7 retention.
- Daily challenge participation.
- Share usage rate.

### 18.2 Gameplay Metrics
- Time to solve.
- Moves per level.
- Hint rate.
- Rage quit point.
- Haptic enabled/disabled rate.
- Level retry count.
- Rule-specific confusion score.

### 18.3 Design Diagnostics
- Người chơi rời ở level nào.
- Rule nào gây mơ hồ cao nhất.
- Score delta per move có đủ rõ hay không.
- Tương quan giữa calibration profile và completion rate.

---

## 19. MVP Milestone Plan

### Phase 0 — Prototype Spike (1 tuần)
Mục tiêu:
- Test Core Haptics latency.
- Test drag interaction trên board 5x5.
- Test score-to-feedback mapping.
- Test calibration flow.
- Test snap-to-grid evaluator.

Deliverables:
- 1 sandbox board.
- 3 haptic patterns.
- 1 debug overlay hiển thị resonanceScore.
- 1 calibration screen.
- 1 prototype thermal guard toggle.
- 1 fingerprint SVG prototype.

### Phase 1 — Vertical Slice (2–3 tuần)
Mục tiêu:
- 1 mode chơi hoàn chỉnh.
- 10–20 level curated.
- Result screen + local save.

Deliverables:
- Core gameplay loop hoàn thiện.
- Tutorial cơ bản.
- Settings accessibility.
- Basic share output.

### Phase 2 — Systemization (2 tuần)
Mục tiêu:
- Rule templates.
- Seed-based generation.
- Daily challenge.

Deliverables:
- Generator v1.
- Daily record tracking.
- Progression data model.
- Share fingerprint v1.

### Phase 3 — Polish (2 tuần)
Mục tiêu:
- Tối ưu performance.
- Haptic balancing.
- Visual polish.
- Widget / iCloud sync nếu kịp.

Deliverables:
- Release candidate nội bộ.
- TestFlight build.

---

## 20. Team Notes cho implementation

### 20.1 Ưu tiên build order
1. Resonance scoring.
2. Feedback vector mapping.
3. Interaction feel.
4. Tutorial clarity.
5. Content pipeline.
6. Calibration and thermal safety.
7. Sync / meta systems.

### 20.2 Debug Tools nội bộ
Nên có:
- Overlay hiển thị từng rule score.
- Toggle tắt/mở haptic.
- Seed replay.
- Slow-motion animation mode.
- Heatmap số lần chạm / kéo.
- FeedbackVector inspector.

### 20.3 Quality Bar
Game chỉ nên ship nếu đạt:
- Latency phản hồi thấp.
- Không rối mắt.
- Không gây mỏi tay.
- Người chơi hiểu được nguyên lý tiến gần lời giải mà không cần đoán mò quá nhiều.
- Trải nghiệm ổn định trên nhiều loại thiết bị.

---

## 21. Đề xuất mở rộng tương lai

- Apple Watch companion cho daily micro-puzzle.
- Shared challenge qua iMessage.
- Adaptive puzzle generation dựa trên hành vi giải đố.
- Seasonal soundscape/theme packs.
- Vision Pro adaptation như một spatial sensory puzzle.

---

## 22. Kết luận định hướng sản phẩm

**Echo Grid** mạnh nhất khi giữ đúng ba nguyên tắc:
- đơn giản ở bề mặt,
- sâu ở hệ thống,
- tinh tế ở phản hồi giác quan.

Nếu triển khai tốt, đây không chỉ là một puzzle game đẹp mà còn là một sản phẩm thể hiện rất rõ “đây là game được sinh ra cho iPhone”.
