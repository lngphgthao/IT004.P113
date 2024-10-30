USE it_cs_database

-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
SELECT HoTen, TenKyNang, CapDo
FROM ChuyenGia_KyNang JOIN ChuyenGia
ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE ChuyenGia_KyNang.MaChuyenGia = 1

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
SELECT HoTen
FROM ChuyenGia_DuAn JOIN ChuyenGia
ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
WHERE MaDuAn = 2

-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
SELECT TenDuAn, TenCongTy
FROM DuAn JOIN CongTy
ON DuAn.MaCongTy = CongTy.MaCongTy

-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(MaChuyenGia)
FROM ChuyenGia
GROUP BY ChuyenNganh

-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT *
FROM ChuyenGia
WHERE NamKinhNghiem IN (
	SELECT MAX(NamKinhNghiem)
	FROM ChuyenGia
)

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
SELECT HoTen, COUNT(MaDuAn) AS SoLuongDuAn
FROM ChuyenGia_DuAn JOIN ChuyenGia
ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY HoTen

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
SELECT TenCongTy, COUNT(MaDuAn) AS SoLuongDuAn
FROM DuAn JOIN CongTy
ON DuAn.MaCongTy = CongTy.MaCongTy
GROUP BY TenCongTy

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
SELECT TOP 1 TenKyNang, COUNT(ChuyenGia_KyNang.MaChuyenGia) AS SoLuongChuyenGia
FROM KyNang JOIN ChuyenGia_KyNang 
ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
GROUP BY TenKyNang
ORDER BY SoLuongChuyenGia DESC

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
SELECT HoTen
FROM ChuyenGia_KyNang A JOIN ChuyenGia B
ON A.MaChuyenGia = B.MaChuyenGia
JOIN KyNang C
ON A.MaKyNang = C.MaKyNang
WHERE TenKyNang = 'Python' AND CapDo >= 4

-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
SELECT TOP 1 TenDuAn, COUNT(MaChuyenGia) AS SoLuongChuyenGia	
FROM ChuyenGia_DuAn JOIN DuAn
ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn
GROUP BY TenDuAn
ORDER BY SoLuongChuyenGia DESC

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
SELECT HoTen, COUNT(MaKyNang) AS SoLuongKyNang
FROM ChuyenGia_KyNang A JOIN ChuyenGia B
ON A.MaChuyenGia = B.MaChuyenGia
GROUP BY HoTen

-- 19. Tìm các cặp chuyên gia làm việc cùng dự án.
SELECT TenDuAn, HoTen
FROM ChuyenGia_DuAn A JOIN ChuyenGia B
ON A.MaChuyenGia = B.MaChuyenGia
JOIN DuAn C
ON A.MaDuAn = C.MaDuAn
ORDER BY TenDuAn

-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
SELECT HoTen, COUNT(MaKyNang) AS SoLuongKyNang
FROM ChuyenGia_KyNang A JOIN ChuyenGia B
ON A.MaChuyenGia = B.MaChuyenGia
WHERE CapDo = 5
GROUP BY HoTen

-- 21. Tìm các công ty không có dự án nào.
SELECT MaCongTy, TenCongTy
FROM CongTy
WHERE NOT EXISTS (
	SELECT MaCongTy
	FROM DuAn
)

-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
SELECT HoTen, TenDuAn
FROM ChuyenGia_DuAn JOIN DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn
LEFT JOIN ChuyenGia
ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia

-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
SELECT HoTen, COUNT(MaKyNang) AS SoLuongKyNang
FROM ChuyenGia_KyNang A JOIN ChuyenGia B
ON A.MaChuyenGia = B.MaChuyenGia
GROUP BY HoTen
HAVING COUNT(MaKyNang) >= 3

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
SELECT TenCongTy, SUM(NamKinhNghiem) AS TongSoNamKinhNghiem
FROM CongTy JOIN DuAn ON CongTy.MaCongTy = DuAn.MaDuAn
			JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
			JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY TenCongTy

-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
SELECT HoTen
FROM ChuyenGia_KyNang JOIN KyNang
ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
JOIN ChuyenGia ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
WHERE TenKyNang = 'Java'
EXCEPT
SELECT HoTen
FROM ChuyenGia_KyNang JOIN KyNang
ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
JOIN ChuyenGia ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
WHERE TenKyNang = 'Python'

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất..
WITH A AS (
	SELECT HoTen, COUNT(MaKyNang) AS SoLuongKyNang
	FROM ChuyenGia_KyNang A JOIN ChuyenGia B
	ON A.MaChuyenGia = B.MaChuyenGia
	GROUP BY HoTen
)

SELECT HoTen, SoLuongKyNang
FROM A
WHERE SoLuongKyNang = (
	SELECT MAX(SoLuongKyNang)
	FROM A
)

-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
ORDER BY ChuyenNganh

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
WITH SoNamKinhNghiem AS (
	SELECT TenCongTy, SUM(NamKinhNghiem) AS TongSoNamKinhNghiem
	FROM CongTy JOIN DuAn ON CongTy.MaCongTy = DuAn.MaDuAn
				JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
				JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
	GROUP BY TenCongTy
)

SELECT TenCongTy, TongSoNamKinhNghiem
FROM SoNamKinhNghiem
WHERE TongSoNamKinhNghiem = (
	SELECT MAX(TongSoNamKinhNghiem)
	FROM SoNamKinhNghiem
)

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
SELECT TenKyNang
FROM ChuyenGia_KyNang R1 JOIN KyNang
ON R1.MaKyNang = KyNang.MaKyNang
WHERE NOT EXISTS (
	SELECT MaChuyenGia
	FROM ChuyenGia
	EXCEPT
	SELECT MaChuyenGia
	FROM ChuyenGia_KyNang R2
	WHERE R1.MaKyNang = R2.MaKyNang 
) 
