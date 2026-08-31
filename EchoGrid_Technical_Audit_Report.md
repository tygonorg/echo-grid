# Echo Grid — Code Audit & Technical Feasibility Assessment Report
**Tài liệu:** Báo cáo Rà soát Mã nguồn, Đánh giá Khả thi Kỹ thuật & Bảng điểm Phát hành  
**Dự án:** Echo Grid (iOS Indie Puzzle Game)  
**Phiên bản đánh giá:** v1.0 Release Candidate  
**Tác giả:** Principal iOS Engineer & System Architect  
**Ngày thực hiện:** 31/08/2026  

---

## MỤC LỤC
1. [Phần 1: Bảng điểm sẵn sàng phát hành (Production Readiness Scorecard)](#phần-1-bảng-điểm-sẵn-sàng-phát-hành-production-readiness-scorecard)
2. [Phần 2: Danh sách lỗi, rủi ro & Nợ kỹ thuật (Technical Debt & Vulnerabilities)](#phần-2-danh-sách-lỗi-rủi-ro--nợ-kỹ-thuật-technical-debt--vulnerabilities)
3. [Phần 3: Đánh giá độ khớp với Game Design (GDD Alignment)](#phần-3-đánh-giá-độ-khớp-với-game-design-gdd-alignment)
4. [Phần 4: Đánh giá khả năng mở rộng (Scalability Assessment)](#phần-4-đánh-giá-khả-năng-mở-rộng-scalability-assessment)
5. [Phần 5: Kết luận Kỹ thuật & Kế hoạch Hành động (Verdict & Action Plan)](#phần-5-kết-luận-kỹ-thuật--kế-hoạch-hành-động-verdict--action-plan)

---

## PHẦN 1: BẢNG ĐIỂM SẴN SÀNG PHÁT HÀNH (PRODUCTION READINESS SCORECARD)

| Tiêu chí Đánh giá | Điểm số (1-10) | Tình trạng | Nhận định Kỹ thuật Tổng quan |
| :--- | :---: | :---: | :--- |
| **1. Architecture & Layering** | **8.5 / 10** | **Tốt** | Tầng `Simulation` hoàn toàn độc lập với UI (`SwiftUI`/`UIKit`), tuân thủ chuẩn `Sendable`. Dữ liệu một chiều rõ ràng qua `GameplaySessionController`. |
| **2. Code Quality & Clean Code** | **8.0 / 10** | **Khá - Tốt** | Codebase cấu trúc mạch lạc, định danh chuẩn Swift API Guidelines. Tuy nhiên, vẫn sử dụng Combine `ObservableObject` thay vì Swift Observation (`@Observable`) và có hardcoded test fixtures trong Domain Model. |
| **3. Audio & Core Haptics** | **8.5 / 10** | **Tốt** | Triển khai `CHHapticEngine` + fallback `UIImpactFeedbackGenerator` chuẩn xác. `AVAudioPCMBuffer` được pre-cache với hàm sin envelope triệt tiêu pop/click; `AVAudioSession` xử lý ngắt quãng chuẩn `.ambient`. |
| **4. UI/UX Polish & 120Hz ProMotion** | **8.0 / 10** | **Khá - Tốt** | Kéo thả mượt mà với `@GestureState`, không lag 120Hz do defer tính toán rule sang `.onEnded`. SwiftUI `Canvas` render sóng đối xứng hiệu quả. Hạn chế về Dynamic Type. |
| **5. Content Engine & Determinism** | **5.0 / 10** | ⚠️ **Báo động** | Thuật toán SplitMix64 RNG hoạt động tất định nhưng bị phụ thuộc múi giờ thiết bị (`TimeZone.current`). **Phát hiện 3 màn chơi bị lỗi nghiêm trọng trong Content Repository (Màn 12 tự giải, Màn 14 và Màn 15 không thể giải được).** |
| **6. Apple Guidelines & Compliance** | **7.5 / 10** | **Khá** | `PrivacyInfo.xcprivacy` đạt chuẩn Zero Data Collection. Thiếu Target Widget Extension thực tế trong Xcode Project; VoiceOver chưa hỗ trợ Accessible Actions cho kéo thả. |
| **TỔNG KẾT TOÀN DỰ ÁN** | **7.6 / 10** | ⚠️ **CẦN FIX BLOCKERS** | **Chưa đủ điều kiện Submit ngay.** Cần vá dứt điểm 3 màn chơi hỏng và cấu hình Target Widget Extension. |

---

## PHẦN 2: DANH SÁCH LỖI, RỦI RO & NỢ KỸ THUẬT (TECHNICAL DEBT & VULNERABILITIES)

### 🔴 MỨC ĐỘ 1: CRITICAL (Lỗi Chặn Phát Hành - Must Fix Before Release)

#### 1. Lỗi logic màn chơi: Màn 14 & 15 không thể giải được (Unsolvable Levels), Màn 12 tự qua màn
- **Vị trí file:** [`Echo Grid/Content/LevelRepository.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Content/LevelRepository.swift)
- **Bản chất lỗi:**
  - **Màn 12 ("The Grid Matrix"):** `sources` rỗng (`[]`). Cả `VerticalSymmetryRule` và `HorizontalSymmetryRule` đều có guard `guard !sources.isEmpty else { return RuleEvaluation(score: 1.0, isSatisfied: true) }`. Khi mở Màn 12, game lập tức báo `isSolved = true` và hoàn thành với 0 bước đi.
  - **Màn 14 ("The Harmonic Cross"):** `sources` đặt tại `(0, 2)` và `(2, 0)`. Điểm đối xứng dọc của `(0, 2)` là chính nó `(0, 2)`, và điểm đối xứng ngang của `(2, 0)` là chính nó `(2, 0)`. Vì ô `(0, 2)` và `(2, 0)` đã bị chiếm bởi Source Node cố định, Movable Node không thể đặt vào đó. Kết quả: Màn 14 không bao giờ đạt đủ `matchedCount == 2` $\rightarrow$ **Người chơi bị kẹt vĩnh viễn không thể qua màn.**
  - **Màn 15 ("Zenith of Resonance"):** Target đối xứng dọc của `S1(0, 0)` là `(0, 4)`, của `S3(4, 4)` là `(4, 0)`. Nhưng `LevelRepository` lại đặt 2 Blocker `B1(0, 4)` và `B2(4, 0)` ngay tại đúng 2 ô mục tiêu này! Đồng thời Màn 15 có thêm `CollinearAlignmentRule()`. Vì ô mục tiêu bị vật cản khóa cứng, người chơi không thể hoàn thành màn $\rightarrow$ **Màn chơi cuối cùng của game bị Block 100%.**
- **Giải pháp khắc phục:** Cập nhật lại tọa độ Anchor, Blocker và Movable trong [`LevelRepository.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Content/LevelRepository.swift):
```swift
// Sửa Màn 12: Đặt 2 source node để làm chuẩn đối xứng
NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 2)),
NodeState(id: "S2", type: .source, position: CellPosition(row: 4, col: 2))

// Sửa Màn 14: Dịch chuyển source để điểm đối xứng rơi vào ô trống
NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 1)), // Mirror -> (0, 3)
NodeState(id: "S2", type: .source, position: CellPosition(row: 1, col: 0))  // Mirror -> (3, 0)

// Sửa Màn 15: Dời Blocker ra khỏi trục đối xứng của các Anchor
NodeState(id: "B1", type: .blocker, position: CellPosition(row: 1, col: 2)),
NodeState(id: "B2", type: .blocker, position: CellPosition(row: 3, col: 2))
```

---

#### 2. Lỗi reset chuỗi ngày Streak khi mở app vào đầu ngày mới
- **Vị trí file:** [`Echo Grid/Persistence/DailyChallengeManager.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Persistence/DailyChallengeManager.swift)
- **Bản chất lỗi:** Trong hàm `recalculateStreak()`, nếu người chơi vừa thức dậy mở app vào ngày mới (hôm nay chưa chơi), biến `history[todayStr]?.isCompleted` trả về `false`. Vòng lặp `while true` lập tức kiểm tra `checkDate` (vẫn là hôm nay) $\rightarrow$ `history[todayStr]` không có $\rightarrow$ nhảy vào `else { break }` và gán `self.currentStreak = 0`.
- **Hệ quả:** Người chơi đang có chuỗi 30 ngày Streak, sáng ngủ dậy bật app lên thấy Streak biến thành 0 ngày, gây ức chế tâm lý nghiêm trọng.
- **Giải pháp khắc phục:** Nếu hôm nay chưa hoàn thành, điểm bắt đầu kiểm tra Streak phải là **hôm qua (yesterday)**:
```swift
private func recalculateStreak() {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    var checkDate = Date()
    var streak = 0
    let todayStr = formatter.string(from: checkDate)
    
    if history[todayStr]?.isCompleted == true {
        streak += 1
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { return }
        checkDate = yesterday
    } else {
        // Nếu hôm nay chưa giải, lùi về hôm qua để kiểm tra duy trì chuỗi
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { return }
        checkDate = yesterday
    }
    
    while true {
        let dateStr = formatter.string(from: checkDate)
        if history[dateStr]?.isCompleted == true {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prev
        } else {
            break
        }
    }
    self.currentStreak = streak
    if streak > maxStreak {
        self.maxStreak = streak
        UserDefaults.standard.set(maxStreak, forKey: maxStreakKey)
    }
    UserDefaults.standard.set(currentStreak, forKey: streakKey)
}
```

---

#### 3. Thiếu Target Widget Extension thực tế trong cấu trúc Xcode Project
- **Vị trí file:** [`Echo Grid.xcodeproj/project.pbxproj`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid.xcodeproj/project.pbxproj) và [`Echo Grid/Widgets/EchoGridWidgetView.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Widgets/EchoGridWidgetView.swift)
- **Bản chất lỗi:** Trong code đã có sẵn SwiftUI Views cho Widget (`EchoGridWidgetSmallView`, `EchoGridWidgetMediumView`), nhưng trong Project File chỉ có duy nhất 1 Target App chính (`com.apple.product-type.application`). Không hề có Target `com.apple.product-type.app-extension` dành cho WidgetKit.
- **Hệ quả:** Widget không thể xuất hiện trên màn hình chính (Home Screen) của người dùng.
- **Giải pháp khắc phục:** Tạo App Extension Target `EchoGridWidget` trong Xcode, tạo file cấu hình `@main struct EchoGridWidgetBundle: WidgetBundle` kèm `TimelineProvider` và liên kết chung qua App Group `group.tygon.org.echogrid`.

---

### 🟡 MỨC ĐỘ 2: MAJOR (Ảnh hưởng Trải nghiệm & Ổn định - High Priority)

#### 4. Phụ thuộc Múi giờ Thiết bị trong Daily Challenge Seed
- **Vị trí file:** [`Echo Grid/Persistence/DailyChallengeManager.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Persistence/DailyChallengeManager.swift)
- **Rủi ro:** Sử dụng `formatter.timeZone = TimeZone.current`. Người chơi ở các múi giờ khác nhau khi chia sẻ mã seed hoặc so sánh với bạn bè quốc tế sẽ nhận màn chơi khác nhau tại cùng một thời điểm. Nếu người dùng đổi múi giờ thủ công trên máy, họ có thể exploit Daily Challenge.
- **Khắc phục:** Chuẩn hóa `todayDateKey` theo `TimeZone(identifier: "UTC")!` hoặc chuẩn hóa mốc Midnight thống nhất toàn cầu.

#### 5. `CHHapticEngine` thiếu `stoppedHandler` & Thread Safety khi chạy nền
- **Vị trí file:** [`Echo Grid/Feedback/HapticFeedbackOrchestrator.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Feedback/HapticFeedbackOrchestrator.swift)
- **Rủi ro:** Hiện chỉ có `resetHandler`. Nếu hệ điều hành tạm dừng haptics do audio route chuyển sang thiết bị khác, hoặc cuộc gọi đến khiến `CHHapticEngine` bị stop (`stoppedHandler`), engine sẽ không tự khôi phục cờ trạng thái.
- **Khắc phục:** Thêm callback `hapticEngine?.stoppedHandler = { reason in ... }` để restart engine khi app trở lại trạng thái Foreground.

#### 6. Board Grid không hạ tải hiệu ứng đồ họa khi máy nóng (Thermal Throttling)
- **Vị trí file:** [`Echo Grid/Views/BoardGridView.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Views/BoardGridView.swift) và [`Echo Grid/Core/ThermalBatteryGuard.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Core/ThermalBatteryGuard.swift)
- **Rủi ro:** `ThermalBatteryGuard` đã theo dõi `ProcessInfo.ThermalState` và hạ `hapticScale`, nhưng `BoardGridView.swift` không lắng nghe `ThermalBatteryGuard.shared.isThrottled`. Các hiệu ứng nặng như `blur(radius: 3)`, `RadialGradient`, `LinearGradient` và `Canvas` vẫn render liên tục ngay cả khi máy ở trạng thái `.critical` hoặc Chế độ Nguồn Điện Thấp (Low Power Mode).
- **Khắc phục:** Đưa biến `@ObservedObject private var thermalGuard = ThermalBatteryGuard.shared` vào `BoardGridView` để tắt bỏ `blur` và `RadialGradient` khi `thermalGuard.isThrottled == true`.

---

### 🟢 MỨC ĐỘ 3: MINOR (Tối ưu hóa Code & Tiêu chuẩn App Store)

#### 7. Thiếu bản dịch cho 5 ngôn ngữ đã khai báo trong Settings
- **Vị trí file:** [`Echo Grid/Localization/LocalizationManager.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Localization/LocalizationManager.swift)
- **Hiện trạng:** `AppLanguage.swift` cho phép chọn 8 ngôn ngữ (English, Tiếng Việt, 日本語, 한국어, Español, Français, Deutsch, 简体中文), nhưng từ điển dịch `translations` mới chỉ có dữ liệu cho **English, Tiếng Việt và 日本語**. 5 ngôn ngữ còn lại âm thầm fallback về English.
- **Khắc phục:** Bổ sung đầy đủ chuỗi bản dịch cho 5 ngôn ngữ còn lại hoặc tạm thời ẩn các ngôn ngữ chưa hoàn thiện khỏi `AppLanguage.allCases`.

#### 8. Hỗ trợ Tiếp cận VoiceOver thiếu Accessible Drag Actions
- **Vị trí file:** [`Echo Grid/Views/BoardGridView.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Views/BoardGridView.swift)
- **Hiện trạng:** Các Node đã có `.accessibilityLabel` và `.accessibilityHint` chi tiết, nhưng thao tác di chuyển phụ thuộc 100% vào `DragGesture`. Người khiếm thị dùng VoiceOver không thể thực hiện thao tác kéo thả tự do.
- **Khắc phục:** Bổ sung `.accessibilityAdjustableAction` hoặc Custom Accessibility Actions ("Di chuyển lên", "Di chuyển xuống", "Di chuyển sang trái", "Di chuyển sang phải") để thay đổi `CellPosition`.

#### 9. Trộn lẫn Test Fixture vào Production Model
- **Vị trí file:** [`Echo Grid/Models/BoardState.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Models/BoardState.swift)
- **Hiện trạng:** Hàm `makePhase0ValidationOpening()` (tạo bàn cờ test cho prototype Phase 0) được viết trực tiếp trong struct `BoardState`.
- **Khắc phục:** Tách các mock/fixture data sang extension trong file riêng hoặc target Unit Test.

---

## PHẦN 3: ĐÁNH GIÁ ĐỘ KHỚP VỚI GAME DESIGN (GDD ALIGNMENT)

Bảng đối chiếu giữa các tài liệu đặc tả (GDD v1.1, GDD v1.2, Technical Architecture v1, MVP Backlog) và hiện trạng source code thực tế:

```
[GDD / Backlog Specification]              [Actual Code Implementation]         [Status]
EG-001: 5x5 Board Prototype -------------> BoardGridView.swift (5x5 Grid) -----> [MATCH - 100%]
EG-002: Drag & Snap Interaction ---------> @GestureState + Spring Snap ---------> [MATCH - 100%]
EG-003: Resonance Evaluator -------------> ResonanceEvaluator.swift -----------> [MATCH - 100%]
EG-004: Haptic Feedback Orchestration ---> HapticFeedbackOrchestrator.swift ----> [MATCH - 95%] (Thiếu cooldown throttle trong Continuous Drag)
EG-005: Calibration Screen --------------> HapticCalibrationView (5 mức) ------> [MATCH - 100%]
EG-006: 15 Curated Levels ---------------> LevelRepository.swift --------------> [DEFECT ⚠️] (Màn 12 tự win, Màn 14, 15 unsolvable)
EG-007: Alignment & Distance Rules ------> Collinear & Equidistant Rules -------> [MATCH - 100%]
EG-008: Progress Persistence & Stars ----> ProgressManager.swift (UserDefaults) -> [MATCH - 100%]
EG-009: Production Gameplay UI ----------> GameplayView + ClearModalView -------> [MATCH - 100%]
EG-010: Chapter & Level Select Navigation> LevelSelectView (3 Chapters) --------> [MATCH - 100%]
EG-011: Seed-based Level Generator ------> LevelGenerator.swift (SplitMix64) ---> [MATCH - 95%] (Chưa cố định UTC timezone)
EG-012: Daily Challenge & Streak --------> DailyChallengeManager.swift ---------> [DEFECT ⚠️] (Streak reset về 0 đầu ngày)
EG-013: Hint Engine v1 ------------------> HintEngine.swift (30s Cooldown) -----> [MATCH - 100%]
EG-014: Resonance Fingerprint Share -----> ResonanceFingerprintGenerator.swift --> [MATCH - 100%]
EG-015: Player Stats & Onboarding -------> PlayerStatsView + TutorialView ------> [MATCH - 100%]
EG-016: Thermal & Battery Guard ---------> ThermalBatteryGuard.swift -----------> [MATCH - 85%] (Chưa nối vào BoardGridView render)
EG-017: Audio Session Interruption ------> AudioSessionCoordinator.swift -------> [MATCH - 100%]
EG-018: WidgetKit Home Screen -----------> EchoGridWidgetView.swift -----------> [DEFECT ⚠️] (Chưa tạo Target Extension trong Xcode)
EG-019: VoiceOver Accessibility ---------> BoardGridView.swift (Labels & Hints) -> [MATCH - 80%] (Chưa có Accessibility Actions)
EG-020: Privacy Manifest ----------------> PrivacyInfo.xcprivacy (Zero Data) ---> [MATCH - 100%]
```

### Nhận định về Định vị Thiết kế (GDD v1.2 Pivot Alignment):
- Trong **GDD v1.2**, câu hỏi chiến lược đặt ra là: **Direction A (Haptic-First)** hay **Direction B (Visual-First with Haptic Delight)**.
- Codebase hiện tại đã giải quyết xuất sắc mâu thuẫn này bằng việc xây dựng **`FeedbackMode` kép** (`FeedbackMode.swift`):
  - `.hapticOnly`: Tắt toàn bộ đường dẫn sáng và sóng âm, phục vụ đo lường validation thực tế.
  - `.fullSensory`: Bật đầy đủ glow trục đối xứng, kết nối visual canvas và âm thanh hòa âm.
- Bộ công cụ Telemetry tích hợp sẵn trong `SessionLogger.swift` và `SessionSummaryView.swift` cho phép chạy Playtest thực tế, đo tỷ lệ Trial/Error, số lần dao động (Oscillation) và xuất JSON khảo sát ngay trên thiết bị.

---

## PHẦN 4: ĐÁNH GIÁ KHẢ NĂNG MỞ RỘNG (SCALABILITY ASSESSMENT)

```
                       ┌─────────────────────────────────────┐
                       │          PRESENTATION LAYER         │
                       │ (SwiftUI Views, Widget, Modals)     │
                       └──────────────────┬──────────────────┘
                                          │ Observes / Triggers
                                          ▼
                       ┌─────────────────────────────────────┐
                       │          INTERACTION LAYER          │
                       │   (GameplaySessionController)       │
                       └───────┬─────────────────────┬───────┘
                               │                     │
                Evaluates state│                     │Dispatches feedback
                               ▼                     ▼
┌──────────────────────────────────────────┐  ┌──────────────────────────────────────────┐
│             SIMULATION LAYER             │  │              FEEDBACK LAYER            │
│  ┌────────────────────────────────────┐  │  │  ┌────────────────────────────────────┐  │
│  │     protocol RuleEvaluator         │  │  │  │  HapticFeedbackOrchestrator        │  │
│  │ (Vertical, Horizontal, Alignment)  │  │  │  │  (CHHapticEngine + UIFeedback)     │  │
│  └────────────────────────────────────┘  │  │  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │  │  ┌────────────────────────────────────┐  │
│  │      ResonanceEvaluator (Core)     │  │  │  │  AudioSynthesizerOrchestrator      │  │
│  └────────────────────────────────────┘  │  │  │  (AVAudioEngine + PCM Buffers)     │  │
│  ┌────────────────────────────────────┐  │  │  └────────────────────────────────────┘  │
│  │   LevelGenerator / HintEngine      │  │  └──────────────────────────────────────────┘
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

### 1. Khả năng thêm Quy luật mới (Rule Extensibility): **RẤT XUẤT SẮC (10/10)**
- Giao thức `RuleEvaluator` được thiết kế tối giản và thuần khiết:
  ```swift
  public protocol RuleEvaluator: Sendable {
      var id: String { get }
      var weight: Double { get }
      func evaluate(board: BoardState) -> RuleEvaluation
  }
  ```
- Khi cần thêm quy luật mới (ví dụ: `RotationalSymmetryRule`, `ManhattanDistanceRule`, `EulerianPathRule`), kỹ sư **chỉ cần tạo 1 struct mới** conform `RuleEvaluator` mà không cần chỉnh sửa bất kỳ dòng code nào trong `GameplayView` hay `GameplaySessionController`.

### 2. Khả năng mở rộng Màn chơi hàng loạt (Content Scaling): **XUẤT SẮC (9/10)**
- `LevelDefinition` mang tính chất Data-Driven. Việc mở rộng từ 15 màn lên 100 màn hoặc nạp level từ file JSON từ xa (Remote Config / Backend API) hoàn toàn khả thi mà không phải thay đổi kiến trúc cơ sở.

### 3. Khả năng tích hợp iCloud Sync & Game Center Leaderboards: **DỄ DÀNG (8.5/10)**
- Hiện tại dữ liệu lưu trữ qua `UserDefaults` và được mã hóa sạch sẽ bằng `JSONEncoder`/`JSONDecoder` trong `ProgressManager` (`[Int: LevelProgressRecord]`) và `DailyChallengeManager` (`[String: DailyChallengeRecord]`).
- Cấu trúc struct đã conform đầy đủ `Codable, Hashable, Sendable`. Để nâng cấp lên iCloud Sync, chỉ cần chuyển đổi storage backend sang `NSUbiquitousKeyValueStore` hoặc `SwiftData` + `CloudKit` mà không làm thay đổi Domain Logic.
- Game Center: Điểm số Daily Moves và Stars có thể gửi trực tiếp lên `GKLeaderboard` thông qua hàm `recordLevelClear()`.

---

## PHẦN 5: KẾT LUẬN KỸ THUẬT & KẾ HOẠCH HÀNH ĐỘNG (VERDICT & ACTION PLAN)

### ⚖️ KẾT LUẬN CỦA PRINCIPAL ARCHITECT:
> **TÌNH TRẠNG HIỆN TẠI: ⚠️ CHƯA ĐỦ ĐIỀU KIỆN ĐỂ SUBMIT LÊN APP STORE.**  
> Dự án sở hữu nền tảng kiến trúc rất vững chắc, tầng xử lý giác quan (Core Haptics & Audio PCM) được xây dựng kỹ lưỡng và hiệu năng đồ họa tối ưu tốt. Tuy nhiên, **game tồn tại 3 màn chơi bị hỏng logic cốt lõi (Màn 12, 14, 15) và lỗi reset Streak hàng ngày**. Đây là các lỗi nghiêm trọng (Release Blockers) sẽ khiến game bị đánh giá 1 sao hoặc bị Apple từ chối duyệt nếu reviewer kiểm tra sâu.

---

### 📋 DANH MỤC CÁC BƯỚC BẮT BUỘC HOÀN THIỆN TRƯỚC KHI SUBMIT:

```
[BƯỚC 1: SỬA LỖI NỘI DUNG MÀN CHƠI - BLOCKER SỐ 1]
  ├── Cập nhật tọa độ Level 12 trong LevelRepository.swift (thêm 2 source nodes).
  ├── Cập nhật tọa độ Level 14 trong LevelRepository.swift (tránh trùng tọa độ mirror).
  └── Cập nhật tọa độ Level 15 trong LevelRepository.swift (dời blocker khỏi điểm đối xứng).

[BƯỚC 2: SỬA LOGIC STREAK HÀNG NGÀY - BLOCKER SỐ 2]
  └── Sửa hàm recalculateStreak() trong DailyChallengeManager.swift (kiểm tra lùi từ ngày hôm qua).

[BƯỚC 3: HOÀN THIỆN WIDGET EXTENSION TARGET - BLOCKER SỐ 3]
  ├── Mở Xcode, thêm Target "EchoGridWidget" (Widget Extension).
  ├── Nhúng EchoGridWidgetView.swift vào Target mới.
  └── Cấu hình App Group "group.tygon.org.echogrid" để chia sẻ dữ liệu Streak giữa App và Widget.

[BƯỚC 4: TỐI ƯU HÓA HOÀN THIỆN (POLISH)]
  ├── Nối ThermalBatteryGuard.isThrottled vào BoardGridView để tự động tắt hiệu ứng khi máy nóng.
  ├── Bổ sung callback stoppedHandler vào HapticFeedbackOrchestrator.swift.
  └── Bổ sung Accessible Actions cho VoiceOver trên các Draggable Node.
```
