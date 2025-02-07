CREATE DATABASE TH_CSDL_DE01
GO

USE TH_CSDL_DE01
GO

CREATE TABLE TACGIA (
	MaTG char(5),
	HoTen varchar(20),
	DiaChi varchar(50),
	NgSinh smalldatetime,
	SoDT varchar(15),
	CONSTRAINT pk_tg PRIMARY KEY (MaTG)
);

CREATE TABLE SACH (
	MaSach char(5),
	TenSach varchar(25),
	TheLoai varchar(25),
	CONSTRAINT pk_sach PRIMARY KEY (MaSach)
);

CREATE TABLE TACGIA_SACH (
	MaTG char(5),
	MaSach char(5),
	CONSTRAINT pk_tg_sach PRIMARY KEY (MaTG, MaSach),
	CONSTRAINT fk_tgsach_tg FOREIGN KEY (MaTG) REFERENCES TACGIA(MaTG),
	CONSTRAINT fk_tgsach_sach FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);

CREATE TABLE PHATHANH (
	MaPH char(5),
	MaSach char(5),
	NgayPH smalldatetime, 
	SoLuong int, 
	NhaXuatBan varchar(20),
	CONSTRAINT pk_tg PRIMARY KEY (MaPH),
	CONSTRAINT fk_ph_sach FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);
GO

CREATE TRIGGER trg_nph_ns ON PHATHANH
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaTG char(5), @MaSach char(5), @NPH smalldatetime, @NS smalldatetime
	SELECT @NPH = NgayPH, @MaSach = MaSach
	FROM INSERTED

	SELECT @MaTG = TACGIA.MaTG, @NS = NgSinh
	FROM TACGIA JOIN TACGIA_SACH
	ON TACGIA.MaTG = TACGIA_SACH.MaTG
	WHERE MaSach = @MaSach

	IF (@NPH < @NS)
	BEGIN
		PRINT N'Lỗi: Ngày phát hành sách nhỏ hơn ngày sinh của tác giả'
		ROLLBACK TRANSACTION
	END
END
GO

CREATE TRIGGER trg_tl_nsx ON SACH
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaSach char(5), @TheLoai varchar(25), @NXB varchar(20)
	SELECT @MaSach = MaSach, @TheLoai = TheLoai
	FROM INSERTED

	SELECT @NXB = NhaXuatBan 
	FROM PHATHANH

	IF (@TheLoai = 'Giao khoa' AND @NXB <> 'Giao duc')
	BEGIN
		PRINT N'Sách thuộc thể loại "Giáo khoa" chỉ có thể do nhà xuất bản "Giáo dục" phát hành'
		ROLLBACK TRANSACTION
	END
END
GO

SELECT TACGIA.MaTG, HoTen, SoDT
FROM TACGIA 
JOIN TACGIA_SACH ON TACGIA.MaTG = TACGIA_SACH.MaTG
JOIN SACH ON SACH.MaSach = TACGIA_SACH.MaSach
JOIN PHATHANH ON SACH.MaSach = PHATHANH.MaSach
WHERE TheLoai = 'Van hoc' AND NhaXuatBan = 'Tre'
GO

SELECT TOP 1 NhaXuatBan
FROM PHATHANH RIGHT JOIN SACH
ON PHATHANH.MaSach = SACH.MaSach
GROUP BY NhaXuatBan
ORDER BY COUNT(TheLoai) DESC
GO

WITH TGrankedbyNXB AS (
	SELECT MaTG, NhaXuatBan,
		ROW_NUMBER() OVER (PARTITION BY NhaXuatBan ORDER BY COUNT(MaTG) DESC) AS Rank
	FROM PHATHANH JOIN TACGIA_SACH
	ON PHATHANH.MaSach = TACGIA_SACH.MaSach
)
SELECT NhaXuatBan, HoTen
FROM TGrankedbyNXB JOIN TACGIA
ON TGrankedbyNXB.MaTG = TACGIA.MaTG
WHERE Rank = 1
GO
