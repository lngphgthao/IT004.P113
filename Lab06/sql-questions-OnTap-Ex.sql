-- Câu hỏi SQL từ cơ bản đến nâng cao, bao gồm trigger

-- Cơ bản:
1. Liệt kê tất cả chuyên gia trong cơ sở dữ liệu.
SELECT * FROM ChuyenGia

2. Hiển thị tên và email của các chuyên gia nữ.
SELECT HoTen, Email
FROM ChuyenGia
WHERE GioiTinh = N'Nữ'

3. Liệt kê các công ty có trên 100 nhân viên.
SELECT *
FROM CongTy
WHERE SoNhanVien > 100

4. Hiển thị tên và ngày bắt đầu của các dự án trong năm 2023.
SELECT TenDuAn, NgayBatDau
FROM DuAn
WHERE YEAR(NgayBatDau) = 2023

5. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT COUNT(MaChuyenGia)
FROM ChuyenGia
GROUP BY ChuyenNganh

-- Trung cấp:
6. Liệt kê tên chuyên gia và số lượng dự án họ tham gia.
SELECT HoTen, COUNT(ChuyenGia_DuAn.MaChuyenGia) AS SoLuongDuAn
FROM ChuyenGia_DuAn JOIN ChuyenGia
ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY ChuyenGia_DuAn.MaChuyenGia, HoTen

7. Tìm các dự án có sự tham gia của chuyên gia có kỹ năng 'Python' cấp độ 4 trở lên.
SELECT ChuyenGia_DuAn.MaDuAn, TenDuAn
FROM DuAn JOIN ChuyenGia_DuAn
ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
WHERE MaChuyenGia IN (
	SELECT ChuyenGia_KyNang.MaChuyenGia
	FROM ChuyenGia 
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	JOIN KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
	WHERE TenKyNang = N'Python' AND CapDo >= 4
)

8. Hiển thị tên công ty và số lượng dự án đang thực hiện.
SELECT TenCongTy, COUNT(MaDuAn) AS SoLuongDuAn
FROM CongTy JOIN DuAn
ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY DuAn.MaCongTy, TenCongTy

9. Tìm chuyên gia có số năm kinh nghiệm cao nhất trong mỗi chuyên ngành.
WITH RankedChuyenGia AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY ChuyenNganh ORDER BY NamKinhNghiem DESC) AS Rank
    FROM ChuyenGia
)
SELECT HoTen, ChuyenNganh, NamKinhNghiem
FROM RankedChuyenGia
WHERE Rank = 1;

10. Liệt kê các cặp chuyên gia đã từng làm việc cùng nhau trong ít nhất một dự án.
SELECT DISTINCT 
	cg1.HoTen AS CG1, cg2.HoTen AS CG2,
	DuAn.TenDuAn
FROM ChuyenGia_DuAn cgda1
JOIN ChuyenGia_DuAn cgda2 ON cgda1.MaDuAn = cgda2.MaDuAn AND cgda1.MaChuyenGia < cgda2.MaChuyenGia
JOIN ChuyenGia CG1 ON cgda1.MaChuyenGia = CG1.MaChuyenGia
JOIN ChuyenGia CG2 ON cgda2.MaChuyenGia = CG2.MaChuyenGia
JOIN DuAn ON cgda1.MaDuAn = DuAn.MaDuAn;

-- Nâng cao:
11. Tính tổng thời gian (theo ngày) mà mỗi chuyên gia đã tham gia vào các dự án.
SELECT HoTen, TenDuAn, DATEDIFF(DAY, NgayThamGia, NgayKetThuc) AS NgayThamGia
FROM ChuyenGia 
JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
JOIN DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn

12. Tìm các công ty có tỷ lệ dự án hoàn thành cao nhất (trên 90%).


13. Liệt kê top 3 kỹ năng được yêu cầu nhiều nhất trong các dự án.

14. Tính lương trung bình của chuyên gia theo từng cấp độ kinh nghiệm (Junior: 0-2 năm, Middle: 3-5 năm, Senior: >5 năm).


15. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.


-- Trigger:
16. Tạo một trigger để tự động cập nhật số lượng dự án của công ty khi thêm hoặc xóa dự án.



17. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng ChuyenGia.


18. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.

19. Tạo một trigger để tự động cập nhật trạng thái của dự án thành 'Hoàn thành' khi tất cả chuyên gia đã kết thúc công việc.


20. Tạo một trigger để tự động tính toán và cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
