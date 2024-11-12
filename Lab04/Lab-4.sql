USE it_cs_database

-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3 ChuyenGia_KyNang.MaChuyenGia, HoTen, COUNT(MaKyNang) AS SoLuong
FROM ChuyenGia_KyNang JOIN ChuyenGia
ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY ChuyenGia_KyNang.MaChuyenGia, HoTen
ORDER BY COUNT(MaKyNang) DESC

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT 
    cg1.HoTen AS ChuyenGia1, 
    cg2.HoTen AS ChuyenGia2, 
    cg1.ChuyenNganh, 
    cg1.NamKinhNghiem AS NamKinhNghiem_ChuyenGia1, 
    cg2.NamKinhNghiem AS NamKinhNghiem_ChuyenGia2
FROM ChuyenGia cg1 JOIN ChuyenGia cg2 
ON cg1.ChuyenNganh = cg2.ChuyenNganh 
WHERE cg1.MaChuyenGia < cg2.MaChuyenGia AND ABS(cg1.NamKinhNghiem - cg2.NamKinhNghiem) <= 2;


-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT TenCongTy, COUNT(A.MaDuAn) AS SoLuongDuAn, SUM(NamKinhNghiem) AS TongNamKinhNghiem
FROM DuAn JOIN ChuyenGia_DuAn A
ON DuAn.MaDuAn = A.MaDuAn
JOIN ChuyenGia ON A.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN CongTy ON DuAn.MaCongTy = CongTy.MaCongTy
GROUP BY TenCongTy

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT A.MaChuyenGia, HoTen
FROM ChuyenGia_KyNang A JOIN ChuyenGia
ON A.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY A.MaChuyenGia, HoTen
HAVING COUNT(CASE WHEN CapDo = 5 THEN 1 END) >= 1 AND COUNT(CASE WHEN CapDo <= 3 THEN 1 END) = 0

-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT A.MaChuyenGia, HoTen, COUNT(MaDuAn) SoLuongDuAn
FROM ChuyenGia_DuAn A JOIN ChuyenGia
ON A.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY A.MaChuyenGia, HoTen

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
SELECT A.MaChuyenGia, HoTen, TenKyNang, CapDo
FROM (
	SELECT MaChuyenGia, MaKyNang, CapDo, RANK() OVER (PARTITION BY MaKyNang ORDER BY CapDo DESC) RANK_KN 
	FROM ChuyenGia_KyNang
) A JOIN ChuyenGia
ON A.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN KyNang ON A.MaKyNang = KyNang.MaKyNang
WHERE RANK_KN = 1

-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
SELECT ChuyenNganh, (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ChuyenGia)) AS TyLePhanTram
FROM ChuyenGia
GROUP BY ChuyenNganh

-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
SELECT k1.TenKyNang AS KyNang1, k2.TenKyNang AS KyNang2, COUNT(*) AS SoLanCungXuatHien
FROM ChuyenGia_KyNang c1 JOIN ChuyenGia_KyNang c2 
ON c1.MaChuyenGia = c2.MaChuyenGia AND c1.MaKyNang < c2.MaKyNang
JOIN KyNang k1 ON c1.MaKyNang = k1.MaKyNang
JOIN KyNang k2 ON c2.MaKyNang = k2.MaKyNang
GROUP BY k1.TenKyNang, k2.TenKyNang
ORDER BY SoLanCungXuatHien DESC


-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT CongTy.TenCongTy, AVG(DATEDIFF(DAY, DuAn.NgayBatDau, DuAn.NgayKetThuc)) AS SoNgayTrungBinh
FROM DuAn 
JOIN CongTy ON DuAn.MaCongTy = CongTy.MaCongTy
GROUP BY CongTy.TenCongTy

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
SELECT ChuyenGia.HoTen, COUNT(DISTINCT A.MaKyNang) AS SoKyNangDocDao
FROM ChuyenGia JOIN ChuyenGia_KyNang A ON ChuyenGia.MaChuyenGia = A.MaChuyenGia
GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
HAVING COUNT(DISTINCT A.MaKyNang) = 1;

-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
SELECT 
    ChuyenGia.HoTen, 
    COUNT(DISTINCT da.MaDuAn) AS SoLuongDuAn, 
    SUM(cgn.CapDo) AS TongCapDoKyNang,
    RANK() OVER (ORDER BY COUNT(DISTINCT da.MaDuAn) DESC, SUM(cgn.CapDo) DESC) AS XepHang
FROM ChuyenGia LEFT JOIN ChuyenGia_DuAn da 
ON ChuyenGia.MaChuyenGia = da.MaChuyenGia
LEFT JOIN ChuyenGia_KyNang cgn 
ON ChuyenGia.MaChuyenGia = cgn.MaChuyenGia
GROUP BY ChuyenGia.HoTen


-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT da.TenDuAn
FROM DuAn da JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia ON cda.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY da.TenDuAn
HAVING COUNT(DISTINCT ChuyenGia.ChuyenNganh) = (SELECT COUNT(DISTINCT ChuyenNganh) FROM ChuyenGia);


-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
SELECT TenCongTy, (COUNT(CASE WHEN TrangThai = N'Hoàn thành' THEN 1 END) * 100.0 / COUNT(*)) AS TyLeThanhCong
FROM CongTy JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY TenCongTy;

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
SELECT 
    cg1.HoTen AS ChuyenGia1, 
    cg2.HoTen AS ChuyenGia2, 
    k1.TenKyNang AS KyNang_A, 
    k2.TenKyNang AS KyNang_B
FROM ChuyenGia_KyNang cgn1
JOIN ChuyenGia cg1 ON cgn1.MaChuyenGia = cg1.MaChuyenGia
JOIN ChuyenGia_KyNang cgn2 ON cgn1.MaKyNang = cgn2.MaKyNang 
JOIN ChuyenGia cg2 ON cgn2.MaChuyenGia = cg2.MaChuyenGia
AND cgn1.CapDo >= 4 AND cgn2.CapDo <= 2 AND cgn1.MaChuyenGia != cgn2.MaChuyenGia
JOIN KyNang k1 ON cgn1.MaKyNang = k1.MaKyNang
JOIN KyNang k2 ON cgn2.MaKyNang = k2.MaKyNang
ORDER BY cg1.HoTen, cg2.HoTen;
