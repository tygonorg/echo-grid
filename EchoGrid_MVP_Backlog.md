# Echo Grid — MVP Backlog

## 1. Phạm vi backlog

Backlog này chia theo 4 sprint, mỗi sprint 2 tuần. Mục tiêu là đi từ prototype kiểm chứng interaction đến bản TestFlight nội bộ có thể chơi, lưu progress, và có daily challenge cơ bản.

Giả định:
- 1 iOS engineer chính.
- 1 part-time designer hoặc self-design.
- Không có backend riêng ở giai đoạn MVP.

---

## 2. Sprint 1 — Prototype Core

### Mục tiêu
Xác minh gameplay loop có vui hay không, haptic có đủ rõ và interaction có mượt.

### User stories

#### EG-001 Board prototype
- Là một người chơi, tôi muốn thấy một board 5x5 với node có thể kéo thả để thử giải puzzle.
- Acceptance criteria:
  - Board render được trên gameplay screen.
  - Có ít nhất 3 node types cơ bản.
  - Node snap đúng vào grid cell.

#### EG-002 Drag and snap interaction
- Là người chơi, tôi muốn kéo node mượt và có cảm giác dứt khoát khi thả vào ô.
- Acceptance criteria:
  - Gesture không drop frame rõ rệt trên thiết bị test chính.
  - Snap animation dưới 200ms.
  - Không cho thả vào ô invalid.

#### EG-003 Resonance evaluator v0
- Là hệ thống, tôi cần đánh giá cấu hình hiện tại để sinh resonance score.
- Acceptance criteria:
  - Có ít nhất 2 rule evaluators hoạt động.
  - Score trả về ổn định, deterministic.
  - Có debug overlay hiển thị score tổng và score từng rule.

#### EG-004 Haptic feedback v0
- Là người chơi, tôi muốn cảm nhận mức đúng/sai qua rung.
- Acceptance criteria:
  - Có 3 trạng thái rung: sai xa, gần đúng, hoàn thành.
  - Cooldown chống spam rung hoạt động.
  - Có fallback khi Core Haptics unavailable.

#### EG-005 Calibration screen v0
- Là người chơi, tôi muốn chỉnh độ rung phù hợp với thiết bị/ốp lưng.
- Acceptance criteria:
  - Có flow test 5 mức rung.
  - Lưu được `hapticScale`.
  - Settings áp dụng lại cho gameplay session mới.

### Deliverables
- Playable prototype.
- Debug build nội bộ.
- Ghi nhận review feeling sau 10 phút chơi thử.

---

## 3. Sprint 2 — Vertical Slice

### Mục tiêu
Biến prototype thành một lát cắt sản phẩm hoàn chỉnh với tutorial, level progression cơ bản, lưu local progress.

### User stories

#### EG-006 Curated level loader
- Là người chơi, tôi muốn vào được nhiều màn chơi được thiết kế sẵn.
- Acceptance criteria:
  - Load ít nhất 10 màn curated.
  - Có metadata cho difficulty.
  - Có thể mở màn kế tiếp khi clear màn trước.

#### EG-007 Tutorial flow
- Là người chơi mới, tôi muốn hiểu cách game phản hồi mà không bị overwhelm.
- Acceptance criteria:
  - Có onboarding 3–5 bước.
  - Giải thích được ít nhất 1 rule family.
  - Không lộ toàn bộ đáp án.

#### EG-008 Result screen
- Là người chơi, tôi muốn xem kết quả sau khi clear màn.
- Acceptance criteria:
  - Hiển thị thời gian, số bước, số hint.
  - Có trạng thái clear và retry.
  - Có transition mượt từ gameplay sang result.

#### EG-009 Local persistence
- Là người chơi, tôi muốn progress được lưu lại khi thoát app.
- Acceptance criteria:
  - Lưu trạng thái màn đã hoàn thành.
  - Lưu best moves và best time.
  - Restore đúng khi mở lại app.

#### EG-010 Accessibility settings
- Là người chơi, tôi muốn tùy chỉnh chế độ rung/âm thanh/hình ảnh hỗ trợ.
- Acceptance criteria:
  - Toggle audio assist.
  - Toggle low sensory mode.
  - High contrast mode có hiệu lực.

### Deliverables
- Vertical slice chơi được từ đầu đến cuối.
- 10–20 màn curated.
- Lưu local qua SwiftData.

---

## 4. Sprint 3 — Daily Challenge & Systems

### Mục tiêu
Thêm chiều sâu giữ chân người chơi qua generator, daily challenge, và chia sẻ cơ bản.

### User stories

#### EG-011 Seed-based level generator
- Là hệ thống, tôi cần sinh màn từ seed để daily challenge lặp lại được trên mọi máy.
- Acceptance criteria:
  - Cùng seed cho cùng level.
  - Generator có difficulty tier.
  - Có validation loại level vô nghiệm.

#### EG-012 Daily challenge flow
- Là người chơi, tôi muốn có một màn mới mỗi ngày.
- Acceptance criteria:
  - App sinh đúng 1 daily puzzle theo ngày.
  - Lưu record daily attempt.
  - Không reset sai khi offline.

#### EG-013 Hint engine v1
- Là người chơi, tôi muốn nhận gợi ý vừa đủ khi mắc kẹt.
- Acceptance criteria:
  - Hint chỉ ra vùng/trục/rule direction, không spoil full solution.
  - Có cooldown hoặc cost cho hint.
  - Track được hint usage.

#### EG-014 Resonance fingerprint share v1
- Là người chơi, tôi muốn chia sẻ kết quả daily challenge mà không lộ đáp án.
- Acceptance criteria:
  - Sinh được ảnh fingerprint hoặc waveform tĩnh.
  - Có seed code trong nội dung share.
  - Share sheet mở được từ result screen.

#### EG-015 Analytics events v1
- Là team sản phẩm, chúng ta muốn biết màn nào gây rời bỏ hoặc trial-and-error cao.
- Acceptance criteria:
  - Track level_start, level_clear, retry, hint_used, daily_share.
  - Track attempt count và solve time.
  - Event schema ổn định để export sau này.

### Deliverables
- Daily challenge hoàn chỉnh.
- Generator v1.
- Share artifact v1.
- Analytics bản đầu.

---

## 5. Sprint 4 — Polish & TestFlight

### Mục tiêu
Ổn định hiệu năng, tinh chỉnh cảm giác, chuẩn bị bản phát hành nội bộ.

### User stories

#### EG-016 Thermal and battery guard
- Là người chơi, tôi muốn game vẫn mượt khi máy nóng hoặc pin yếu.
- Acceptance criteria:
  - Phát hiện thermal state.
  - Giảm effect khi máy nóng.
  - Gameplay core vẫn hoạt động khi degrade mode bật.

#### EG-017 Performance pass
- Là team dev, chúng ta muốn gameplay screen ổn định trên nhiều dòng iPhone.
- Acceptance criteria:
  - Không có drop frame nghiêm trọng ở board chuẩn.
  - Input latency không gây khó chịu.
  - Canvas effects không làm block interaction.

#### EG-018 Widget / streak lite
- Là người chơi, tôi muốn thấy nhắc nhở daily progress ngoài màn hình chính.
- Acceptance criteria:
  - Widget hiển thị streak hoặc trạng thái daily challenge.
  - Không cần tương tác sâu ở MVP.
  - Đồng bộ được với app state local.

#### EG-019 TestFlight hardening
- Là team dev, chúng ta muốn build ổn định để gửi tester.
- Acceptance criteria:
  - Không có crash blocker đã biết.
  - Logging debug có thể bật/tắt.
  - Có checklist regression cho luồng chính.

#### EG-020 Content balancing
- Là designer, tôi muốn độ khó 20 màn đầu hợp lý.
- Acceptance criteria:
  - Màn đầu không làm người chơi bỏ cuộc sớm.
  - Mỗi rule mới được giới thiệu có kiểm soát.
  - Có dữ liệu thử nghiệm nội bộ cho 5–10 người chơi.

### Deliverables
- Bản TestFlight nội bộ.
- Checklist QA chính.
- MVP review report.

---

## 6. Ưu tiên backlog tổng thể

### P0
- EG-001, EG-002, EG-003, EG-004, EG-006, EG-007, EG-009

### P1
- EG-005, EG-008, EG-010, EG-011, EG-012, EG-013

### P2
- EG-014, EG-015, EG-016, EG-017, EG-018, EG-019, EG-020

---

## 7. Story points gợi ý

| ID | Story | Points |
|---|---|---:|
| EG-001 | Board prototype | 3 |
| EG-002 | Drag and snap interaction | 5 |
| EG-003 | Resonance evaluator v0 | 5 |
| EG-004 | Haptic feedback v0 | 5 |
| EG-005 | Calibration screen v0 | 3 |
| EG-006 | Curated level loader | 3 |
| EG-007 | Tutorial flow | 5 |
| EG-008 | Result screen | 2 |
| EG-009 | Local persistence | 3 |
| EG-010 | Accessibility settings | 3 |
| EG-011 | Seed-based generator | 8 |
| EG-012 | Daily challenge flow | 5 |
| EG-013 | Hint engine v1 | 5 |
| EG-014 | Fingerprint share v1 | 5 |
| EG-015 | Analytics events v1 | 3 |
| EG-016 | Thermal and battery guard | 3 |
| EG-017 | Performance pass | 5 |
| EG-018 | Widget / streak lite | 3 |
| EG-019 | TestFlight hardening | 3 |
| EG-020 | Content balancing | 5 |

---

## 8. Definition of Done

Một story được xem là done khi:
- Code đã chạy trên thiết bị thật.
- Có test hoặc ít nhất manual test checklist cho luồng chính.
- Không phá regression ở gameplay core.
- Có logging/debug info đủ để chẩn đoán.
- Được review lại về interaction feel, không chỉ correctness.

---

## 9. Rủi ro triển khai

- Haptic feeling tốt trên máy dev nhưng kém trên máy khác.
- SwiftUI gesture và Canvas effect cạnh tranh hiệu năng.
- Generator tạo level hợp lệ nhưng không vui.
- Tutorial giải thích quá nhiều làm mất chất khám phá.
- Share fingerprint đẹp về concept nhưng không đủ hấp dẫn để lan truyền.

---

## 10. Exit criteria cho MVP

MVP được xem là đạt khi:
- Người chơi mới hiểu core loop trong 3 phút đầu.
- Có ít nhất 10 màn curated chơi ổn định.
- Daily challenge chạy được với seed reproducible.
- Haptic fallback hoạt động khi tắt rung.
- TestFlight nội bộ cho feedback tích cực về cảm giác giải đố và sự khác biệt của haptic.
