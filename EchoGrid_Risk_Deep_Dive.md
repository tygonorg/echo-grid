# Echo Grid — Risk Deep Dive

## 1. Mục tiêu tài liệu

Tài liệu này đào sâu ba rủi ro cốt lõi của Echo Grid: băng thông thấp của haptic, mâu thuẫn giữa zen và deduction, và khó khăn marketing/monetization của một USP không thể truyền tải đầy đủ qua screenshot/video.

---

## 2. Risk A — Haptic bandwidth thấp

### 2.1 Vấn đề gốc
Haptic là một kênh nhận thức có băng thông thấp hơn thị giác và âm thanh. Người dùng khó phân biệt ổn định giữa nhiều sắc thái intensity, sharpness và tempo, đặc biệt khi cầm máy khác nhau, có ốp lưng, hoặc ở môi trường ồn/đang di chuyển.

### 2.2 Hệ quả
- Người chơi sẽ dùng visual làm nguồn thông tin chính.
- Haptic bị hạ vai trò thành confirmation layer.
- USP “haptic as mechanic” mất hiệu lực.

### 2.3 Câu hỏi cần trả lời
- Haptic-only có giải được ít nhất một rule đơn giản không?
- Người chơi có mô tả được luật bằng trải nghiệm rung không?
- Người chơi có nhớ pattern rung sau 5 phút không?

### 2.4 Khuyến nghị
- Không thiết kế quá nhiều mức rung tinh vi.
- Giới hạn ngôn ngữ haptic vào 3–4 trạng thái đủ khác biệt.
- Dùng haptic cho macro signal, không ép nó mang micro semantics quá chi tiết.
- Test theo nhóm haptic-only trước mọi mở rộng khác.

---

## 3. Risk B — Zen vs Deduction conflict

### 3.1 Mâu thuẫn thiết kế
Zen game thường cho phản hồi dễ chịu, ít bất định, ít áp lực, và khuyến khích flow state. Game deduction với luật ẩn lại đòi hỏi người chơi phát hiện cấu trúc, chịu ambiguity, và vượt qua uncertainty. Hai cảm giác này chỉ giao nhau một phần nhỏ.

### 3.2 Dấu hiệu cảnh báo
- Người chơi nói “đẹp nhưng khó hiểu”.
- Người chơi cảm thấy thư giãn lúc đầu nhưng nhanh chóng bực vì không biết quy tắc.
- Tutorial phải giải thích quá nhiều để cứu UX.

### 3.3 Hai hướng định vị thay thế
#### Option 1 — Zen-first
- Rule rất rõ, ambiguity thấp.
- Haptic + visual tạo thư giãn.
- Puzzle nhẹ, approachable.
- USP: sensory calm puzzle.

#### Option 2 — Deduction-first
- Rule discovery là trọng tâm.
- Có frustration productive ở mức vừa phải.
- Session có thể dài hơn 1–3 phút.
- USP: abstract reasoning puzzle with sensory clues.

### 3.4 Khuyến nghị
Không nên cố đạt cả hai ở mức tối đa trong MVP. Hãy chọn một trục chính để thiết kế tutorial, độ khó, pacing, và marketing copy nhất quán.

---

## 4. Risk C — Marketing blind spot

### 4.1 Vấn đề gốc
USP mạnh nhất của game chỉ cảm được khi cầm máy. Nhưng người dùng quyết định tải qua App Store screenshots, trailer, social clips, và lời giới thiệu. Những kênh này gần như không truyền tải được haptic.

### 4.2 Hệ quả
- Tỷ lệ install có thể thấp dù trải nghiệm thật tốt.
- Review video khó làm nổi bật USP.
- Người dùng casual khó hiểu tại sao game này khác puzzle khác.

### 4.3 Cách giảm rủi ro
- Tạo visual representation cho haptic bằng waveform đặc trưng.
- Dùng share artifact có nhận diện mạnh, ví dụ resonance fingerprint.
- Viết marketing copy theo hướng “feel the puzzle” nhưng phải kèm visual proof.
- Làm trailer tập trung vào hành vi giải và phản ứng người chơi, không chỉ UI.

---

## 5. Monetization reality check

### 5.1 Thực tế
Puzzle premium niche thường khó scale doanh thu nếu không có IP mạnh, feature mạnh từ Apple, hoặc viral loop rõ ràng.

### 5.2 Mô hình phù hợp hơn
- Passion/portfolio project.
- Premium small title.
- Hybrid nhẹ: free sampler + paid full pack.

### 5.3 Không nên kỳ vọng
- Live ops lớn.
- Whale monetization.
- Retention cao chỉ nhờ thêm cosmetic/theme.

---

## 6. Generator risk

### 6.1 Vấn đề
Procedural generator cho hidden-rule puzzle là bài toán khó: phải có nghiệm, nên có nghiệm duy nhất hoặc nghiệm đẹp, lại còn phải “vui”.

### 6.2 Khuyến nghị practical
- MVP daily challenge nên dùng curated pool + seeded selection.
- Chỉ nghiên cứu generator thật sau khi core fun đã được xác nhận.
- Nếu làm generator, bắt đầu từ một rule family duy nhất.

---

## 7. Các quyết định cần chốt sớm

1. Haptic là core mechanic thật hay delight layer?
2. Audio là required hay optional assist?
3. Game zen-first hay deduction-first?
4. Daily challenge dùng curated pool hay generator thật?
5. Business goal là doanh thu hay portfolio / design award aspiration?

---

## 8. Đề xuất hành động

### P0
- Làm playtest haptic-only vs full sensory.
- Chốt product axis: zen-first hoặc deduction-first.
- Hạ kỳ vọng generator khỏi MVP.

### P1
- Viết lại marketing statement theo kết quả test.
- Điều chỉnh backlog theo product axis đã chọn.
- Thiết kế share artifact có sức nhận diện cao.

### P2
- Chỉ đầu tư generator khi đã có bằng chứng retention từ curated content.
