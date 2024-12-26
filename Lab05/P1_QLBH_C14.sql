-- BAI TAP 1 - PHAN I CAU 14 QUANLYBANHANG
CREATE TRIGGER trg_doso_ttg on HOADON
FOR INSERT
AS
BEGIN
	DECLARE @DoanhSo money, @MaKH char(4), @TriGia money
	SELECT @MaKH = MAKH, @TriGia = TRIGIA
	FROM INSERTED
	SET @DoanhSo = @TriGia

	DECLARE cur_hoadon CURSOR
	FOR 
		SELECT TRIGIA 
		FROM HOADON
		WHERE MAKH = @MaKH

	OPEN cur_hoadon
	FETCH NEXT FROM cur_hoadon
	INTO @TriGia

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @DoanhSo = @DoanhSo + @TriGia
		FETCH NEXT FROM cur_hoadon
		INTO @TriGia
	END

	CLOSE cur_hoadon
	DEALLOCATE cur_hoadon
	
	UPDATE KHACHHANG SET DOANHSO = @DoanhSo WHERE MAKH = @MaKH
END
