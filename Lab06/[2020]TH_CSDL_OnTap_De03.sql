﻿CREATE DATABASE TH_CSDL_DE03
GO

USE DATABASE TH_CSDL_DE03
GO

CREATE TABLE DOCGIA (
	MaDG char(5), 
	HoTen varchar(30),
	NgaySinh smalldatetime,
	DiaChi varchar(30),
	SoDT varchar(15),
	CONSTRAINT pk_dg PRIMARY KEY (MaDG)
); 

CREATE TABLE SACH (
	MaSach char(5),
	TenSach varchar(25),
	TheLoai varchar(25),
	NhaXuatBan varchar(30),
	CONSTRAINT pk_sach PRIMARY KEY (MaSach)
);

CREATE TABLE PHIEUTHUE (
	MaPT char(5),
	MaDG char(5),
	NgayThue smalldatetime,
	NgayTra smalldatetime,
	SoSachThue int,
	CONSTRAINT pk_pt PRIMARY KEY (MaPT),
	CONSTRAINT fk_pt_dg FOREIGN KEY (MaDG) REFERENCES DOCGIA(MaDG)
);

CREATE TABLE CHITIET_PT (
	MaPT char(5),
	MaSach char(5),
	CONSTRAINT pk_ctpt PRIMARY KEY (MaPT, MaSach),
	CONSTRAINT fk_ctpt_pt FOREIGN KEY (MaPT) REFERENCES PHIEUTHUE(MaPT),
	CONSTRAINT fk_ctpt_sach FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);

ALTER TABLE PHIEUTHUE ADD CONSTRAINT chk_ngth
CHECK (DATEDIFF(DAY, NgayThue, NgayTra) >= 0 AND DATEDIFF(DAY, NgayThue, NgayTra) <= 10)
GO

CREATE TRIGGER trg_sosach ON PHIEUTHUE
FOR INSERT, DELETE
AS 
BEGIN
	DECLARE @SoSach int, @MaPT char(5)
	SELECT @SoSach = SoSachThue, @MaPT = MaPT
	FROM INSERTED

	IF (@SoSach <> (SELECT COUNT(*) FROM CHITIET_PT WHERE MaPT = @MaPT))
	BEGIN
		PRINT N'Lỗi: Số sách thuê trong bảng phiếu thuê khác với tổng số lần thuê sách trong bảng chi tiết phiếu thuê'
		ROLLBACK TRANSACTION
	END
END

SELECT PHIEUTHUE.MaDG, HoTen
FROM DOCGIA 
JOIN PHIEUTHUE ON DOCGIA.MaDG = PHIEUTHUE.MaDG
JOIN CHITIET_PT ON PHIEUTHUE.MaPT = CHITIET_PT.MaPT
JOIN SACH ON SACH.MaSach = CHITIET_PT.MaSach
WHERE TheLoai = 'Tin hoc' AND YEAR(NgayThue) = 2007

SELECT DOCGIA.MaDG, HoTen
FROM DOCGIA 
JOIN PHIEUTHUE ON DOCGIA.MaDG = PHIEUTHUE.MaDG
JOIN CHITIET_PT ON PHIEUTHUE.MaPT = CHITIET_PT.MaPT
JOIN SACH ON SACH.MaSach = CHITIET_PT.MaSach
GROUP BY DOCGIA.MaDG
ORDER BY COUNT(TheLoai)

WITH SACH_SOLANTHUE AS (
	SELECT CHITIET_PT.MaSach, TenSach, COUNT(CHITIET_PT.MaPT) AS SoLanThue, TheLoai
	FROM PHIEUTHUE
	JOIN CHITIET_PT ON CHITIET_PT.MaPT = PHIEUTHUE.MaPT
	JOIN SACH ON CHITIET_PT.MaSach = SACH.MaSach
	GROUP BY CHITIET_PT.MaSach, TenSach
)
SELECT TenSach, MAX(SoLanThue) AS SoLanThue
FROM SACH_SOLANTHUE
GROUP BY TheLoai