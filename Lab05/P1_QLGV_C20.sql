-- BAI TAP 2 PHAN I CAU 20 QUANLYGIAOVU
CREATE TRIGGER tg_check_thilai
ON KETQUATHI
AFTER INSERT, UPDATE 
AS 
BEGIN 
	DECLARE @MAHV CHAR(5)

	DECLARE @PREV_DIEM NUMERIC(4, 2)

	SELECT @MAHV =  MAHV FROM INSERTED
	SELECT @PREV_DIEM = DIEM FROM KETQUATHI 
	WHERE MAHV = @MAHV
	
	IF(@PREV_DIEM < 5)
		PRINT('Them moi ket qua thi thanh cong')
	ELSE 
		BEGIN 
			RAISERROR('Diem truoc do cua hoc vien tren 5', 16, 1);
			ROLLBACK TRANSACTION;
		END
END