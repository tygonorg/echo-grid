# Echo Grid — Sprint 0 Backlog (Validation Spike)

## 1. Mục tiêu Sprint 0

**Thời lượng:** 1 tuần (hoặc đến khi hoàn tất 8–12 lượt playtest).  
**Trọng tâm duy nhất:** Xây dựng gói **Validation Prototype Package**, vận hành đợt playtest đầu tiên theo đúng `EchoGrid_Playtest_Kit.md`, và thu thập đủ dữ liệu thực nghiệm để chốt Product Direction (Haptic-First vs Visual-First).

---

## 2. Danh sách User Stories & Nhiệm vụ kỹ thuật

| Mã Task | Hạng mục | Mô tả chi tiết | Ưu tiên | Trạng thái |
|---|---|---|---|---|
| **EG-S0-01** | Simulation Core | Xây dựng các struct `CellPosition`, `NodeState`, `BoardState` độc lập không phụ thuộc SwiftUI. | P0 | In Progress |
| **EG-S0-02** | Rule Evaluator | Cài đặt `VerticalSymmetryRule` và `ResonanceEvaluator` tính score liên tục $S \in [0.0, 1.0]$. | P0 | In Progress |
| **EG-S0-03** | Interaction Engine | Cài đặt cử chỉ kéo thả Touch Drag & Snap vào ô 5x5, chống lỗi thả đè node hoặc ra ngoài bảng. | P0 | In Progress |
| **EG-S0-04** | Haptic Orchestrator | Tích hợp `Core Haptics` với 3 profile xung (Far, Progress, Solved) + snap click, có fallback `UIFeedbackGenerator`. | P0 | In Progress |
| **EG-S0-05** | Audio Orchestrator | Tạo bộ phát sine tone pentatonic cho chế độ Full Sensory, đồng bộ theo Resonance Score. | P0 | In Progress |
| **EG-S0-06** | Test Harness UI | Giao diện cho phép chọn nhanh Condition A (Haptic) / Condition B (Full), nút Reset, và màn hình Solved. | P0 | In Progress |
| **EG-S0-07** | Telemetry & Logger | Ghi nhận tự động `total_moves`, `elapsed_time`, `oscillation_count`, `solved` và export JSON. | P0 | In Progress |
| **EG-S0-08** | Debug Overlay HUD | HUD hiển thị real-time score, move count và state machine state. | P1 | In Progress |
| **EG-S0-09** | Playtest Cohort 1 | Chạy thử nghiệm trên 8 người (4 người Condition A, 4 người Condition B) theo đúng kịch bản Moderator. | P0 | To Do |
| **EG-S0-10** | Decision Checkpoint | Điền `Playtest_Results_Template.md`, phân tích dữ liệu và ra quyết định Go/Pivot. | P0 | To Do |

---

## 3. Quy trình thực hiện Sprint 0

```text
[1. Build Core Prototype]
          │
          ▼
[2. Kiểm tra trên Simulator & Device]
          │
          ▼
[3. Chạy Playtest 8+ testers] (Condition A vs Condition B)
          │
          ▼
[4. Tổng hợp Telemetry JSON & Ghi chép]
          │
          ▼
[5. Đánh giá Go / No-Go Gate]
          │
          ▼
[6. Ban hành GDD v1.3 hoặc Pivot Memo]
```

---

## 4. Definition of Done cho Sprint 0

Sprint 0 được coi là hoàn thành khi và chỉ khi:
1. Bản build prototype chạy ổn định trên thiết bị iPhone thật không có crash hoặc giật lag.
2. Hoàn thành tối thiểu 8 lượt thử nghiệm hợp lệ với đầy đủ telemetry JSON.
3. Bản tổng hợp `Playtest_Results_Template.md` có đầy đủ số liệu định lượng và trích dẫn định tính.
4. Có quyết định chính thức được phê duyệt: Tiếp tục hướng Haptic-first hay Pivot sang Visual-first.
