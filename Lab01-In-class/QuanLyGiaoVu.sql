--CAU 1--
CREATE DATABASE QuanLyGiaoVu

CREATE TABLE KHOA (
	MAKHOA VARCHAR(4) PRIMARY KEY,
	TENKHOA VARCHAR(40),
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4),
);

CREATE TABLE MONHOC (
	MAMH VARCHAR(10) PRIMARY KEY,
	TENMH VARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4),
);

CREATE TABLE DIEUKIEN (
	MAMH VARCHAR(10),
	MAMH_TRUOC VARCHAR(10),
	CONSTRAINT PK_DK PRIMARY KEY(MAMH, MAMH_TRUOC),
);

CREATE TABLE GIAOVIEN (
	MAGV CHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(40),
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GIOITINH VARCHAR(3),
	NGSINH SMALLDATETIME,
	NGLV SMALLDATETIME,
	HESO NUMERIC(4,2),
	MUCLUONG MONEY, 
	MAKHOA VARCHAR(4),
);

CREATE TABLE LOP (
	MALOP CHAR(3) PRIMARY KEY,
	TENLOP VARCHAR(40),
	TRGLOP CHAR(5),
	SISO TINYINT, 
	MAGVCN CHAR(4),
);

CREATE TABLE HOCVIEN (
	MAHV CHAR(5) PRIMARY KEY,
	HO VARCHAR(40), 
	TEN VARCHAR (10),
	NGSINH SMALLDATETIME,
	GIOITINH VARCHAR(3),
	NOISINH VARCHAR(40),
	MALOP CHAR(3),
);

CREATE TABLE GIANGDAY (
	MALOP CHAR(3),
	MAMH VARCHAR(10),
	MAGV CHAR(4),
	HOCKY TINYINT, 
	NAM SMALLINT, 
	TUNGAY SMALLDATETIME, 
	DENNGAY SMALLDATETIME,
	CONSTRAINT PK_GD PRIMARY KEY(MALOP, MAMH)
);

CREATE TABLE KETQUATHI (
	MAHV CHAR(5),
	MAMH VARCHAR(10),
	LANTHI TINYINT, 
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4,2),
	KQUA VARCHAR(10),
	CONSTRAINT PK_KQT PRIMARY KEY(MAHV, MAMH, LANTHI)
);

ALTER TABLE LOP ADD 
CONSTRAINT FK_LOP_HV FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV),
CONSTRAINT FK_LOP_GV FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE KHOA ADD CONSTRAINT FK_KH_GV FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE DIEUKIEN ADD
CONSTRAINT FK_DK_MH_1 FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
CONSTRAINT FK_DK_MH_2 FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)

ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_GV_KH FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE GIANGDAY ADD
CONSTRAINT FK_GD_LP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
CONSTRAINT FK_GD_MH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
CONSTRAINT FK_GD_GV FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE KETQUATHI ADD
CONSTRAINT FK_KQT_HV FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
CONSTRAINT FK_KQT_MH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(100), DIEMTB NUMERIC(4,2), XEPLOAI VARCHAR(10)

--CAU 3--
ALTER TABLE HOCVIEN ADD CHECK ((GIOITINH='Nam') OR (GIOITINH='Nu'))
ALTER TABLE GIAOVIEN ADD CHECK ((GIOITINH='Nam') OR (GIOITINH='Nu'))

--CAU 4--
ALTER TABLE KETQUATHI ADD CHECK (DIEM>=0 AND DIEM<=10)

--CAU 5--
ALTER TABLE KETQUATHI
ADD KQUA AS (CASE WHEN DIEM>=5 THEN 'Dat' ELSE 'Khong dat' END)

--CAU 6--
ALTER TABLE KETQUATHI ADD CHECK (LANTHI >=1 AND LANTHI<=3)

--CAU 7--
ALTER TABLE GIANGDAY ADD CHECK (HOCKI>=1 AND HOCKI<=3)

--CAU 8--
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_HV
CHECK ((HOCVI='CN') OR (HOCVI='KS') OR (HOCVI='Ths') OR (HOCVI='TS') OR (HOCVI='PTS'))