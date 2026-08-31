# 🌌 Echo Grid — Game Giải Đố Suy Luận Bằng Giác Quan (iOS)

[![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-6.0%20%2F%20SwiftUI-orange.svg)](https://swift.org)
[![Architecture](https://img.shields.io/badge/Kiến%20trúc-Clean%20%2F%20Layered%20Simulation-purple.svg)](./EchoGrid_Technical_Architecture_v1.md)
[![Status](https://img.shields.io/badge/Trạng%20thái-v1.0%20Hoàn%20tất%20(Sprints%201--4)-success.svg)](./EchoGrid_MVP_Backlog.md)

> **Echo Grid** là tựa game giải đố không gian 5×5 trên iPhone, kết hợp giữa phản hồi xúc giác rung cao cấp (**Apple Core Haptics**) và bộ tạo âm thanh hòa âm (**Audio Synthesizer**). Người chơi giải các câu đố không phải bằng việc đọc chữ hướng dẫn phức tạp, mà bằng cách **lắng nghe âm thanh** và **cảm nhận độ rung trực quan** trên đầu ngón tay để suy luận ra các quy luật hình học ẩn.

---

## 📖 Mục Lục
1. [Tổng Quan Game & Cơ Chế Cốt Lõi](#-tổng-quan-game--cơ-chế-cốt-lõi)
2. [Các Tính Năng Nổi Bật](#-các-tính-năng-nổi-bật)
3. [Tài Liệu & Hướng Dẫn Cách Chơi](#-tài-liệu--hướng-dẫn-cách-chơi)
4. [Hướng Dẫn Build & Chạy Ứng Dụng](#-hướng-dẫn-build--chạy-ứng-dụng)
5. [Kiến Trúc Kỹ Thuật & Cấu Trúc Thư Mục](#-kiến-trúc-kỹ-thuật--cấu-trúc-thư-mục)
6. [Tài Liệu Phát Triển (Dành Cho Developer)](#-tài-liệu-phát-triển-dành-cho-developer)
7. [Tiêu Chuẩn Xuất Bản App Store & Bảo Mật](#-tiêu-chuẩn-xuất-bản-app-store--bảo-mật)

---

## 🌟 Tổng Quan Game & Cơ Chế Cốt Lõi

Trong **Echo Grid**, mỗi màn chơi ẩn chứa một quy luật hình học hoặc khoảng cách (như đối xứng trục dọc, phản chiếu trục ngang, hoặc xếp thẳng hàng). Người chơi kéo và thả các điểm phát sáng trên bàn cờ 5×5. Mỗi khi di chuyển một điểm, game sẽ phản hồi trực tiếp:

- **Ở xa vị trí đúng (0% – 40%)**: Máy rung một nhịp trầm nhẹ, âm thanh nốt trầm thấp (C4).
- **Tiến gần vị trí đúng (41% – 85%)**: Máy rung 2 nhịp sắc nét rõ ràng, âm thanh chuyển sang nốt cao hơn (E4 / G4).
- **Rất gần vị trí đúng (86% – 99%)**: Máy rung nhịp dứt khoát tần số cao, âm thanh thanh thoát (A4).
- **Hoàn thành màn chơi (100% Solved)**: Bùng nổ chuỗi rung chúc mừng và phát hợp âm C Major ngân vang.

---

## 🚀 Các Tính Năng Nổi Bật

### 1. Gói 15 Màn Chơi Qua 3 Chương (Curated Levels)
- **Chương 1: Phản Chiếu (The Mirror)** (Màn 1–5): Làm quen với phản chiếu qua trục dọc và trục ngang cơ bản.
- **Chương 2: Căn Tuyến & Chướng Ngại Vật (Harmonics & Barriers)** (Màn 6–10): Giới thiệu luật xếp thẳng hàng (ngang, dọc, chéo), khoảng cách đều và node vật cản cố định.
- **Chương 3: Cộng Hưởng Tổng Hợp (Resonance Synthesis)** (Màn 11–15): Đa quy luật phức hợp kết hợp cùng lúc, thử thách khả năng suy luận logic giác quan.

### 2. Thử Thách Mỗi Ngày (Daily Challenge & Streak)
- Sử dụng thuật toán sinh số giả ngẫu nhiên tất định (Seeded SplitMix64 RNG) dựa trên chuỗi ngày `YYYY-MM-DD`. Mọi người chơi trên thế giới đều nhận chung một câu đố mỗi ngày kể cả khi offline.
- Tự động theo dõi chuỗi ngày chơi liên tiếp (**Daily Streak 🔥**) và kỷ lục chuỗi ngày dài nhất (**Max Streak 🏆**).

### 3. Dấu Ấn Cộng Hưởng & Chia Sẻ Mạng Xã Hội (Resonance Fingerprint)
- Kết xuất card ảnh đồ thị sóng (`UIImage`) phong cách Wordle (bảo mật đáp án) thể hiện độ mượt mà và thời gian giải của bạn.
- Tích hợp sẵn nút chia sẻ hệ thống iOS (UIActivityViewController) để gửi nhanh qua Threads, X, Instagram, iMessage, Zalo.

### 4. Hướng Dẫn Tương Tác Trực Quan (Interactive Onboarding Tutorial)
- Chuỗi 3 bước hướng dẫn cực kỳ trực quan với **hoạt ảnh ngón tay trượt liên tục** chỉ dẫn chính xác ô mục tiêu trên lưới cờ.

### 5. Hỗ Trợ Đa Ngôn Ngữ Toàn Cầu (8 Thứ Tiếng)
- 🇺🇸 English, 🇻🇳 Tiếng Việt, 🇯🇵 日本語, 🇰🇷 한국어, 🇪🇸 Español, 🇫🇷 Français, 🇩🇪 Deutsch, 🇨🇳 简体中文.
- Tự động nhận diện ngôn ngữ máy và cho phép đổi ngôn ngữ tức thời trong phần Cài đặt.

### 6. Tối Ưu Nền Tảng iOS Chuyên Nghiệp
- **Widget Màn hình chính iOS (WidgetKit)**: Widget kích thước Small & Medium hiển thị Streak và mở nhanh vào Daily qua link `echogrid://daily`.
- **Bảo vệ Pin & Tản nhiệt (Thermal & Battery Guard)**: Tự động hạ xung rung khi máy nóng hoặc bật Chế độ Tiết kiệm Pin.
- **Xử lý Cuộc gọi & Tai nghe**: Tự động pause/resume âm thanh khi có cuộc gọi đến hoặc khi cắm/rút AirPods.
- **Tiếp cận cho người khiếm thị (VoiceOver)**: Nhãn giọng đọc mô tả chi tiết từng ô cờ và node.
- **Hồ sơ bảo mật App Store (`PrivacyInfo.xcprivacy`)**: Đảm bảo 100% offline, zero data collection.

---

## 🎮 Tài Liệu & Hướng Dẫn Cách Chơi

### 1. Các Thành Phần Trên Bàn Cờ
| Biểu tượng | Tên gọi | Chức năng |
| :---: | :--- | :--- |
| ⚪ | **Chấm Trắng (Anchor Node)** | Mỏ neo cố định, không thể kéo di chuyển. Là điểm mốc để tạo đối xứng hoặc đường thẳng. |
| 🔵 | **Chấm Xanh (Resonance Point)** | Điểm cộng hưởng có thể chạm và kéo thả tự do đến các ô trống. |
| ⬛ | **Ô Vật Cản (Obstacle Blocker)** | Vị trí chướng ngại vật cố định, không thể đặt điểm sáng lên trên. |

### 2. Bảng Tra Cứu Phản Hồi Giác Quan
| Mức độ Đúng | Phản hồi Rung (Haptics) | Âm thanh Hòa âm (Audio) | Ý nghĩa |
| :---: | :--- | :--- | :--- |
| **0% – 40%** | Rung 1 nhịp trầm nhẹ (0.3x) | Nốt C4 (261.6 Hz) | Rất xa vị trí đúng |
| **41% – 85%** | Rung 2 nhịp sắc nét (0.75x) | Nốt E4 / G4 (329 – 392 Hz) | Đang tiến lại gần đúng |
| **86% – 99%** | Rung nhịp tần số cao (1.0x) | Nốt A4 (440 Hz) | Rất gần nghiệm |
| **100% Solved** | Bùng nổ hợp âm rung liên hoàn | Hợp âm C Major (523 Hz) | **Cộng Hưởng Hoàn Tất! ✨** |

### 3. Quy Tắc Chấm Điểm Sao (Star Ratings)
- ⭐️⭐️⭐️ **(3 Sao)**: Giải câu đố với số bước đi $\le$ Số bước tiêu chuẩn (*Par Moves*).
- ⭐️⭐️ **(2 Sao)**: Số bước đi $\le \text{Par Moves} + 2$.
- ⭐️ **(1 Sao)**: Hoàn thành câu đố với số bước đi $> \text{Par Moves} + 2$.

---

## 🛠 Hướng Dẫn Build & Chạy Ứng Dụng

### Yêu Cầu Môi Trường
- **Hệ điều hành**: macOS Sonoma 14.0 hoặc macOS Sequoia 15.0 trở lên.
- **Phần mềm**: Xcode 16.0 trở lên.
- **Thiết bị chạy**: iOS 17.0+ (Simulator hoặc iPhone/iPad thực tế).

### Các Bước Thực Hiện Trên Xcode
1. Mở thư mục dự án trên Terminal hoặc Finder:
   ```bash
   cd "/Users/tphung/Documents/project/Echo Grid"
   ```
2. Khởi chạy file project Xcode:
   ```bash
   open "Echo Grid.xcodeproj"
   ```
3. Trên thanh công cụ Xcode, chọn thiết bị đích (ví dụ: **iPhone 16 Pro** hoặc iPhone cá nhân của bạn).
4. Nhấn tổ hợp phím **`Cmd + R`** (hoặc bấm nút **Play ▶**) để biên dịch và trải nghiệm game.

### Chạy Kiểm Thử Tự Động Qua Dòng Lệnh (CLI)
Bạn có thể chạy toàn bộ 4 bộ test tự động mà không cần mở Xcode:
```bash
# Chạy toàn bộ các bài test mô phỏng và tính năng
swift -module-cache-path ./.swift-cache scratch/test_simulation.swift
swift -module-cache-path ./.swift-cache scratch/test_sprint1_2.swift
swift -module-cache-path ./.swift-cache scratch/test_sprint3.swift
swift -module-cache-path ./.swift-cache scratch/test_sprint4.swift
```

---

## 🏛 Kiến Trúc Kỹ Thuật & Cấu Trúc Thư Mục

Dự án áp dụng kiến trúc phân tầng rõ ràng (Clean Architecture), tách biệt giữa logic toán học, cảm giác giác quan, lưu trữ dữ liệu và giao diện SwiftUI:

```text
Echo Grid/
├── Core/
│   └── ThermalBatteryGuard.swift        # Quản lý tản nhiệt & chế độ tiết kiệm pin
├── Models/
│   ├── CellPosition.swift               # Toán học tọa độ lưới 2D & khoảng cách Manhattan
│   ├── NodeState.swift                  # Mô hình các loại node (.source, .receiver, .blocker)
│   ├── BoardState.swift                 # Biểu diễn trạng thái bàn cờ 5x5
│   └── LevelDefinition.swift            # Định nghĩa metadata màn chơi, par moves và luật
├── Simulation/
│   ├── RuleEvaluator.swift              # Protocol đánh giá quy luật hình học
│   ├── VerticalSymmetryRule.swift       # Luật đối xứng trục dọc (Cột 2)
│   ├── HorizontalSymmetryRule.swift     # Luật đối xứng trục ngang (Hàng 2)
│   ├── CollinearAlignmentRule.swift     # Luật căn thẳng hàng (hàng, cột, đường chéo)
│   ├── EquidistantSpacingRule.swift     # Luật khoảng cách đều nhau
│   ├── ResonanceEvaluator.swift         # Bộ tổng hợp điểm số từ nhiều luật
│   ├── LevelGenerator.swift             # Bộ sinh câu đố ngẫu nhiên tất định (Seed SplitMix64)
│   └── HintEngine.swift                 # Động cơ gợi ý thông minh không làm lộ đáp án
├── Feedback/
│   ├── FeedbackMode.swift               # Chế độ trải nghiệm (.fullSensory, .hapticOnly)
│   ├── HapticFeedbackOrchestrator.swift # Bộ điều phối rung Apple Core Haptics
│   ├── AudioSynthesizerOrchestrator.swift # Bộ tạo âm thanh hòa âm nạp sẵn bộ đệm
│   └── AudioSessionCoordinator.swift    # Xử lý gián đoạn âm thanh khi có cuộc gọi / AirPods
├── Localization/
│   ├── AppLanguage.swift                # Danh sách 8 ngôn ngữ quốc tế hỗ trợ
│   └── LocalizationManager.swift        # Quản lý từ điển đa ngôn ngữ thời gian thực
├── Persistence/
│   ├── LevelProgressRecord.swift        # Model lưu kỷ lục số bước, thời gian, số sao
│   ├── UserSettingsRecord.swift         # Model lưu cài đặt âm thanh, rung, ngôn ngữ
│   ├── ProgressManager.swift            # Singleton quản lý tiến trình mở khóa màn chơi
│   ├── DailyChallengeRecord.swift       # Model lưu kết quả màn chơi Daily
│   └── DailyChallengeManager.swift      # Quản lý chuỗi ngày streak và câu đố hôm nay
├── Social/
│   └── ResonanceFingerprintGenerator.swift # Tạo ảnh card đồ thị sóng và text chia sẻ
├── Telemetry/
│   └── SessionLogger.swift              # Ghi log dữ liệu kiểm thử Phase 0
├── Views/
│   ├── SplashLoadingView.swift          # Màn hình loading Zen phản hồi 0ms
│   ├── MainMenuView.swift               # Menu chính phong cách tối giản
│   ├── TutorialOnboardingView.swift     # Màn hình hướng dẫn 3 bước kèm hoạt ảnh trượt
│   ├── LevelSelectView.swift            # Lưới chọn 15 màn chơi theo Chương
│   ├── GameplayView.swift               # Màn hình chơi chính thức (đếm bước, par, đồng hồ)
│   ├── DailyChallengeView.swift         # Màn hình chơi Thử thách Mỗi ngày kèm nút Gợi ý
│   ├── LevelClearModalView.swift        # Pop-up chúc mừng chiến thắng kèm sao
│   ├── ShareFingerprintSheetView.swift  # Xem trước card ảnh và mở iOS Share Sheet
│   ├── PlayerStatsView.swift            # Bảng thống kê chuỗi streak, tỷ lệ thắng, sao
│   ├── HapticCalibrationView.swift      # Giao diện thử và chỉnh 5 mức rung
│   ├── SettingsView.swift               # Cài đặt ngôn ngữ, âm thanh, rung, reset
│   ├── BoardGridView.swift              # Bàn cờ 5x5 tương tác kéo thả mượt mà 120 FPS
│   └── DebugOverlayView.swift           # Bảng HUD thông số kỹ thuật thời gian thực
├── Widgets/
│   └── EchoGridWidgetView.swift         # Widget màn hình chính iOS (Small & Medium)
├── PrivacyInfo.xcprivacy                # Tệp khai báo bảo mật chuẩn Apple App Store
├── ContentView.swift                    # Điều phối luồng chuyển cảnh & Deep Link
└── Echo_GridApp.swift                   # Điểm khởi chạy chính của ứng dụng SwiftUI
```

---

## 👨‍💻 Tài Liệu Phát Triển (Dành Cho Developer)

### 1. Cách Thêm Màn Chơi Mới Vào Game
Để thêm một màn chơi thủ công mới, chỉ cần mở file [`LevelRepository.swift`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/Content/LevelRepository.swift) và thêm định nghĩa vào mảng `allLevels`:

```swift
LevelDefinition(
    id: 16,
    chapter: 4,
    chapterTitle: "Chương 4: Hòa Âm Nâng Cao",
    title: "Trục Kép",
    subtitle: "Cân bằng qua cả hai trục vuông góc",
    parMoves: 6,
    parTimeSec: 45.0,
    initialBoard: BoardState(size: 5, nodes: [
        NodeState(id: "S1", type: .source, position: CellPosition(row: 0, col: 2)),
        NodeState(id: "M1", type: .receiver, position: CellPosition(row: 3, col: 1)),
        NodeState(id: "B1", type: .blocker, position: CellPosition(row: 2, col: 2))
    ]),
    ruleEvaluators: [VerticalSymmetryRule(), HorizontalSymmetryRule()]
)
```

### 2. Cách Viết Thêm Một Quy Luật Mới (Custom Rule Evaluator)
Mọi quy luật mới chỉ cần tuân thủ protocol `RuleEvaluator`:

```swift
public struct DiagonalSymmetryRule: RuleEvaluator, Sendable {
    public let id: String = "rule.diagonal_symmetry"
    public let weight: Double = 1.0

    public init() {}

    public func evaluate(board: BoardState) -> RuleEvaluation {
        // Tính toán điểm từ 0.0 đến 1.0
        let score = ...
        let isSolved = score >= 0.999
        return RuleEvaluation(ruleId: id, score: score, isSatisfied: isSolved)
    }
}
```

---

## 🛡 Tiêu Chuẩn Xuất Bản App Store & Bảo Mật

- **Bảo mật dữ liệu (Privacy Manifest)**: Khai báo đầy đủ trong [`PrivacyInfo.xcprivacy`](file:///Users/tphung/Documents/project/Echo%20Grid/Echo%20Grid/PrivacyInfo.xcprivacy). Ứng dụng **hoàn toàn không thu thập thông tin người dùng**, không sử dụng SDK theo dõi bên thứ ba, dữ liệu lưu trữ an toàn trong máy.
- **Tiếp cận người khuyết tật (Accessibility)**: Đầy đủ nhãn VoiceOver mô tả vị trí cờ và mức độ cộng hưởng.
- **Deep Link**: Hỗ trợ mở trực tiếp câu đố Daily qua URL `echogrid://daily`.

---

## 📄 Bản Quyền & Tác Quyền
- Dự án phát triển hoàn chỉnh cho **Echo Grid iOS Sensory Puzzle Game**.
- Copyright © 2026 Echo Grid Team. Bảo lưu mọi quyền.
