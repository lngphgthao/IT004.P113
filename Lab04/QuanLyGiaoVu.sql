USE QuanLyGiaoVu

-- BAI TAP 2
-- PHAN III TU CAU 19 DEN CAU 25
-- CAU 19
SELECT MAKHOA, TENKHOA, NGTLAP
FROM KHOA
WHERE NGTLAP = (
	SELECT MIN(NGTLAP)
	FROM KHOA
)

-- CAU 20
SELECT COUNT(MAGV) AS SoLuongGiaoSuVaPhoGiaoSu
FROM GIAOVIEN
WHERE HOCHAM = 'GS' OR HOCHAM = 'PGS'

-- CAU 21
SELECT MAKHOA, HOCVI, COUNT(MAGV) AS SoLuong
FROM GIAOVIEN
GROUP BY MAKHOA, HOCVI

-- CAU 22
SELECT MAMH, KQUA, COUNT(MAHV) AS SoLuong
FROM KETQUATHI
GROUP BY MAMH, KQUA

-- CAU 23
SELECT DISTINCT MAGV
FROM GIANGDAY G 
WHERE MAGV IN (
	SELECT MAGVCN 
	FROM LOP
	WHERE G.MALOP = MALOP
)

-- CAU 24
SELECT HO + ' ' + TEN AS HoTen
FROM LOP JOIN HOCVIEN
ON LOP.TRGLOP = HOCVIEN.MAHV
WHERE SISO = (
	SELECT MAX(SISO)
	FROM LOP
)

-- CAU 25
SELECT HO + ' ' + TEN AS HoTen
FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV 
	FROM KETQUATHI A
	WHERE MAHV IN (
		SELECT TRGLOP 
		FROM LOP
	) AND NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Khong Dat'
	GROUP BY MAHV
	HAVING COUNT(MAMH) >= 3
)

-- BAI TAP 4
-- PHAN III TU CAU 26 DEN CAU 35
-- CAU 26
SELECT MAHV, HO + ' ' + TEN AS HoTen
FROM HOCVIEN
WHERE MAHV IN (
	SELECT TOP 1 MAHV
	FROM KETQUATHI
	WHERE DIEM = 9 OR DIEM = 10
	GROUP BY MAHV
	ORDER BY COUNT(DIEM) DESC
)

-- CAU 27
SELECT MALOP, A.MAHV, HO + ' ' + TEN AS HoTen
FROM KETQUATHI A JOIN HOCVIEN
ON A.MAHV = HOCVIEN.MAHV
WHERE DIEM = 9 OR DIEM = 10
GROUP BY A.MAHV, MALOP, HO, TEN

-- CAU 28
SELECT HOCKY, NAM, MAGV, COUNT(MAMH) AS SoMonHoc, COUNT(MALOP) AS SoLop
FROM GIANGDAY
GROUP BY HOCKY, NAM, MAGV

-- CAU 29
SELECT HOCKY, NAM, A.MAGV, HOTEN 
FROM (
	SELECT HOCKY, NAM, MAGV, RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(MAMH) DESC) RANK_SOMH 
	FROM GIANGDAY
	GROUP BY HOCKY, NAM, MAGV
) A JOIN GIAOVIEN GV 
ON A.MAGV = GV.MAGV
WHERE RANK_SOMH = 1

-- CAU 30
SELECT A.MAMH, TENMH
FROM (
	SELECT MAMH, RANK() OVER (ORDER BY COUNT(MAHV) DESC) RANK_KD 
	FROM KETQUATHI
	WHERE KQUA = 'Khong dat' AND LANTHI = 1
	GROUP BY MAMH
) A JOIN MONHOC
ON A.MAMH = MONHOC.MAMH
WHERE RANK_KD = 1

-- CAU 31
SELECT A.MAHV, HO + ' ' + TEN AS HoTen
FROM (
	SELECT MAHV, COUNT(KQUA) AS SoLanThiDat 
	FROM KETQUATHI 
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) AS SoMonHoc 
	FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) A JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV

-- CAU 32
SELECT C.MAHV, HO + ' ' + TEN AS HoTen
FROM (
	SELECT MAHV, COUNT(KQUA) AS SoLanThiDat 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) AS SoMonHoc 
	FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C JOIN HOCVIEN HV
ON C.MAHV = HV.MAHV

-- CAU 33
SELECT A.MAHV, HO + ' ' + TEN AS HoTen FROM (
	SELECT MAHV, COUNT(KQUA) AS SoLanThiDat 
	FROM KETQUATHI 
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) AS SoMonHoc 
	FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) A JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV

-- CAU 34
SELECT C.MAHV, HO + ' ' + TEN AS HoTen FROM (
	SELECT MAHV, COUNT(KQUA) AS SoLanThiDat 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) AS SoMonHoc
	FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C JOIN HOCVIEN HV
ON C.MAHV = HV.MAHV

-- CAU 35
SELECT A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT B.MAMH, MAHV, DIEM, DIEMMAX
	FROM KETQUATHI B JOIN (
		SELECT MAMH, MAX(DIEM) DIEMMAX 
		FROM KETQUATHI
		GROUP BY MAMH
	) C 
	ON B.MAMH = C.MAMH
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI D 
		WHERE B.MAHV = D.MAHV AND B.MAMH = D.MAMH AND B.LANTHI < D.LANTHI
	) AND DIEM = DIEMMAX
) A JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
