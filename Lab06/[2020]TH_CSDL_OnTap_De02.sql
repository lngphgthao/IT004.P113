﻿CREATE DATABASE TH_CSDL_DE02
GO

USE DATABASE TH_CSDL_DE02
GO

CREATE TABLE NHANVIEN (
	MaNV char(5), 
	HoTen varchar(20),
	NgayVL smalldatetime,
	HSLuong numeric(4,2),
	MaPhong char(5),
	CONSTRAINT pk_nv PRIMARY KEY (MaNV)
); 

CREATE TABLE PHONGBAN (
	MaPhong char(5),
	TenPhong varchar(25),
	TruongPhong char(5),
	CONSTRAINT pk_pb PRIMARY KEY (MaPhong)
);

CREATE TABLE XE (
	MaXe char(5),
	LoaiXe varchar(20),
	SoChoNgoi int,
	NamSX int,
	CONSTRAINT pk_xe PRIMARY KEY (MaXe)
);

CREATE TABLE PHANCONG (
	MaPC char(5),
	MaNV char(5),
	MaXe char(5),
	NgayDi smalldatetime, 
	NgayVe smalldatetime,
	NoiDen varchar(25),
	CONSTRAINT pk_pc PRIMARY KEY (MaPC)
)
GO

ALTER TABLE NHANVIEN
ADD CONSTRAINT fk_nv_pb FOREIGN KEY (MaPhong) REFERENCES PHONGBAN(MaPhong)

ALTER TABLE PHONGBAN
ADD CONSTRAINT fk_pb_nv FOREIGN KEY (TruongPhong) REFERENCES NHANVIEN(MaNV)

ALTER TABLE PHANCONG
ADD CONSTRAINT fk_pc_nv FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
	CONSTRAINT fk_pc_xe FOREIGN KEY (MaXe) REFERENCES XE(MaXe)

ALTER TABLE XE ADD CONSTRAINT chk_nsx
CHECK (NamSX >= 2006)
GO

CREATE TRIGGER trg_chk_xe ON PhanCong
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaNV char(5), @MaXe char(5), @MaPhong char(5), @TenPhong char(5), @TenXe varchar(20)
	SELECT @MaNV = MaNV, @MaXe = MaXe
	FROM INSERTED

	SELECT @MaPhong = MaPhong FROM NHANVIEN	WHERE MaNV = @MaNV

	SELECT @TenPhong = TenPhong FROM PHONGBAN WHERE MaPhong = @MaPhong

	SELECT @TenXe = LoaiXe FROM XE WHERE MaXe = @MaXe

	IF (@TenPhong = 'Ngoai thanh' AND @TenXe <> 'Toyota')
	BEGIN
		PRINT N'Lỗi: Nhân viên thuộc phòng ban ngoại thành chỉ được lái xe loại Toyota.'
		ROLLBACK TRANSACTION
	END
END

SELECT MaNV, HoTen
FROM NHANVIEN 
JOIN PHONGBAN ON NHANVIEN.MaPhong = PHONGBAN.MaPhong
JOIN PHANCONG ON NHANVIEN.MaNV = PHANCONG.MaNV
JOIN XE ON PHANCONG.MaXe = XE.MaXe
WHERE TenPhong = 'Noi thanh' AND LoaiXe = 'Toyota' AND SoChoNgoi = 4

-- Cach 1
SELECT MaNV, HoTen
FROM NHANVIEN
WHERE MaNV NOT IN (
	SELECT MaNV 
	FROM (
		SELECT MaNV, MaXe
		FROM (
			(SELECT DISTINCT MaNV FROM PHANCONG) AS P
			CROSS JOIN
			(SELECT MaXe FROM XE) AS Q
		)
		EXCEPT 
		SELECT MaNV, MaXe
		FROM PHANCONG
	) AS T
) AND MaNV IN (
	SELECT TruongPhong
	FROM PHONGBAN
)

-- Cach 2
SELECT MaNV, HoTen
FROM NHANVIEN
WHERE MaNV IN (
	SELECT MaNV
	FROM PHANCONG AS R
	WHERE NOT EXISTS (
		SELECT P.MaXe FROM XE AS P
		EXCEPT
		SELECT S.MaXe FROM PHANCONG AS S
		WHERE R.MaNV = S.MaNV
	)
) AND MaNV IN (
	SELECT TruongPhong
	FROM PHONGBAN
) 

WITH PCPB AS (
	SELECT PHANCONG.MaNV, 
		ROW_NUMBER() OVER (PARTITION BY MaPhong ORDER BY COUNT(MaNV)) AS Rank
	FROM PHANCONG 
	JOIN NHANVIEN ON PHANCONG.MaNV = NHANVIEN.MaNV 
	JOIN XE ON PHANCONG.MaXe = XE.MaXe
	WHERE LoaiXe = 'Toyota'
)
SELECT PCPB.MaNV, HoTen
FROM NHANVIEN JOIN PCPB 
ON NHANVIEN.MaNV = PCPB.MaNV
WHERE Rank = 1