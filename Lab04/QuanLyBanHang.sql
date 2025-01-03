﻿USE QuanLyBanHang

-- BAI TAP 1
-- PHAN III TU CAU 19 DEN CAU 30 
-- CAU 19
SELECT COUNT(SOHD) AS SoLuongHoaDon
FROM HOADON
WHERE MAKH IS NULL

-- CAU 20
SELECT COUNT(*) AS TongSoLuongSanPham
FROM SANPHAM
WHERE MASP IN (
	SELECT MASP
	FROM CTHD JOIN HOADON
	ON CTHD.SOHD = HOADON.SOHD
	WHERE YEAR(NGHD) = 2006 
)

-- CAU 21
SELECT MAX(TRIGIA) AS TriGiaCaoNhat, MIN(TRIGIA) AS TriGiaThapNhat
FROM HOADON

-- CAU 22
SELECT AVG(TRIGIA) AS TriGiaTrungBinh
FROM HOADON
WHERE YEAR(NGHD) = 2006

-- CAU 23
SELECT SUM(TRIGIA) AS DoanhThu
FROM HOADON
WHERE YEAR(NGHD) = 2006

-- CAU 24
SELECT SOHD AS HoaDonCoTriGiaCaoNhat
FROM HOADON
WHERE TRIGIA = (
	SELECT MAX(TRIGIA)
	FROM HOADON
	WHERE YEAR(NGHD) = 2006
)

-- CAU 25
SELECT HOTEN
FROM KHACHHANG JOIN HOADON
ON KHACHHANG.MAKH = HOADON.MAKH
WHERE SOHD IN (
	SELECT SOHD 
	FROM HOADON
	WHERE TRIGIA = (
		SELECT MAX(TRIGIA)
		FROM HOADON
		WHERE YEAR(NGHD) = 2006
	)
)

-- CAU 26
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH IN (
	SELECT TOP 3 MAKH
	FROM HOADON
	GROUP BY MAKH
	ORDER BY SUM(TRIGIA) DESC
)

-- CAU 27
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
	GROUP BY GIA
	ORDER BY GIA DESC
)

-- CAU 28
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
	GROUP BY GIA
	ORDER BY GIA DESC
) AND NUOCSX = 'Thai Lan'

-- CAU 29
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
	GROUP BY GIA
	ORDER BY GIA DESC
) AND NUOCSX = 'Trung Quoc'

-- CAU 30
SELECT TOP 3 HOADON.MAKH, HOTEN, SUM(TRIGIA)
FROM KHACHHANG JOIN HOADON
ON KHACHHANG.MAKH = HOADON.MAKH
GROUP BY HOADON.MAKH, HOTEN
ORDER BY SUM(TRIGIA) DESC

-- BAI TAP 3
-- PHAN III TU CAU 31 DEN CAU 45
-- CAU 31
SELECT NUOCSX, COUNT(MASP) AS SoLuongSPTrungQuoc
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
GROUP BY NUOCSX

-- CAU 32
SELECT NUOCSX, COUNT(MASP) AS SoLuongSP
FROM SANPHAM
GROUP BY NUOCSX

-- CAU 33
SELECT NUOCSX, MAX(GIA) AS GiaCaoNhat, MIN(GIA) AS GiaThapNhat, AVG(GIA) AS TrungBinh
FROM SANPHAM
GROUP BY NUOCSX

-- CAU 34
SELECT NGHD, SUM(TRIGIA) AS DoanhThuMoiNgay
FROM HOADON
GROUP BY NGHD

-- CAU 35
SELECT MASP, COUNT(MASP)
FROM HOADON JOIN CTHD
ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) = 2006 AND MONTH(NGHD) = 10
GROUP BY MASP

-- CAU 36
SELECT MONTH(NGHD) AS Thang, SUM(TRIGIA) AS DoanhThu
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

-- CAU 37
SELECT SOHD
FROM CTHD
GROUP BY SOHD
HAVING COUNT(MASP) >= 4

-- CAU 38
SELECT SOHD
FROM CTHD JOIN SANPHAM
ON CTHD.MASP = SANPHAM.MASP
WHERE NUOCSX = 'Viet Nam'
GROUP BY SOHD
HAVING COUNT(CTHD.MASP) >= 3

-- CAU 39
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH IN (
	SELECT TOP 1 MAKH
	FROM HOADON
	GROUP BY MAKH
	ORDER BY COUNT(SOHD) DESC
)

-- CAU 40
SELECT TOP 1 MONTH(NGHD) AS Thang
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC

-- CAU 41
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP IN (
	SELECT TOP 1 MASP
	FROM CTHD
	GROUP BY MASP
	ORDER BY COUNT(MASP)
)

-- CAU 42
SELECT MASP, TENSP, NUOCSX, GIA
FROM SANPHAM S
WHERE GIA IN (
	SELECT MAX(GIA) 
	FROM SANPHAM
	WHERE NUOCSX = S.NUOCSX
)

-- CAU 43
SELECT NUOCSX
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

-- CAU 44
SELECT TOP 1 HOADON.MAKH, HOTEN, COUNT(SOHD) AS SoLanMuaHang
FROM HOADON JOIN KHACHHANG
ON HOADON.MAKH = KHACHHANG.MAKH
WHERE HOADON.MAKH IN (
	SELECT TOP 10 MAKH
	FROM HOADON
	GROUP BY MAKH
	ORDER BY SUM(TRIGIA) DESC
)
GROUP BY HOADON.MAKH, HOTEN