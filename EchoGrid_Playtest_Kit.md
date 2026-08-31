# Echo Grid — Playtest Kit

## 1. Mục tiêu

Tài liệu này dùng để xác nhận câu hỏi sống còn của Echo Grid: người chơi có thật sự suy luận được luật ẩn chủ yếu nhờ haptic, hay họ luôn quay về dựa vào thị giác và âm thanh.

Kết quả playtest này sẽ quyết định hướng đi sản phẩm:
- Nếu haptic-only chơi được và tạo aha moment: giữ định vị **haptic as mechanic**.
- Nếu haptic-only không đủ: pivot thành **visual puzzle with haptic delight**.

---

## 2. Hypothesis cần kiểm chứng

### H1
Người chơi mới có thể suy luận được một luật ẩn đơn giản chỉ bằng phản hồi haptic trong vòng 8 phút.

### H2
Người chơi ở bản haptic-only không rơi vào hành vi brute-force nhiều hơn đáng kể so với bản full sensory.

### H3
Người chơi mô tả lại được quy luật bằng ngôn ngữ của chính họ sau khi hoàn thành hoặc gần hoàn thành.

---

## 3. Thiết kế thí nghiệm

### 3.1 Test conditions

#### Condition A — Haptic-only
- Lưới xám tối giản.
- Node trắng đơn giản.
- Không glow định hướng.
- Không waveform.
- Không audio.
- Chỉ có haptic feedback.

#### Condition B — Full sensory
- Có haptic.
- Có visual waveform.
- Có glow theo vùng/trục.
- Có audio harmonic theo rule.

### 3.2 Sample size
- Tối thiểu 8 người.
- Khuyến nghị 12–16 người.
- Chia đều ngẫu nhiên vào 2 nhóm.

### 3.3 Participant profile
- 50% người hay chơi puzzle mobile.
- 50% người dùng iPhone bình thường, không nhất thiết chơi game nhiều.
- Có ít nhất 2 thiết bị khác nhau nếu có thể: standard iPhone và ProMotion iPhone.

---

## 4. Test scenario

### 4.1 Puzzle test đầu tiên
Dùng **một luật duy nhất**: đối xứng theo trục dọc trên board 5x5.

Lý do chọn:
- Dễ định nghĩa.
- Dễ đo người chơi có hiểu luật không.
- Không cần nhiều tutorial.
- Có thể quan sát rõ hành vi brute-force.

### 4.2 Setup puzzle
- Board 5x5.
- 3 source nodes.
- 3 receiver nodes.
- 1 trục đối xứng trung tâm.
- Trạng thái mở đầu cách nghiệm 4–6 thao tác hợp lý.

### 4.3 Timebox
- 2 phút onboarding.
- 8 phút play session.
- 5 phút phỏng vấn sau test.

---

## 5. Script cho moderator

### 5.1 Mở đầu
"Cảm ơn bạn đã tham gia. Đây là một game puzzle thử nghiệm. Bạn sẽ kéo các node trên lưới. Mục tiêu là làm cho hệ thống phản hồi theo hướng ổn định và đúng hơn. Chúng tôi đang kiểm tra cách người chơi hiểu game, không kiểm tra bạn thông minh đến đâu."

### 5.2 Hướng dẫn trước khi chơi
"Bạn có thể kéo các node. Sau mỗi thay đổi, game sẽ phản hồi. Hãy thử tìm ra điều gì làm hệ thống trở nên đúng hơn."

Lưu ý:
- Không nói có luật đối xứng.
- Không nói về số bước tối ưu.
- Không gợi ý bằng nét mặt hay ngôn ngữ cơ thể.

### 5.3 Trong khi chơi
Moderator chỉ được nhắc:
- "Bạn cứ tiếp tục theo cách bạn thấy hợp lý."
- "Bạn đang nghĩ điều gì đang xảy ra?"
- "Điều gì khiến bạn quyết định nước đi này?"

Không được nói:
- "Bạn đang gần rồi."
- "Hãy nhìn trục giữa."
- "Rung này nghĩa là đúng hơn."

### 5.4 Sau khi chơi
Hỏi cố định:
1. Bạn nghĩ luật của màn này là gì?
2. Bạn biết mình gần đúng hay xa đúng dựa trên điều gì?
3. Có lúc nào bạn cảm thấy mình đang đoán mò không?
4. Điều gì hữu ích nhất: rung, hình ảnh, hay âm thanh?
5. Nếu chỉ giữ lại một loại feedback, bạn chọn gì?

---

## 6. Metrics cần đo

### 6.1 Quantitative metrics
- Solve / not solve.
- Time to solve.
- Total move count.
- Invalid move count.
- Undo-like correction frequency.
- Time to first strong hypothesis.
- Hint requests nếu có.

### 6.2 Derived metrics
- Trial-and-error ratio = total moves / estimated optimal moves.
- Hesitation time = tổng thời gian dừng trước khi kéo tiếp.
- Oscillation count = số lần kéo node qua lại giữa các ô gần nhau.

### 6.3 Qualitative metrics
- Người chơi mô tả luật đúng hay sai.
- Mức tự tin khi mô tả luật.
- Có aha moment hay không.
- Có cảm giác zen hay frustration.

---

## 7. Go / No-Go Criteria

### Go
- Nhóm haptic-only solve rate >= 50%.
- Nhóm haptic-only có ít nhất 60% mô tả đúng luật.
- Move count trung bình của nhóm haptic-only không vượt quá 1.5x nhóm full sensory.
- Ít nhất 50% người chơi haptic-only mô tả có aha moment thực sự.

### No-Go
- Solve rate nhóm haptic-only < 30%.
- Người chơi full sensory giải được nhưng haptic-only không hiểu luật.
- Phần lớn người chơi nói họ đang mò hoặc “bắt sóng”.
- Haptic chỉ được mô tả như tín hiệu phụ xác nhận, không phải nguồn suy luận chính.

### Gray zone
Nếu nhóm haptic-only không đủ mạnh nhưng full sensory rất tốt, cân nhắc pivot sang:
- visual-first puzzle,
- haptic-enhanced premium feel,
- multi-sensory deduction game.

---

## 8. Mẫu form ghi nhận dữ liệu

## Participant Info
- Participant ID:
- Device model:
- Có ốp lưng không:
- Nhóm test: A / B
- Tần suất chơi puzzle: thấp / vừa / cao

## Session Metrics
- Solved: yes / no
- Time to solve:
- Total moves:
- Invalid moves:
- Oscillation count:
- First hypothesis at minute:

## Observation Notes
- Hành vi nổi bật:
- Có dừng để suy nghĩ không:
- Có brute-force không:
- Có dấu hiệu frustration không:
- Quote nổi bật:

## Post-test
- Luật người chơi mô tả:
- Đúng / Sai / Một phần
- Feedback hữu ích nhất:
- Mức tự tin: 1–5
- Aha moment: yes / no

---

## 9. Cách phân tích kết quả

### 9.1 Nếu Haptic-only thắng
Kết luận:
- USP được xác nhận.
- Có thể tiếp tục đầu tư sâu vào haptic language.
- GDD giữ hướng hiện tại.

### 9.2 Nếu Full sensory thắng rõ rệt
Kết luận:
- Haptic không đủ băng thông để làm mechanic cốt lõi.
- Nên đổi định vị sang multi-sensory / visual-led puzzle.
- Cần chỉnh lại marketing story.

### 9.3 Nếu cả hai đều kém
Kết luận:
- Luật đang quá mơ hồ hoặc feedback mapping quá yếu.
- Chưa nên scale backlog.
- Quay lại prototype với rule đơn giản hơn.

---

## 10. Checklist chuẩn bị trước test

- Hai build riêng: Haptic-only và Full sensory.
- Tắt notification trên thiết bị test.
- Chuẩn hóa độ sáng màn hình.
- Kiểm tra rung có hoạt động trên từng máy.
- Chuẩn bị sheet ghi chép hoặc form điện tử.
- Chuẩn bị script thống nhất cho moderator.

---

## 11. Output mong đợi sau playtest

Sau vòng test đầu tiên phải có:
- 1 bảng tổng hợp định lượng.
- 1 trang insight định tính.
- 1 quyết định rõ ràng: continue / pivot / retest.
- 1 danh sách thay đổi bắt buộc cho GDD v1.2.
