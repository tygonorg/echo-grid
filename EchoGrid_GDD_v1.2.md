# Echo Grid — Game Design Document v1.2

## 1. Mục tiêu của v1.2

Phiên bản này cập nhật GDD dựa trên phản biện sản phẩm ở cấp chiến lược. Trọng tâm không còn là mở rộng feature, mà là khóa chặt câu hỏi sống còn: **haptic có thật sự là mechanic cốt lõi không**.

GDD v1.2 vì vậy chuyển Phase 0 từ technical spike sang **validation spike**, đồng thời chuẩn bị hai hướng định vị rõ ràng sau playtest:
- Direction A: haptic-first deduction puzzle.
- Direction B: visual-first puzzle with haptic delight.

---

## 2. Product Thesis đã chỉnh lại

### 2.1 Thesis mới
Echo Grid không nên giả định ngay từ đầu rằng haptic sẽ là ngôn ngữ suy luận chính. Thay vào đó, sản phẩm phải được xây theo giả thuyết có thể kiểm chứng:

> Nếu người chơi mới có thể phát hiện và mô tả một hidden rule đơn giản nhờ haptic trong thời gian ngắn, thì haptic có thể được giữ là mechanic cốt lõi.

Nếu giả thuyết này không đứng vững, sản phẩm phải pivot sang định vị khác mà không phá hỏng toàn bộ nền tảng kỹ thuật.

### 2.2 Product positioning candidates

#### Direction A — Haptic-first deduction puzzle
- Haptic là nguồn thông tin chính.
- Visual và audio đóng vai trò hỗ trợ nhẹ.
- Marketing nhấn vào cảm giác “solve by feel”.

#### Direction B — Visual-first puzzle with haptic delight
- Visual là kênh suy luận chính.
- Haptic tăng cảm giác premium, tactile, và immersion.
- Marketing nhấn vào vẻ đẹp tối giản + cảm giác cầm nắm đặc biệt.

---

## 3. Product Pillars cập nhật

### 3.1 Validated Sensory Reasoning
Không tuyên bố sensory reasoning là core value trước khi playtest xác nhận.

### 3.2 Minimal Surface, Deep System
Giữ nguyên: mặt ngoài tối giản, hệ luật sâu và mở rộng được.

### 3.3 Platform-native Delight
Tận dụng iPhone-native interaction, haptic, widget, accessibility và hiệu suất cao.

### 3.4 Chosen Product Axis
MVP phải chọn rõ zen-first hoặc deduction-first, không cố đạt cả hai ở mức tối đa.

---

## 4. Quyết định thiết kế cần chốt sớm

### 4.1 Haptic role
- Candidate 1: mechanic.
- Candidate 2: delight layer.

### 4.2 Audio role
- Candidate 1: required channel.
- Candidate 2: optional assist.

### 4.3 Puzzle philosophy
- Candidate 1: zen-first.
- Candidate 2: deduction-first.

### 4.4 Daily content source
- Candidate 1: curated pool with seeded rotation.
- Candidate 2: true procedural generation.

Quyết định cuối cùng cho bốn mục này phải được chốt ngay sau Phase 0.

---

## 5. Core gameplay hypothesis

### 5.1 Hypothesis statement
Một hidden-rule puzzle có thể tạo aha moment nếu:
- người chơi nhận được phản hồi đủ rõ để suy luận,
- phản hồi không quá trực tiếp đến mức spoil,
- số rule active ở giai đoạn đầu được kiểm soát rất chặt.

### 5.2 MVP hidden rule scope
MVP chỉ nên dùng 1–2 rule families thật mạnh, không nên mở rộng quá sớm nhiều vocabulary.

### 5.3 Move constraint strategy
Để giảm brute-force:
- Có move budget ở một số mode.
- Có snap-to-grid evaluation.
- Có hint theo trục hoặc vùng thay vì chỉ tăng score tổng.

---

## 6. Phase 0 được viết lại

### 6.1 Tên phase
**Phase 0 — Validation Spike**

### 6.2 Mục tiêu
Không phải chứng minh công nghệ chạy được, mà chứng minh người chơi **có hiểu được game qua haptic hay không**.

### 6.3 Prototype cần có
- 1 board 5x5.
- 1 hidden rule duy nhất.
- 2 build test: haptic-only và full sensory.
- Logging move history.
- Post-test questionnaire.

### 6.4 Success metrics
- Haptic-only solve rate >= 50%.
- Haptic-only rule recall >= 60%.
- Move count ratio so với full sensory <= 1.5x.
- Tối thiểu 50% người chơi haptic-only báo có aha moment.

### 6.5 Phase 0 outputs
- Continue as haptic-first.
- Pivot to visual-first.
- Retest with simpler rule.

---

## 7. Content strategy cập nhật

### 7.1 MVP content
- 12 curated levels là con số mục tiêu chốt cho MVP đầu.
- 1 daily challenge sử dụng curated pool + seed rotation.
- 1 tutorial branch theo product axis đã chọn.

### 7.2 Generator strategy
Không đưa generator thật vào MVP core.

Thay vào đó:
- Chọn curated pool.
- Dùng seed để xoay màn theo ngày.
- Lưu generator research ở backlog post-MVP.

### 7.3 Depth strategy
Depth không đến từ thêm biome/theme đơn thuần. Depth phải đến từ:
- composition của rule,
- quality của hinting,
- mastery curve của người chơi,
- variation trong constraint chứ không chỉ variation trong skin.

---

## 8. Feedback philosophy cập nhật

### 8.1 Haptic language constraint
Nếu giữ haptic là mechanic, haptic vocabulary phải rất nhỏ:
- sai xa,
- gần đúng,
- đang đúng một chiều logic,
- hoàn thành.

Không nên cố encode quá nhiều semantics vi mô vào rung.

### 8.2 Visual and audio roles
Visual và audio phải được xem là **biến số chiến lược**, không phải mặc định trợ giúp. Chúng chỉ được nâng vai nếu playtest chứng minh haptic-only không đủ.

### 8.3 Truthful marketing alignment
Mọi mô tả marketing sau này phải phản ánh đúng phiên bản sản phẩm đã được xác nhận qua test. Không được tiếp tục dùng narrative “solve by feel” nếu dữ liệu cho thấy người chơi chủ yếu solve by sight.

---

## 9. Monetization cập nhật

### 9.1 Business expectation
Echo Grid nên được xem trước hết là:
- indie premium micro-title,
- portfolio / award-caliber iOS-native project,
- hoặc small commercial experiment.

### 9.2 MVP monetization recommendation
- Free demo / sampler.
- Paid full pack hoặc one-time unlock.
- Không dựa vào live ops hoặc ads.

### 9.3 Success definition
Thành công của MVP không đo bằng doanh thu sớm. Thành công đo bằng:
- uniqueness được xác nhận,
- playtest quality,
- retention tín hiệu đầu,
- và khả năng tạo câu chuyện sản phẩm rõ ràng.

---

## 10. Backlog impact

### 10.1 Hạ ưu tiên
- True procedural generator.
- Theme expansion.
- Multi-biome polish.

### 10.2 Tăng ưu tiên
- Playtest instrumentation.
- Haptic-only prototype.
- Moderator script.
- Result analysis template.
- Product-axis decision checkpoint.

### 10.3 Backlog adjustment
Backlog MVP phải phản ánh rõ rằng validation đứng trước scale. Mọi task sau Sprint 1 chỉ nên tiếp tục nếu Phase 0 đạt điều kiện go hoặc có pivot quyết đoán.

---

## 11. Kiến trúc vẫn giữ được giá trị

Điểm tốt là kiến trúc đã thiết kế vẫn hữu ích trong cả hai hướng:
- Nếu haptic-first đúng, Feedback Layer giữ vai trò trung tâm.
- Nếu visual-first đúng, cùng kiến trúc vẫn dùng lại được, chỉ cần thay trọng số của feedback channels.

Điều này cho phép pivot product narrative mà không phải phá bỏ nền móng kỹ thuật.

---

## 12. Quyết định chờ sau playtest

Sau playtest đầu tiên phải ra quyết định cho 5 câu hỏi:
1. Haptic là mechanic hay delight?
2. Audio là required hay optional?
3. Zen-first hay deduction-first?
4. Daily challenge dùng curated pool hay generator?
5. Dự án này theo mục tiêu commercial nhỏ hay portfolio/award-first?

Không được kéo dài trạng thái lửng lơ của năm câu hỏi này sang giai đoạn build nội dung hàng loạt.

---

## 13. Kết luận v1.2

Phiên bản GDD này thay đổi điều quan trọng nhất: từ niềm tin sang kiểm chứng. Echo Grid chỉ nên tiến xa như một sản phẩm haptic-first nếu dữ liệu playtest xác nhận điều đó. Nếu không, giá trị của nó vẫn còn nguyên, nhưng câu chuyện sản phẩm phải đổi cho trung thực và sắc bén hơn.
