--BAI TAP 2

USE QuanLyGiaoVu

-- KHOA
INSERT INTO KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA)
VALUES
('KHMT', 'Khoa hoc may tinh', '2005-06-07', 'GV01'),
('HTTT', 'He thong thong tin', '2005-06-07', 'GV02'),
('CNPM', 'Cong nghe phan mem', '2005-06-07', 'GV04'),
('MTT', 'Mang va truyen thong', '2005-10-20', 'GV03'),
('KTMT', 'Ky thuat may tinh','2005-12-20', NULL);

-- GIAOVIEN
INSERT INTO GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGLV, HESO, MUCLUONG, MAKHOA)
VALUES
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '1950-02-05', '2004-11-01', 5, 2250000, 'KHMT'), 
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '1965-12-17', '2004-04-20', 4.5, 2025000, 'HTTT'), 
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '1950-08-01', '2004-09-23', 4, 1800000, 'CNPM'), 
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '1961-02-22', '2005-12-01', 4.5, 2025000, 'KTMT'), 
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '1958-12-03', '2005-12-01', 3, 1350000, 'HTTT'), 
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '1953-11-03', '2005-12-01', 4.5, 2025000, 'KHMT'), 
('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '1971-11-23', '2005-01-03', 4, 1800000, 'KHMT'), 
('GV08', 'Le Thi Tran', 'KS', NULL, 'Nu', '1974-03-26', '2005-01-03', 1.69, 760500, 'KHMT'), 
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '1966-12-31', '2005-01-03', 4, 1800000, 'HTTT'), 
('GV10', 'Le Tran Anh Loan', 'KS', NULL, 'Nu', '1972-07-17', '2005-01-03', 1.86, 837000, 'CNPM'), 
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '1980-12-01', '2005-05-15', 2.67, 1201500, 'MTT'), 
('GV12', 'Tran Van Anh', 'CN', NULL, 'Nu', '1981-03-29', '2005-05-15', 1.69, 760500, 'CNPM'), 
('GV13', 'Nguyen Linh Dan', 'CN', NULL, 'Nu', '1980-05-23', '2005-05-15', 1.69, 760500, 'KTMT'), 
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '1976-11-30', '2005-05-15', 3, 1350000, 'MTT'), 
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '1978-04-05', '2005-05-15', 3, 1350000, 'KHMT');

-- LOP
INSERT INTO LOP (MALOP, TENLOP, TRGLOP, SISO, MAGVCN)
VALUES
('K11', 'Lop 1 khoa 1', 'K1108', 11, 'GV07'), 
('K12', 'Lop 2 khoa 1', 'K1205', 12, 'GV09'), 
('K13', 'Lop 3 khoa 1', 'K1305', 12, 'GV14');

-- MONHOC
INSERT INTO MONHOC(MAMH, TENMH, TCLT, TCTH, MAKHOA)
VALUES
('THDC', 'Tin hoc dai cuong', 4, 1, 'KHMT'), 
('CTRR', 'Cau truc roi rac', 5, 0, 'KHMT'), 
('CSDL', 'Co so du lieu', 3, 1, 'HTTT'), 
('CTDLGT', 'Cau truc du lieu va giai thuat', 3, 1, 'KHMT'), 
('PTTKTT', 'Phan tich thiet ke thuat toan', 3, 0, 'KHMT'), 
('DHMT', 'Do hoa may tinh', 3, 1, 'KHMT'), 
('KTMT', 'Kien truc may tinh', 3, 0, 'KTMT'), 
('TKCSDL', 'Thiet ke co so du lieu', 3, 1, 'HTTT'), 
('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', 4, 1, 'HTTT'), 
('HDH', 'He dieu hanh', 4, 0, 'KTMT'), 
('NMCNPM', 'Nhap mon cong nghe phan mem', 3, 0, 'CNPM'), 
('LTCFW', 'Lap trinh C for win', 3, 1, 'CNPM'), 
('LTHDT', 'Lap trinh huong doi tuong', 3, 1, 'CNPM');

-- DIEUKIEN
INSERT INTO DIEUKIEN (MAMH, MAMH_TRUOC)
VALUES
('CSDL', 'CTRR'), 
('CSDL', 'CTDLGT'), 
('CTDLGT', 'THDC'), 
('PTTKTT', 'THDC'), 
('PTTKTT', 'CTDLGT'), 
('DHMT', 'THDC'), 
('LTHDT', 'THDC'), 
('PTTKHTTT', 'CSDL');

-- GIANGDAY
INSERT INTO GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY)
VALUES
('K11', 'THDC', 'GV07', 1, 2006, '2006-02-01', '2006-12-05'), 
('K12', 'THDC', 'GV06', 1, 2006, '2006-02-01', '2006-12-05'), 
('K13', 'THDC', 'GV15', 1, 2006, '2006-02-01', '2006-12-05'), 
('K11', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'), 
('K12', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'), 
('K13', 'CTRR', 'GV08', 1, 2006, '2006-01-09', '2006-05-17'), 
('K11', 'CSDL', 'GV05', 2, 2006, '2006-01-06', '2006-05-17'), 
('K12', 'CSDL', 'GV09', 2, 2006, '2006-01-06', '2006-05-17'), 
('K13', 'CTDLGT', 'GV15', 2, 2006, '2006-01-06', '2006-05-17'), 
('K13', 'CSDL', 'GV05', 3, 2006, '2006-01-08', '2006-12-15'), 
('K13', 'DHMT', 'GV07', 3, 2006, '2006-01-08', '2006-12-15'), 
('K11', 'CTDLGT', 'GV15', 3, 2006, '2006-01-08', '2006-12-15'), 
('K12', 'CTDLGT', 'GV15', 3, 2006, '2006-01-08', '2006-12-15'), 
('K11', 'HDH', 'GV04', 1, 2007, '2007-02-01', '2007-02-18'), 
('K12', 'HDH', 'GV04', 1, 2007, '2007-01-01', '2007-03-20'), 
('K11', 'DHMT', 'GV07', 1, 2007, '2007-01-01', '2007-03-20');


-- HOCVIEN
INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES
('K1101', 'Nguyen Van', 'A', '1986-01-27', 'Nam', 'TpHCM', 'K11'), 
('K1102', 'Tran Ngoc', 'Han', '1986-03-14', 'Nu', 'Kien Giang', 'K11'), 
('K1103', 'Ha Duy', 'Lap', '1986-04-18', 'Nam', 'Nghe An', 'K11'), 
('K1104', 'Tran Ngoc', 'Linh', '1986-03-30', 'Nu', 'Tay Ninh', 'K11'), 
('K1105', 'Tran Minh', 'Long', '1986-02-27', 'Nam', 'TpHCM', 'K11'), 
('K1106', 'Le Nhat', 'Minh', '1986-01-24', 'Nam', 'TpHCM', 'K11'), 
('K1107', 'Nguyen Nhu', 'Nhut', '1986-01-27', 'Nam', 'Ha Noi', 'K11'), 
('K1108', 'Nguyen Manh', 'Tam', '1986-02-27', 'Nam', 'Kien Giang', 'K11'), 
('K1109', 'Phan Thi Thanh', 'Tam', '1986-01-27', 'Nu', 'Vinh Long', 'K11'), 
('K1110', 'Le Hoai', 'Thuong', '1986-05-02', 'Nu', 'Can Tho', 'K11'), 
('K1111', 'Le Ha', 'Vinh', '1986-12-25', 'Nam', 'Vinh Long', 'K11'), 
('K1201', 'Nguyen Van', 'B', '1986-11-02', 'Nam', 'TpHCM', 'K12'), 
('K1202', 'Nguyen Thi Kim', 'Duyen', '1986-01-18', 'Nu', 'TpHCM', 'K12'), 
('K1203', 'Tran Thi Kim', 'Duyen', '1986-09-17', 'Nu', 'TpHCM', 'K12'), 
('K1204', 'Truong My', 'Hanh', '1986-05-19', 'Nu', 'Dong Nai', 'K12'), 
('K1205', 'Nguyen Thanh', 'Nam', '1986-04-17', 'Nam', 'TpHCM', 'K12'), 
('K1206', 'Nguyen Thi Truc', 'Thanh', '1986-04-03', 'Nu', 'Kien Giang', 'K12'), 
('K1207', 'Tran Thi Bich', 'Thuy', '1986-08-02', 'Nu', 'Nghe An', 'K12'), 
('K1208', 'Huynh Thi Kim', 'Trieu', '1986-08-04', 'Nu', 'Tay Ninh', 'K12'), 
('K1209', 'Pham Thanh', 'Trieu', '1986-02-23', 'Nam', 'TpHCM', 'K12'), 
('K1210', 'Ngo Thanh', 'Tuan', '1986-02-14', 'Nam', 'TpHCM', 'K12'), 
('K1211', 'Do Thi', 'Xuan', '1986-09-03', 'Nu', 'Ha Noi', 'K12'), 
('K1212', 'Le Thi Phi', 'Yen', '1986-12-03', 'Nu', 'TpHCM', 'K12'), 
('K1301', 'Nguyen Thi Kim', 'Cuc', '1986-09-06', 'Nu', 'Kien Giang', 'K13'), 
('K1302', 'Truong Thi My', 'Hien', '1986-03-18', 'Nu', 'Nghe An', 'K13'), 
('K1303', 'Le Duc', 'Hien', '1986-03-21', 'Nam', 'Tay Ninh', 'K13'), 
('K1304', 'Le Quang', 'Hien', '1986-04-18', 'Nam', 'TpHCM', 'K13'), 
('K1305', 'Le Thi', 'Huong', '1986-03-27', 'Nu', 'TpHCM', 'K13'), 
('K1306', 'Nguyen Thai', 'Huu', '1986-03-30', 'Nam', 'Ha Noi', 'K13'), 
('K1307', 'Tran Minh', 'Man', '1986-05-28', 'Nam', 'TpHCM', 'K13'), 
('K1308', 'Nguyen Hieu', 'Nghia', '1986-08-04', 'Nam', 'Kien Giang', 'K13'), 
('K1309', 'Nguyen Trung', 'Nghia', '1987-01-18', 'Nam', 'Nghe An', 'K13'), 
('K1310', 'Tran Thi Hong', 'Tham', '1986-04-22', 'Nu', 'Tay Ninh', 'K13'), 
('K1311', 'Tran Minh', 'Thuc', '1986-04-04', 'Nam', 'TpHCM', 'K13'), 
('K1312', 'Nguyen Thi Kim', 'Yen', '1986-07-09', 'Nu', 'TpHCM', 'K13');

-- KETQUATHI
INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA)
VALUES
('K1101', 'CSDL', 1, '2006-07-20', 10), 
('K1101', 'CTDLGT', 1, '2006-12-28', 9), 
('K1101', 'THDC', 1, '2006-05-20', 9), 
('K1101', 'CTRR', 1, '2006-05-13', 9.5), 
('K1102', 'CSDL', 1, '2006-07-20', 4), 
('K1102', 'CSDL', 2, '2006-07-27', 4.25), 
('K1102', 'CSDL', 3, '2006-10-08', 4.5), 
('K1102', 'CTDLGT', 1, '2006-12-28', 4.5), 
('K1102', 'CTDLGT', 2, '2007-05-01', 4), 
('K1102', 'CTDLGT', 3, '2007-01-15', 6), 
('K1102', 'THDC', 1, '2006-05-20', 5), 
('K1102', 'CTRR', 1, '2006-05-13', 7), 
('K1103', 'CSDL', 1, '2006-07-20', 3.5), 
('K1103', 'CSDL', 2, '2006-07-27', 8.25), 
('K1103', 'CTDLGT', 1, '2006-12-28', 7), 
('K1103', 'THDC', 1, '2006-05-20', 8), 
('K1103', 'CTRR', 1, '2006-05-13', 6.5), 
('K1104', 'CSDL', 1, '2006-07-20', 3.75), 
('K1104', 'CTDLGT', 1, '2006-12-28', 4), 
('K1104', 'THDC', 1, '2006-05-20', 4), 
('K1104', 'CTRR', 1, '2006-05-13', 4), 
('K1104', 'CTRR', 2, '2006-05-20', 3.5), 
('K1104', 'CTRR', 3, '2006-06-30', 4), 
('K1201', 'CSDL', 1, '2006-07-20', 6), 
('K1201', 'CTDLGT', 1, '2006-12-28', 5), 
('K1201', 'THDC', 1, '2006-05-20', 8.5), 
('K1201', 'CTRR', 1, '2006-05-13', 9), 
('K1202', 'CSDL', 1, '2006-07-20', 8), 
('K1202', 'CTDLGT', 1, '2006-12-28', 4), 
('K1202', 'CTDLGT', 2, '2007-05-01', 5), 
('K1202', 'THDC', 1, '2006-05-20', 4), 
('K1202', 'THDC', 2, '2006-05-27', 4), 
('K1202', 'CTRR', 1, '2006-05-13', 3), 
('K1202', 'CTRR', 2, '2006-05-20', 4), 
('K1202', 'CTRR', 3, '2006-06-30', 6.25), 
('K1203', 'CSDL', 1, '2006-07-20', 9.25), 
('K1203', 'CTDLGT', 1, '2006-12-28', 9.5), 
('K1203', 'THDC', 1, '2006-05-20', 10), 
('K1203', 'CTRR', 1, '2006-05-13', 10), 
('K1204', 'CSDL', 1, '2006-07-20', 8.5), 
('K1204', 'CTDLGT', 1, '2006-12-28', 6.75), 
('K1204', 'THDC', 1, '2006-05-20', 4), 
('K1204', 'CTRR', 1, '2006-05-13', 6), 
('K1301', 'CSDL', 1, '2006-12-20', 4.25), 
('K1301', 'CTDLGT', 1, '2006-07-25', 8), 
('K1301', 'THDC', 1, '2006-05-20', 7.75), 
('K1301', 'CTRR', 1, '2006-05-13', 8), 
('K1302', 'CSDL', 1, '2006-12-20', 6.75), 
('K1302', 'CTDLGT', 1, '2006-07-25', 5), 
('K1302', 'THDC', 1, '2006-05-20', 8), 
('K1302', 'CTRR', 1, '2006-05-13', 8.5), 
('K1303', 'CSDL', 1, '2006-12-20', 4), 
('K1303', 'CTDLGT', 1, '2006-07-25', 4.5), 
('K1303', 'CTDLGT', 2, '2006-07-08', 4), 
('K1303', 'CTDLGT', 3, '2006-08-15', 4.25), 
('K1303', 'THDC', 1, '2006-05-20', 4.5), 
('K1303', 'CTRR', 1, '2006-05-13', 3.25), 
('K1303', 'CTRR', 2, '2006-05-20', 5), 
('K1304', 'CSDL', 1, '2006-12-20', 7.75), 
('K1304', 'CTDLGT', 1, '2006-07-25', 9.75), 
('K1304', 'THDC', 1, '2006-05-20', 5.5), 
('K1304', 'CTRR', 1, '2006-05-13', 5), 
('K1305', 'CSDL', 1, '2006-12-20', 9.25), 
('K1305', 'CTDLGT', 1, '2006-07-25', 10), 
('K1305', 'THDC', 1, '2006-05-20', 8),
('K1305', 'CTRR', 1, '2006-05-13', 10);



--BAI TAP 4
--PHAN I CAU 11 DEN 14
--CAU 11
ALTER TABLE HOCVIEN ADD CONSTRAINT CHK_HV_NGS
CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

--CAU 12 
ALTER TABLE GIANGDAY ADD CONSTRAINT CHK_TN_DN
CHECK (DENNGAY > TUNGAY)

--CAU 13 
ALTER TABLE GIAOVIEN ADD CONSTRAINT CHK_GV_NGS
CHECK (YEAR(NGLV) - YEAR(NGSINH) >= 18)

--CAU 14
ALTER TABLE MONHOC ADD CONSTRAINT CHK_TC
CHECK (ABS(TCLT - TCTH) <= 3)



--BAI TAP 6
--PHAN III CAU 1 DEN CAU 5
--CAU 1
SELECT MAHV, HO, TEN, NGSINH, LOP.MALOP
FROM LOP JOIN HOCVIEN
ON LOP.TRGLOP = HOCVIEN.MAHV

--CAU 2
SELECT KETQUATHI.MAHV, HO, TEN, LANTHI, DIEM
FROM KETQUATHI JOIN HOCVIEN
ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MAMH = 'CTRR' AND MALOP = 'K12'
ORDER BY TEN, HO

--CAU 3
SELECT KETQUATHI.MAHV, HO, TEN, KETQUATHI.MAMH, TENMH
FROM KETQUATHI JOIN HOCVIEN
ON KETQUATHI.MAHV = HOCVIEN.MAHV
JOIN MONHOC 
ON KETQUATHI.MAMH = MONHOC.MAMH
WHERE KQUA = 'Dat' AND LANTHI = 1

--CAU 4
SELECT KETQUATHI.MAHV, HO, TEN
FROM KETQUATHI JOIN HOCVIEN
ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MALOP = 'K11' AND MAMH = 'CTRR' AND KQUA = 'Khong Dat' AND LANTHI = 1

--CAU 5
SELECT KETQUATHI.MAHV, HO, TEN
FROM KETQUATHI JOIN HOCVIEN
ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MAMH = 'CTRR' AND KQUA = 'Khong Dat'