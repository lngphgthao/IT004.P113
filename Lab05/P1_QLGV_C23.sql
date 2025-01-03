-- BAI TAP 2 PHAN I CAU 23 QUANLYGIAOVU

CREATE TRIGGER tg_giangday_dieukien
ON GIANGDAY 
AFTER INSERT, UPDATE 
AS 
BEGIN 
	DECLARE @MALOP CHAR(3)
	DECLARE @MAMH VARCHAR(10)

	SELECT @MALOP = MALOP, @MAMH = MAMH FROM INSERTED 
	IF(@MAMH IN (SELECT MAMH FROM GIANGDAY 
				WHERE MALOP = @MALOP ))
		BEGIN
			RAISERROR('Lop hoc chua hoc xong mon hoc tien quet', 16, 1);
			ROLLBACK TRANSACTION;
		END
	ELSE 
		PRINT('Them moi giang day thanh cong')
END