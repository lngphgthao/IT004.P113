-- BAI TAP 1 - PHAN I CAU 12 QUANLYBANHANG

CREATE TRIGGER trg_nghd_ngvl ON HOADON
FOR INSERT
AS
BEGIN
	DECLARE @NgayHD smalldatetime, @NgayVL smalldatetime, @MaNV char(4)
	SELECT @NgayHD = NGHD, @MaNV = MANV
	FROM INSERTED 
	SELECT @NgayVL = NGVL
	FROM NHANVIEN
	WHERE @MaNV = MANV
	IF (@NgayHD < @NgayVL) 
	BEGIN 
		PRINT 'LOI: NGAY HOA DON KHONG HOP LE!'
	END
	ELSE
	BEGIN 
		PRINT 'THEM MOI MOT HOA DON THANH CONG!'
	END
END