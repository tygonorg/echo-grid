# Echo Grid — AI Execution Index & Project Status

## 📌 Mục tiêu & Tổng quan

File này là **điểm vào điều phối** cho mọi AI agent và developer.
Toàn bộ các giai đoạn từ **Phase 0 (Validation Prototype Spike)** đến **Sprints 1, 2, 3, 4 (Full Game Release)** hiện đã được triển khai và kiểm thử hoàn tất 100%.

👉 **Xem tài liệu chi tiết sản phẩm tại:**
- 📘 [`README.md`](./README.md) — Hướng dẫn toàn diện: cách chơi, cách build, kiến trúc mã nguồn, developer guide.
- 📋 [`walkthrough.md`](./walkthrough.md) — Nhật ký triển khai chi tiết qua từng Sprint.
- 📐 [`EchoGrid_Technical_Architecture_v1.md`](./EchoGrid_Technical_Architecture_v1.md) — Kiến trúc kỹ thuật phân lớp Simulation, Feedback, Persistence, Presentation.
- 🎯 [`EchoGrid_MVP_Backlog.md`](./EchoGrid_MVP_Backlog.md) — Toàn bộ backlog 20 User Stories (EG-001 đến EG-020) đã hoàn thành.

---

## 🏆 Trạng thái Dự án Hiện tại (Status: v1.0 Release Ready)

| Phát triển | Phạm vi & Tính năng | Trạng thái |
| :--- | :--- | :---: |
| **Phase 0** | Validation Prototype Harness (5x5 Grid, Core Haptics 3 cấp độ, Telemetry Logger JSON) | ✅ **HOÀN TẤT** |
| **Sprint 1** | Mở rộng Rule Engine (4 luật), Blocker Nodes, Synthesizer hòa âm Pentatonic | ✅ **HOÀN TẤT** |
| **Sprint 2** | 15 màn chơi Curated (3 Chương), Lưu tiến trình & Chấm sao ⭐️, Bộ giao diện 7 màn hình | ✅ **HOÀN TẤT** |
| **Sprint 3** | Daily Challenge (Seed RNG), Chuỗi Streak 🔥, Dấu ấn Sóng (Social Share), Hint Engine, 8 Ngôn ngữ | ✅ **HOÀN TẤT** |
| **Sprint 4** | Battery & Thermal Guard, Audio Interruption Handler, WidgetKit iOS, VoiceOver, Privacy Manifest | ✅ **HOÀN TẤT** |

---

## 🚀 Hướng dẫn Build & Chạy (Quickstart)

1. Mở project trên Xcode 16+:
   ```bash
   open "Echo Grid.xcodeproj"
   ```
2. Chọn Device hoặc iOS Simulator (iOS 17.0+) và nhấn **`Cmd + R`**.
3. Chạy toàn bộ Automated Unit Tests bằng command line:
   ```bash
   swift -module-cache-path ./.swift-cache scratch/test_simulation.swift
   swift -module-cache-path ./.swift-cache scratch/test_sprint1_2.swift
   swift -module-cache-path ./.swift-cache scratch/test_sprint3.swift
   swift -module-cache-path ./.swift-cache scratch/test_sprint4.swift
   ```

---

## 📚 Bản đồ Tài liệu Dự án

1. [`README.md`](./README.md) — Tài liệu chính thức tổng quát cho người chơi và developer.
2. [`EchoGrid_GDD_v1.2.md`](./EchoGrid_GDD_v1.2.md) — Game Design Document v1.2.
3. [`EchoGrid_Technical_Architecture_v1.md`](./EchoGrid_Technical_Architecture_v1.md) — Đặc tả kiến trúc phân tầng.
4. [`EchoGrid_MVP_Backlog.md`](./EchoGrid_MVP_Backlog.md) — Lộ trình backlog chi tiết.
5. [`EchoGrid_Playtest_Kit.md`](./EchoGrid_Playtest_Kit.md) — Tài liệu kịch bản phỏng vấn playtest.
6. [`Validation_Prototype_Spec.md`](./Validation_Prototype_Spec.md) — Đặc tả kỹ thuật prototype Phase 0.
