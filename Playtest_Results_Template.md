# Echo Grid — Playtest Results Template

## 1. Thông tin đợt thử nghiệm

- **Đợt thử nghiệm:** Phase 0 — Validation Spike (Cohort 1)
- **Ngày thực hiện:** `YYYY-MM-DD`
- **Người chủ trì (Moderator):**
- **Địa điểm / Môi trường:** Yên tĩnh / Văn phòng
- **Phiên bản Prototype:** Build v0.1 (Commit / Date)

---

## 2. Bảng dữ liệu tổng hợp người tham gia (Participant Log)

| ID | Nhóm (A/B) | Thiết bị | Ốp lưng | Đã giải (Y/N) | Thời gian (giây) | Tổng Moves | Dao động | Đoán đúng luật? | Feedback hữu ích nhất | Điểm tự tin (1-5) | Aha moment? |
|---|---|---|---|---|---|---|---|---|---|---|---|
| P01 | A (Haptic) | iPhone 15 Pro | Có | | | | | | | | |
| P02 | B (Full) | iPhone 14 | Không | | | | | | | | |
| P03 | A (Haptic) | iPhone 13 | Có | | | | | | | | |
| P04 | B (Full) | iPhone 15 Pro | Có | | | | | | | | |
| P05 | A (Haptic) | iPhone 12 | Không | | | | | | | | |
| P06 | B (Full) | iPhone 15 | Có | | | | | | | | |
| P07 | A (Haptic) | iPhone SE 3 | Không | | | | | | | | |
| P08 | B (Full) | iPhone 15 Pro | Có | | | | | | | | |

---

## 3. Tổng hợp Chỉ số Đo lường (Cohort Summary Metrics)

### 3.1 So sánh Định lượng Condition A vs Condition B

| Chỉ số (Metric) | Nhóm A (Haptic-Only) | Nhóm B (Full Sensory) | Delta / Ratio | Ngưỡng yêu cầu (Target) | Đạt / Không đạt |
|---|---|---|---|---|---|
| **Tỷ lệ giải thành công (Solve Rate)** | `%` (X/4) | `%` (Y/4) | - | $\ge 50\%$ | |
| **Thời gian giải trung bình (Avg Time)** | `...s` | `...s` | - | $\le 480\text{s}$ (8 phút) | |
| **Số nước đi trung bình (Avg Moves)** | `...` | `...` | `...x` | $\le 1.5\text{x}$ nhóm B | |
| **Tỷ lệ nhận diện đúng luật (Rule Recall)** | `%` (X/4) | `%` (Y/4) | - | $\ge 60\%$ | |
| **Tỷ lệ có Aha Moment** | `%` (X/4) | `%` (Y/4) | - | $\ge 50\%$ | |

---

## 4. Ghi nhận Định tính & Quan sát Hành vi (Qualitative Insights)

### 4.1 Nhóm Haptic-Only
- **Hành vi phát hiện luật:**
  *(Người chơi mất bao lâu để nhận ra nhịp rung thay đổi? Có xu hướng thử kéo các ô lân cận hay di chuyển ngẫu nhiên?)*
- **Rào cản / Frustration:**
  *(Có trường hợp nào người chơi bị bối rối vì rung quá nhẹ hoặc không phân biệt được 2 trạng thái không?)*
- **Trích dẫn tiêu biểu của người chơi (Verbatim Quotes):**
  - *Quote 1:* "..."
  - *Quote 2:* "..."

### 4.2 Nhóm Full Sensory
- **Sự tương tác giữa các giác quan:**
  *(Người chơi nhìn vào glow line trước hay lắng nghe âm thanh trước? Haptic đóng vai trò xúc giác phụ trợ hay chủ đạo?)*
- **Trích dẫn tiêu biểu:**
  - *Quote 1:* "..."

---

## 5. Đánh giá Cổng quyết định (Go / No-Go Decision Gate)

Dựa trên tiêu chuẩn tại [EchoGrid_Playtest_Kit.md](file:///Users/tphung/Documents/project/Echo%20Grid/EchoGrid_Playtest_Kit.md):

- [ ] **KỊCH BẢN GO (Giữ định vị Haptic-First Deduction):**
  - Nhóm Haptic-Only có Solve Rate $\ge 50\%$.
  - Nhóm Haptic-Only có Rule Recall $\ge 60\%$.
  - Avg Moves của nhóm Haptic $\le 1.5\text{x}$ nhóm Full.
  - $\ge 50\%$ người chơi Haptic-only có Aha moment.
  - **Hành động tiếp theo:** Giữ GDD v1.2, tiến hành Sprint 1 với Haptic Engine mở rộng.

- [ ] **KỊCH BẢN PIVOT (Chuyển sang Visual-First with Haptic Delight):**
  - Nhóm Full Sensory giải tốt và thích thú, nhưng nhóm Haptic-Only không suy luận được luật (Recall $< 40\%$, Solve $< 30\%$).
  - Người chơi Haptic-Only phản ánh cảm giác "mò mẫm / đoán mò".
  - **Hành động tiếp theo:** Viết `Pivot_Memo.md`, ban hành `GDD_v1.3.md`, đổi trọng số feedback sang Visual-led.

- [ ] **KỊCH BẢN RETEST (Thử nghiệm lại với Rule đơn giản hơn):**
  - Cả hai nhóm đều gặp khó khăn bất thường do UX/Interaction friction chứ không phải do cơ chế giác quan.
  - **Hành động tiếp theo:** Tinh chỉnh cơ chế Snap và feedback rồi test lại Cohort 2.

---

## 6. Kết luận & Phê duyệt của Product Lead

- **Quyết định chính thức:** `[ GO / PIVOT / RETEST ]`
- **Lý do căn cứ dữ liệu:**
- **Ký duyệt:** `[Product Owner / Lead Engineer]`
