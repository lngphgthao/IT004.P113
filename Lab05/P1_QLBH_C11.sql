-- BAI TAP 1 - PHAN I CAU 11 QUANLYBANHANG
CREATE TRIGGER trg_ngdk_ngkt ON HOADON
FOR INSERT
AS
BEGIN 
	DECLARE @NgayHD smalldatetime, @NgayDK smalldatetime, @MaKH char(4)
	SELECT @NgayHD = NGHD, @MaKH = MAKH
	FROM INSERTED
	SELECT @NgayDK = NGDK
	FROM KHACHHANG
	WHERE MAKH = @MaKH
	IF (@NgayHD < @NgayDK)
	BEGIN
		PRINT 'LOI: NGAY HOA DON KHONG HOP LE!'
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN 
		PRINT 'THEM MOI MOT HOA DON THANH CONG!'
	END
END