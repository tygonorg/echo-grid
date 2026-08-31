# Echo Grid — Validation Prototype Specification

## 1. Mục tiêu tài liệu

Tài liệu này xác định chi tiết đặc tả kỹ thuật và gameplay của **Validation Prototype** (Phase 0 Spike) nhằm kiểm chứng giả thuyết: *Người chơi mới có thể hiểu và suy luận ra hidden rule nhờ phản hồi haptic trên iPhone hay không*.

---

## 2. Phạm vi thử nghiệm (Test Scope)

| Thành phần | Đặc tả | Ghi chú |
|---|---|---|
| **Kích thước bảng** | Lưới 5 x 5 (25 ô) | Tối giản, kiểm soát không gian trạng thái |
| **Hidden Rule** | Đối xứng trục dọc (Vertical Axis Symmetry, col = 2) | 1 luật duy nhất, trực quan và đo lường được |
| **Số lượng Node** | 6 nodes: 3 Source nodes (cố định), 3 Movable nodes (kéo thả) | Khoảng cách trạng thái mở đầu đến nghiệm: 4–6 moves |
| **Interaction** | Touch Drag & Snap to Grid | Hạn chế tối đa latency, snapping dứt khoát |
| **Chế độ kiểm tra (Build Modes)** | Condition A: **Haptic-Only** <br> Condition B: **Full Sensory** | Chuyển đổi nhanh qua giao diện Test Harness |
| **Hệ thống đo lường** | Real-time Telemetry & Session Logger | Lưu logs chi tiết vào bộ nhớ và hỗ trợ export JSON |

---

## 3. Thiết kế Bàn cờ & Luật chơi

### 3.1 Tọa độ & Trục đối xứng
- Lưới gồm các ô có toạ độ `(row, col)` với `row ∈ [0, 4]` và `col ∈ [0, 4]`.
- Trục đối xứng dọc là cột trung tâm `col = 2`.
- Đối với một vị trí `(r, c)`, vị trí đối xứng qua trục dọc là `(r, 4 - c)`.

### 3.2 Cấu hình Node ban đầu (Opening State)

Trạng thái khởi tạo được thiết kế sao cho không quá sát nghiệm và không thể ngẫu nhiên giải được sau 1–2 thao tác:

- **Source Nodes (Cố định - Không thể kéo):**
  1. `S1`: `(0, 0)` -> Mục tiêu đối xứng là `(0, 4)`
  2. `S2`: `(2, 1)` -> Mụctiêu đối xứng là `(2, 3)`
  3. `S3`: `(4, 0)` -> Mục tiêu đối xứng là `(4, 4)`

- **Movable Nodes (Người chơi có thể kéo thả):**
  1. `M1`: Khởi tạo tại `(1, 3)` — Cần đưa về `(0, 4)`
  2. `M2`: Khởi tạo tại `(3, 4)` — Cần đưa về `(2, 3)`
  3. `M3`: Khởi tạo tại `(4, 2)` — Cần đưa về `(4, 4)`

*Khoảng cách Manhattan tổng cộng từ trạng thái mở đầu đến nghiệm:* 6 bước di chuyển tối ưu.

---

## 4. Cơ chế Đánh giá & Phản hồi (Rule Evaluation & Feedback)

### 4.1 Hàm Resonance Score
Resonance Score \( S \in [0.0, 1.0] \) đo lường mức độ hoàn thiện của bàn cờ:

\[
S = \frac{1}{N} \sum_{i=1}^{N} \max\left(0, 1.0 - \frac{d(M_i, \text{Target}_i)}{d_{\max}}\right)
\]

- Khi \( S = 1.0 \): Trạng thái hoàn thành (**Solved**).
- \( S < 0.3 \): Trạng thái sai xa (**Far**).
- \( 0.3 \le S < 1.0 \): Trạng thái đang tiến triển / gần đúng (**Progress / Close**).

### 4.2 Ngôn ngữ Haptic (3 cấp độ)

| Trạng thái | Điều kiện | Kiểu xung Haptic | Ý nghĩa |
|---|---|---|---|
| **Far (Sai xa)** | \( S < 0.3 \) hoặc thao tác làm giảm Score | Xung nhẹ, thưa, low sharpness (`intensity: 0.3, sharpness: 0.2`) | "Hệ thống tĩnh lặng / chưa bắt được pha" |
| **Progress (Gần đúng)** | \( 0.3 \le S < 1.0 \) và Score tăng | Xung kép sắc nét (`intensity: 0.65, sharpness: 0.6`), nhịp cộng hưởng | "Đang đi đúng hướng, tăng liên kết" |
| **Solved (Hoàn thành)** | \( S = 1.0 \) | Chuỗi xung hài hòa tăng dần tần số và cường độ (Chord Haptic Burst) | "Đồng pha hoàn toàn — Aha Moment" |
| **Snap Feedback** | Thả vào ô hợp lệ | Xung click micro (`intensity: 0.4, sharpness: 0.8`) | Xác nhận cơ học của bàn cờ |

---

## 5. Đặc tả 2 Chế độ Test

### 5.1 Condition A — Haptic-Only
- **Mục đích:** Độc lập hoá kênh xúc giác để đo khả năng suy luận thuần tuý.
- **Visual:** Giao diện phẳng xám tối giản (#1A1A1A), các ô lưới đường kẻ mờ, các node hình tròn trắng/xám đơn sắc. Không có hiệu ứng sáng (glow), không có đường nối (lines), không có hoạt họa sóng.
- **Audio:** Hoàn toàn im lặng (Muted).
- **Haptic:** Đầy đủ 3 cấp độ rung như mục 4.2.

### 5.2 Condition B — Full Sensory
- **Visual:** Nền tối có dynamic particle/waveforms. Khi các node tiến gần vị trí đối xứng, xuất hiện đường liên kết năng lượng phát sáng (energy resonance lines) và glow nhẹ ở trục giữa.
- **Audio:** Mỗi thao tác di chuyển đúng phát âm thanh sine wave hòa âm chuẩn theo nốt pentatonic, âm lượng tỷ lệ thuận với Resonance Score. Khi Solved phát hợp âm hoàn thiện.
- **Haptic:** Kích hoạt đồng bộ với hình ảnh và âm thanh.

---

## 6. Giao diện Test Harness & Debug Overlay

Prototype tích hợp sẵn menu điều khiển dành cho người chủ trì (Moderator) và tester:
- **Condition Selector:** Nút bấm nhanh chuyển đổi giữa `Condition A (Haptic)` và `Condition B (Full)`.
- **Reset Button:** Khôi phục trạng thái ban đầu để bắt đầu lượt đo mới.
- **Debug Overlay Toggle:** Hiển thị HUD gồm:
  - Real-time Resonance Score.
  - Số bước đi (`Move Count`).
  - Số lần dao động (`Oscillation Count`).
  - Thời gian trôi qua (`Elapsed Time`).
  - Trạng thái máy ảo (`Session State`).
- **Data Viewer / Export:** Xem và copy chuỗi JSON ghi nhận toàn bộ session.
