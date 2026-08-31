# Echo Grid — AI Execution Index

## Mục tiêu

File này là **điểm vào duy nhất** cho một AI agent hoặc developer mới. Khi đọc file này cùng các file được tham chiếu bên dưới, agent phải có đủ ngữ cảnh để:
- hiểu sản phẩm là gì,
- biết tài liệu nào là nguồn chân lý cho từng phần,
- biết thứ tự đọc,
- biết phải làm gì trước,
- và có thể bắt đầu thực thi ngay mà không cần hỏi lại các câu nền tảng.

---

## Trạng thái hiện tại

Dự án **chưa bước vào full production**. Trạng thái hiện tại là **pre-production / validation-first**.

Điều quan trọng nhất:
- Chưa được mặc định rằng “haptic as mechanic” là đúng.
- Trước khi mở rộng backlog hoặc build content hàng loạt, phải hoàn thành **Phase 0 — Validation Spike**.
- Mọi quyết định product lớn sau đó phải dựa trên kết quả playtest, không dựa trên niềm tin thiết kế.

---

## Mục tiêu sản phẩm ngắn gọn

**Echo Grid** là một puzzle game iPhone-native, tối giản, lấy cảm hứng từ sensory puzzle. Ý tưởng gốc là dùng haptic như một phần của quá trình suy luận, kết hợp với visual và audio feedback để người chơi khám phá hidden rules trên một board lưới nhỏ.

Tuy nhiên, định vị này **chưa được xem là đã xác nhận**. Sản phẩm hiện phải được xem như một giả thuyết cần kiểm chứng qua playtest thực tế.

---

## Quyết định chiến lược hiện tại

Cho đến khi có dữ liệu playtest, hãy làm theo các giả định vận hành sau:

1. **Validation trước scale.**
2. **Curated content trước generator.**
3. **Một hidden rule đơn giản trước nhiều mechanics.**
4. **Instrumentation và learning quan trọng hơn polish.**
5. **Kiến trúc phải pivot-friendly** giữa hai hướng:
   - Direction A: haptic-first deduction puzzle.
   - Direction B: visual-first puzzle with haptic delight.

---

## Thứ tự đọc bắt buộc

AI hoặc developer mới phải đọc theo đúng thứ tự sau:

1. `index.md` — file điều phối này.
2. `EchoGrid_GDD_v1.2.md` — nguồn chân lý về product direction hiện tại.
3. `EchoGrid_Playtest_Kit.md` — tài liệu hành động số 1 cần thực thi trước.
4. `EchoGrid_Risk_Deep_Dive.md` — giải thích vì sao chiến lược validation-first là bắt buộc.
5. `EchoGrid_Technical_Architecture_v1.md` — kiến trúc kỹ thuật để triển khai prototype mà vẫn pivot được.
6. `EchoGrid_MVP_Backlog.md` — backlog tham khảo, nhưng chỉ được thực thi có chọn lọc sau khi pass validation gate.
7. `EchoGrid_GDD_v1.1.md` — tài liệu lịch sử, dùng để đối chiếu evolution của ý tưởng, không phải source of truth chính.

---

## Source of truth

### Product direction
- File chính: `EchoGrid_GDD_v1.2.md`
- Nếu v1.1 và v1.2 mâu thuẫn, **v1.2 thắng**.

### Playtest process
- File chính: `EchoGrid_Playtest_Kit.md`

### Strategic critique and constraints
- File chính: `EchoGrid_Risk_Deep_Dive.md`

### Technical implementation
- File chính: `EchoGrid_Technical_Architecture_v1.md`

### Delivery planning
- File chính: `EchoGrid_MVP_Backlog.md`
- Lưu ý: backlog chỉ là kế hoạch tạm thời, không phải mệnh lệnh tuyệt đối nếu validation thất bại.

---

## Những gì đã được quyết định

Các điểm sau đã được thống nhất tạm thời:

- Tech stack định hướng là **SwiftUI + GameplayKit + Core Haptics + SwiftData + CloudKit**.
- Không chọn SpriteKit làm nền tảng mặc định.
- Visual rendering ưu tiên SwiftUI + Canvas.
- Gameplay logic phải tách khỏi rendering và feedback.
- Haptic là giả thuyết sản phẩm quan trọng nhất cần được xác nhận hoặc bác bỏ.
- Generator thật không phải ưu tiên của MVP đầu tiên.
- Daily challenge ban đầu nên dựa trên curated pool + seeded rotation.
- Accessibility và fallback không phải phần thêm sau, mà là phần cốt lõi từ đầu.

---

## Những gì CHƯA được quyết định

Agent không được tự tiện coi các câu hỏi sau là đã chốt:

1. Haptic là **core mechanic** hay chỉ là **delight layer**?
2. Audio là **required channel** hay **optional assist**?
3. Sản phẩm là **zen-first** hay **deduction-first**?
4. Daily content sẽ dùng curated rotation lâu dài hay procedural generator thật?
5. Mục tiêu chính là commercial indie nhỏ, portfolio mạnh, hay award-oriented product?

Chỉ được chốt sau khi có dữ liệu từ playtest đầu tiên.

---

## Nhiệm vụ ưu tiên số 1

### Validation Spike

Bất kỳ AI agent nào đọc bộ tài liệu này để “làm ngay” đều phải hiểu rằng công việc đầu tiên **không phải** là mở rộng gameplay, polish UI hay xây generator, mà là:

- dựng prototype test được,
- chạy playtest theo kit,
- thu kết quả,
- phân tích,
- và ra quyết định go / pivot / retest.

Nếu agent bỏ qua bước này và đi thẳng vào build MVP đầy đủ, agent đang làm sai định hướng dự án.

---

## Deliverable đầu tiên cần tạo

Deliverable đầu tiên nên là một **Validation Prototype Package** gồm:

1. Một prototype iPhone chạy được với board 5x5.
2. Một hidden rule duy nhất: đối xứng trục dọc.
3. Hai build mode:
   - Haptic-only.
   - Full sensory.
4. Logging cơ bản:
   - move count,
   - time to solve,
   - oscillation count,
   - solved / not solved.
5. Debug overlay có thể bật/tắt.
6. Một script chạy playtest và ghi nhận kết quả.

---

## Definition of success cho giai đoạn hiện tại

Giai đoạn hiện tại chỉ được xem là thành công nếu có thể trả lời bằng dữ liệu cho câu hỏi này:

> Người chơi mới có thực sự suy luận được hidden rule nhờ haptic, hay họ chủ yếu dựa vào visual/audio?

Mọi thành tựu khác như animation đẹp, code sạch, hay architecture tốt đều là phụ nếu chưa trả lời được câu hỏi trên.

---

## Ranh giới thực thi cho AI agent

### Agent được phép làm
- Tạo/cập nhật tài liệu markdown liên quan.
- Đề xuất kiến trúc code cho prototype.
- Viết skeleton project structure.
- Viết playtest checklist, moderator guide, data collection form.
- Viết backlog tinh gọn lại theo validation-first.
- Thiết kế logging schema cho prototype.
- Đề xuất các level test cực nhỏ phục vụ validation.

### Agent không nên tự động ưu tiên
- Xây procedural generator hoàn chỉnh.
- Thiết kế 50+ levels.
- Tối ưu monetization phức tạp.
- Làm multi-biome content pipeline.
- Mở rộng social systems trước khi core hypothesis được xác nhận.

---

## Hướng triển khai prototype

### Gameplay scope
- Board 5x5.
- 1 rule duy nhất.
- 1 interaction chính: drag + snap.
- 3 mức feedback haptic tối đa.
- Có mode bật/tắt visual/audio theo test condition.

### Technical scope
- SwiftUI app shell.
- Gameplay coordinator điều phối state.
- Rule evaluator deterministic.
- Core Haptics orchestrator đơn giản.
- SwiftData là optional cho prototype; có thể log tạm thời local JSON nếu cần nhanh.

### Research scope
- Ghi lại quan sát người chơi.
- So sánh haptic-only và full sensory.
- Chốt narrative sản phẩm sau test.

---

## Quy tắc khi cập nhật tài liệu

Nếu AI agent tạo thêm tài liệu mới, phải tuân thủ các quy tắc sau:

1. Không overwrite source of truth mà không tăng version.
2. Nếu thay đổi product direction, phải tạo bản mới kiểu `GDD_v1.3.md`.
3. Nếu quyết định một open question, phải ghi rõ quyết định đó dựa trên dữ liệu nào.
4. Nếu một tài liệu mâu thuẫn với `EchoGrid_GDD_v1.2.md`, phải ghi chú rõ lý do và tạo bản kế tiếp thay vì sửa âm thầm.

---

## Checklist cho agent trước khi bắt đầu làm việc

Trước khi thực thi bất kỳ task nào, agent phải tự check:

- Tôi đã đọc `EchoGrid_GDD_v1.2.md` chưa?
- Tôi đã đọc `EchoGrid_Playtest_Kit.md` chưa?
- Task tôi sắp làm có phục vụ trực tiếp cho validation spike không?
- Task này có giả định sai rằng haptic-as-mechanic đã được xác nhận không?
- Có cách nào đơn giản hơn để học nhanh hơn trước khi build lớn hơn không?

Nếu một trong các câu trả lời là “chưa”, phải dừng lại và quay về tài liệu nền trước.

---

## Recommended next tasks

Thứ tự thực hiện khuyến nghị:

1. Tạo `Validation Prototype Spec.md`.
2. Tạo `Prototype Logging Schema.md`.
3. Tạo `Playtest Results Template.md`.
4. Tạo `Sprint 0 Backlog.md` chỉ cho validation spike.
5. Sau khi có kết quả test, mới tạo `GDD_v1.3.md` hoặc `Pivot Memo.md`.

---

## File map

- `index.md`
- `EchoGrid_GDD_v1.2.md`
- `EchoGrid_Playtest_Kit.md`
- `EchoGrid_Risk_Deep_Dive.md`
- `EchoGrid_Technical_Architecture_v1.md`
- `EchoGrid_MVP_Backlog.md`
- `EchoGrid_GDD_v1.1.md`
- `EchoGrid_GDD_v1.0.md`

---

## One-paragraph brief cho AI

Echo Grid là một puzzle game iPhone-native đang ở giai đoạn pre-production. Giả thuyết lớn nhất là haptic có thể đóng vai trò mechanic suy luận, nhưng giả thuyết này chưa được xác nhận và phải được kiểm chứng trước mọi mở rộng khác. Source of truth hiện tại là `EchoGrid_GDD_v1.2.md`, và nhiệm vụ số một là dựng validation prototype cùng playtest để ra quyết định haptic-first hay visual-first. Mọi công việc khác chỉ có giá trị nếu phục vụ trực tiếp cho bước xác nhận đó.
