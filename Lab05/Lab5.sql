-- Câu hỏi và ví dụ về Triggers (101-110)
USE it_cs_database

-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia mỗi khi có sự thay đổi thông tin.
ALTER TABLE ChuyenGia
ADD NgayCapNhat SMALLDATETIME NULL;

CREATE TRIGGER trg_udt_ncn ON ChuyenGia
FOR UPDATE
AS
BEGIN 
	DECLARE @MaChuyenGia INT
	SELECT @MaChuyenGia = MaChuyenGia
	FROM INSERTED
	
	UPDATE ChuyenGia
	SET NgayCapNhat = GETDATE()
	WHERE @MaChuyenGia = MaChuyenGia
END

-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.
CREATE TRIGGER trg_log_duan ON DuAn
FOR UPDATE, INSERT, DELETE
AS 
BEGIN
	PRINT 'Bang DuAn da duoc chinh sua'
END

-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER trg_chg_duan ON ChuyenGia_DuAn
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @MaChuyenGia int, @MaDuAn int, @SoLgDuAn int
	SELECT @MaChuyenGia = MaChuyenGia
	FROM INSERTED

	SET @SoLgDuAn = 0

	DECLARE	cur_chg_duan CURSOR
	FOR
		SELECT MaDuAn
		FROM ChuyenGia_DuAn
		WHERE @MaChuyenGia = MaChuyenGia
	OPEN cur_chg_duan 
	FETCH NEXT FROM cur_chg_duan
	INTO @MaDuAn

	WHILE (@@FETCH_STATUS = 0)
	BEGIN 
		SET @SoLgDuAn = @SoLgDuAn + 1
		FETCH NEXT FROM cur_chg_duan
		INTO @MaDuAn
	END

	CLOSE cur_chg_duan
	DEALLOCATE cur_chg_duan

	IF (@SoLgDuAn > 5)
	BEGIN
		PRINT 'Loi: Khong the thuc hien - Chuyen gia khong the tham gia qua 5 du an'
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN 
		PRINT 'Bang da duoc cap nhat thanh cong'
	END
END

-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TRIGGER trg_slgnv_cty ON ChuyenGia
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @MaCongTy int, @MaChuyenGia int, @SoLgNhanVien int
	SELECT @MaChuyenGia = MaChuyenGia
	FROM INSERTED

	SELECT @MaCongTy = MaCongTy, @SoLgNhanVien = SoNhanVien
	FROM CongTy

	UPDATE CongTy
	SET SoNhanVien = @SoLgNhanVien
	WHERE @MaCongTy = MaCongTy
END

-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
CREATE TRIGGER trg_duan_ht ON DuAn
FOR DELETE
AS
BEGIN
	DECLARE @MaDuAn int, @TrangThai NVARCHAR(50)
	SELECT @MaDuAn = MaDuAn, @TrangThai = TrangThai
	FROM DELETED

	IF (@TrangThai = N'Hoàn thành')
	BEGIN
		PRINT N'Lỗi: Không thể xóa dự án đã hoàn thành'
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT N'Xóa dự án thành công'
	END
END

-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
CREATE TRIGGER trg_kn_chg ON ChuyenGia_DuAn
FOR INSERT
AS 
BEGIN
	DECLARE @MaChuyenGia int, @CapDo int
	SELECT @MaChuyenGia = MaChuyenGia
	FROM INSERTED
	
	UPDATE ChuyenGia_KyNang
	SET CapDo = @CapDo + 1
	WHERE MaChuyenGia = @MaChuyenGia
END

-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
CREATE TRIGGER trg_log_kn ON ChuyenGia_KyNang
FOR UPDATE
AS
BEGIN
	PRINT N'Log: Cấp độ kỹ năng của một chuyên gia đã được thay đổi'
END

-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
CREATE TRIGGER trg_nbd_nkt ON DuAn
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaDuAn int, @NBD smalldatetime, @NKT smalldatetime
	SELECT @MaDuAn = MaDuAn, @NBD = NgayBatDau, @NKT = NgayKetThuc
	FROM INSERTED

	IF (@NBD > @NKT)
	BEGIN
		PRINT N'Lỗi: Ngày bắt đầu không thể lớn hơn ngày kết thúc'
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN 
		PRINT N'Thêm mới/Chỉnh sửa thành công'
	END
END

-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
CREATE TRIGGER trg_del_kn ON KyNang
FOR DELETE
AS
BEGIN
	DECLARE @MaKyNang int
	SELECT @MaKyNang = MaKyNang
	FROM DELETED

	DELETE FROM ChuyenGia_KyNang
	WHERE MaKyNang = @MaKyNang
END

-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
CREATE TRIGGER trg_cty_duan ON DuAn
FOR INSERT
AS 
BEGIN
	DECLARE @MaCongTy int, @MaDuAn int, @TrangThai NVARCHAR(50), @SoDuAn int
	SELECT @MaCongTy = MaCongTy, @TrangThai = TrangThai
	FROM INSERTED

	SET @SoDuAn = 0
	
	DECLARE cur_duan CURSOR
	FOR 
		SELECT MaDuAn, TrangThai
		FROM DuAn
		WHERE MaCongTy = @MaCongTy
	OPEN cur_duan
	FETCH NEXT FROM cur_duan
	INTO @MaDuAn, @TrangThai

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@TrangThai = N'Đang thực hiện')
		BEGIN
			SET @SoDuAn = @SoDuAn + 1
		END
		FETCH NEXT FROM cur_duan
		INTO @MaDuAn, @TrangThai
	END
	CLOSE cur_duan
	DEALLOCATE cur_duan

	IF (@SoDuAn > 10)
	BEGIN
		PRINT N'Lỗi: Công ty không thể nhận hơn 10 dự án đang thực hiện cùng một lúc'
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN
		PRINT N'Thêm mới dự án thành công'
	END
END

-- Câu hỏi và ví dụ về Triggers bổ sung (123-135)

-- 123. Tạo một trigger để tự động cập nhật lương của chuyên gia dựa trên cấp độ kỹ năng và số năm kinh nghiệm.
ALTER TABLE ChuyenGia
ADD Luong money

CREATE TRIGGER trg_lg_chg ON ChuyenGia
FOR UPDATE
AS
BEGIN
	DECLARE @MaChuyenGia int, @Luong money, @CapDo int, @NamKinhNghiem int
	SELECT @MaChuyenGia = MaChuyenGia, @NamKinhNghiem = NamKinhNghiem
	FROM INSERTED

	SET @Luong = 1000000 * @CapDo + 100000 * @NamKinhNghiem

	DECLARE cur_chg_kn CURSOR
	FOR 
		SELECT CapDo
		FROM ChuyenGia_KyNang
		WHERE MaChuyenGia = @MaChuyenGia
	OPEN cur_chg_kn
	FETCH NEXT FROM cur_chg_kn
	INTO @CapDo

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @Luong = @Luong + 1000000 * @CapDo 
		FETCH NEXT FROM cur_chg_kn
		INTO @CapDo
	END
	CLOSE cur_chg_kn
	DEALLOCATE cur_chg_kn
	UPDATE ChuyenGia 
	SET Luong = @Luong
	WHERE MaChuyenGia = @MaChuyenGia
END

-- 124. Tạo một trigger để tự động gửi thông báo khi một dự án sắp đến hạn (còn 7 ngày).
-- Tạo bảng ThongBao nếu chưa có
CREATE TABLE ThongBao (
	MaThongBao INT IDENTITY(1,1) PRIMARY KEY,
	NoiDung NVARCHAR(100),
	NgayGui SMALLDATETIME,
);

CREATE TRIGGER trg_tb_duan_due ON DuAn
FOR UPDATE
AS
BEGIN
	DECLARE @MaDuAn int, @NgKT smalldatetime
	SELECT @MaDuAn = MaDuAn, @NgKT = NgayKetThuc 
	FROM INSERTED
	INSERT INTO ThongBao (NoiDung, NgayGui)
	SELECT 
		CONCAT(N'Dự án ', TenDuAn, N' sắp đến hạn vào ngày ', FORMAT(@NgKT, 'dd-mm-yyyy')) AS NoiDung,
		GETDATE() AS NgayGui
	FROM DuAn
	WHERE DATEDIFF(DAY, GETDATE(), @NgKT) <= 7
END

-- 125. Tạo một trigger để ngăn chặn việc xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.
CREATE TRIGGER trg_chg_info ON ChuyenGia
FOR UPDATE, DELETE
AS
BEGIN 
	DECLARE @MaChuyenGia int, @MaDuAn int, @TrangThai NVARCHAR(50)
	SELECT @MaChuyenGia = MaChuyenGia
	FROM DELETED

	SELECT @MaDuAn = MaDuAn
	FROM ChuyenGia_DuAn
	WHERE MaChuyenGia = @MaChuyenGia

	SELECT @TrangThai = @TrangThai
	FROM DuAn
	WHERE MaDuAn = @MaDuAn

	IF (@TrangThai = N'Đang thực hiện')
	BEGIN 
		PRINT N'Lỗi: Không thể xóa hay cập nhật thông tin của chuyên gia đang tham gia dự án.'
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT N'Xóa/Cập nhật thông tin chuyên gia thành công'
	END
END

-- 126. Tạo một trigger để tự động cập nhật số lượng chuyên gia trong mỗi chuyên ngành.
-- Tạo bảng ThongKeChuyenNganh nếu chưa có
CREATE TABLE ThongKeChuyenNganh (
	MaChuyenNganh INT IDENTITY(1,1) PRIMARY KEY,
	TenChuyenNganh NVARCHAR(50),
	SoLuongChuyenGia INT
)

CREATE TRIGGER trg_slgchg ON ChuyenGia
FOR INSERT
AS
BEGIN
	DECLARE @SoLuong INT, @ChuyenNganh NVARCHAR(50)
	
	SET @SoLuong = COUNT(@ChuyenNganh)

	DECLARE cur_chg CURSOR
	FOR 
		SELECT ChuyenNganh
		FROM ChuyenGia
	
	OPEN cur_chg
	FETCH NEXT FROM cur_chg
	INTO @ChuyenNganh

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @SoLuong = COUNT(@ChuyenNganh) 
		IF (@SoLuong = 0)
		BEGIN 
			SET @SoLuong = 1
			INSERT INTO ThongKeChuyenNganh (TenChuyenNganh, SoLuongChuyenGia) VALUES (@ChuyenNganh, @SoLuong)
		END
		ELSE
		BEGIN
			UPDATE ThongKeChuyenNganh
			SET SoLuongChuyenGia = @SoLuong
			WHERE TenChuyenNganh = @ChuyenNganh
		END
		FETCH NEXT FROM cur_chg
		INTO @ChuyenNganh
	END
	CLOSE cur_chg
	DEALLOCATE cur_chg
END

-- 127. Tạo một trigger để tự động tạo bản sao lưu của dự án khi nó được đánh dấu là hoàn thành.
-- Tạo bảng DuAnHoanThanh nếu chưa có
CREATE TABLE DuAnHoanThanh (
	MaDuAn INT PRIMARY KEY,
	TenDuAn NVARCHAR(200),
	MaCongTy INT, 
	NgayBatDau SMALLDATETIME, 
	NgayKetThuc SMALLDATETIME,
)

CREATE TRIGGER trg_duan_cp ON DuAn
FOR UPDATE
AS
BEGIN
	DECLARE @MaDuAn INT, @TrangThaiCu NVARCHAR(50), @TrangThai NVARCHAR(50)
	
	SELECT @MaDuAn = MaDuAn, @TrangThaiCu = TrangThai
	FROM DELETED

	SELECT @TrangThai = TrangThai
	FROM INSERTED

	IF (@TrangThaiCu <> @TrangThai AND @TrangThai = N'Hoàn thành')
	BEGIN
		INSERT INTO DuAnHoanThanh (MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc)
		SELECT MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc
		FROM DuAn
		WHERE MaDuAn = @MaDuAn
		
		PRINT N'Đã tạo bản sao lưu của dự án mới hoàn thành'
	END
END

-- 128. Tạo một trigger để tự động cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
ALTER TABLE DuAn
ADD DiemDanhGia FLOAT

ALTER TABLE CongTy
ADD DiemDanhGia FLOAT

CREATE TRIGGER trg_dtb ON DuAn
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @MaCongTy INT, @SoLgDuAn INT, @TongDiem FLOAT, @DiemDanhGia FLOAT
	
	SET @TongDiem = @DiemDanhGia 

	DECLARE cur_duan CURSOR
	FOR 
		SELECT DiemDanhGia
		FROM DuAn
		WHERE MaCongTy = @MaCongTy

	OPEN cur_duan 
	FETCH NEXT FROM cur_duan
	INTO @DiemDanhGia

	WHILE (@@FETCH_STATUS = 0)
	BEGIN 
		SET @TongDiem = @TongDiem + @DiemDanhGia
		SET @SoLgDuAn = @SoLgDuAn + 1
		FETCH NEXT FROM cur_duan
		INTO @DiemDanhGia
	END
	CLOSE cur_duan
	DEALLOCATE cur_duan

	UPDATE CongTy
	SET DiemDanhGia = @TongDiem / @SoLgDuAn
	WHERE MaCongTy = @MaCongTy
END

-- 129. Tạo một trigger để tự động phân công chuyên gia vào dự án dựa trên kỹ năng và kinh nghiệm.
CREATE TRIGGER trg_kn_da ON DuAn
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @MaCongTy INT, @SoLgDuAn INT, @TongDiem FLOAT, @DiemDanhGia FLOAT
	
	SET @TongDiem = @DiemDanhGia 

	DECLARE cur_duan CURSOR
	FOR 
		SELECT DiemDanhGia
		FROM DuAn
		WHERE MaCongTy = @MaCongTy

	OPEN cur_duan 
	FETCH NEXT FROM cur_duan
	INTO @DiemDanhGia

	WHILE (@@FETCH_STATUS = 0)
	BEGIN 
		SET @TongDiem = @TongDiem + @DiemDanhGia
		SET @SoLgDuAn = @SoLgDuAn + 1
		FETCH NEXT FROM cur_duan
		INTO @DiemDanhGia
	END
	CLOSE cur_duan
	DEALLOCATE cur_duan

	UPDATE CongTy
	SET DiemDanhGia = @TongDiem / @SoLgDuAn
	WHERE MaCongTy = @MaCongTy
END

-- 130. Tạo một trigger để tự động cập nhật trạng thái "bận" của chuyên gia khi họ được phân công vào dự án mới.
ALTER TABLE ChuyenGia ADD TrangThai NVARCHAR(50)

CREATE TRIGGER trg_trgth_chg ON ChuyenGia_DuAn
FOR INSERT
AS 
BEGIN
	DECLARE @MaChuyenGia INT
	SELECT @MaChuyenGia = MaChuyenGia 
	FROM INSERTED

	UPDATE ChuyenGia 
	SET TrangThai = N'Bận'
	WHERE MaChuyenGia = @MaChuyenGia
END

-- 131. Tạo một trigger để ngăn chặn việc thêm kỹ năng trùng lặp cho một chuyên gia.
CREATE TRIGGER trg_kn_block ON ChuyenGia_KyNang
FOR INSERT
AS
BEGIN
	DECLARE @MaChuyenGia1 INT, @MaKyNang1 INT, @MaChuyenGia2 INT, @MaKyNang2 INT
	SELECT @MaChuyenGia1 = MaChuyenGia, @MaKyNang1 = MaKyNang
	FROM INSERTED

	DECLARE cur_chgkn CURSOR
	FOR 
		SELECT MaChuyenGia, MaKyNang
		FROM ChuyenGia_KyNang

	OPEN cur_chgkn
	FETCH NEXT FROM cur_chgkn
	INTO @MaChuyenGia2, @MaKyNang2

	WHILE (@@FETCH_STATUS = 0)
	BEGIN 
		IF (@MaKyNang1 = @MaKyNang2 AND @MaChuyenGia1 = @MaChuyenGia2)
		BEGIN
			PRINT N'Lỗi: Chuyên gia với kỹ năng này đã có trong bảng'
			ROLLBACK TRANSACTION
		END
	END

	PRINT N'Kỹ năng mới của chuyên gia được thêm vào thành công'
END

-- 132. Tạo một trigger để tự động tạo báo cáo tổng kết khi một dự án kết thúc.
CREATE TRIGGER trg_bctk_duan ON DuAn
FOR UPDATE
AS
BEGIN
	DECLARE @MaDuAn INT, @TenDuAn NVARCHAR(200), @NgKT SMALLDATETIME, @TrangThai NVARCHAR(50)
	SELECT @MaDuAn = MaDuAn, @TenDuAn = TenDuAn, @NgKT = NgayKetThuc, @TrangThai = TrangThai
	FROM INSERTED

	IF (@NgKT < GETDATE() OR @TrangThai = N'Hoàn thành')
	BEGIN
		PRINT CONCAT(N'Dự án ', @TenDuAn, N' đã kết thúc vào ngày ', GETDATE())
	END
END

-- 133. Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.
ALTER TABLE CongTy
ADD ThuHang NVARCHAR(10)

CREATE TRIGGER trg_rank ON DuAn
FOR UPDATE
AS
BEGIN
	DECLARE @MaCongTy INT, @SoLuongDuAn INT, @DiemDanhGia FLOAT
    
	SELECT @SoLuongDuAn = COUNT(MaDuAn)
	FROM INSERTED
	WHERE MaCongTy = @MaCongTy

	SELECT @DiemDanhGia = DiemDanhGia
	FROM CongTy
	WHERE MaCongTy = @MaCongTy

    -- Cập nhật thứ hạng dựa trên số dự án hoàn thành và điểm đánh giá
    UPDATE CongTy
    SET ThuHang = 
        CASE 
            WHEN @SoLuongDuAn >= 10 AND @DiemDanhGia >= 8 THEN N'Hạng A'
            WHEN @SoLuongDuAn >= 5 AND @DiemDanhGia >= 6 THEN N'Hạng B'
            ELSE N'Hạng C'
		END
END

-- 134. Tạo một trigger để tự động gửi thông báo khi một chuyên gia được thăng cấp (dựa trên số năm kinh nghiệm).
CREATE TRIGGER trg_tb_thangcap ON ChuyenGia
FOR UPDATE
AS
BEGIN
	DECLARE @MaChuyenGia INT, @SoNamKinhNghiem INT
	SELECT @MaChuyenGia = MaChuyenGia, @SoNamKinhNghiem = NamKinhNghiem
	FROM INSERTED

	IF (DAY(GETDATE()) = 1 AND MONTH(GETDATE()) = 1)
	BEGIN
		SET @SoNamKinhNghiem = @SoNamKinhNghiem + 1
		IF (@SoNamKinhNghiem >= 3)
		BEGIN	
			PRINT CONCAT(N'Chuyên gia ', @MaChuyenGia, N'đã được thăng cấp lên Junior.')
		END
		ELSE IF (@SoNamKinhNghiem >= 6)
		BEGIN	
			PRINT CONCAT(N'Chuyên gia ', @MaChuyenGia, N'đã được thăng cấp lên Senior.')
		END
	END

	UPDATE ChuyenGia 
	SET NamKinhNghiem = @SoNamKinhNghiem
	WHERE MaChuyenGia = @MaChuyenGia
END

-- 135. Tạo một trigger để tự động cập nhật trạng thái "khẩn cấp" cho dự án khi thời gian còn lại ít hơn 10% tổng thời gian dự án.
CREATE TRIGGER trg_cbkc ON DuAn
FOR UPDATE
AS
BEGIN
	DECLARE @MaDuAn INT, @NgBD SMALLDATETIME, @NgKT SMALLDATETIME, @TongThoiGian INT
	SELECT @MaDuAn = MaDuAn, @NgBD = NgayBatDau, @NgKT = NgayKetThuc
	FROM INSERTED
	
	SET @TongThoiGian = DATEDIFF(DAY, @NgBD, @NgKT)

	IF (DATEDIFF(DAY, GETDATE(), @NgKT) <= 0.1*@TongThoiGian)
	BEGIN
		UPDATE DuAn
		SET TrangThai = N'Khẩn cấp'
		WHERE MaDuAn = @MaDuAn
	END
END

-- 136. Tạo một trigger để tự động cập nhật số lượng dự án đang thực hiện của mỗi chuyên gia.
ALTER TABLE ChuyenGia
ADD SoLuongDuAn INT

CREATE TRIGGER trg_cn_duan ON ChuyenGia_DuAn
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @MaChuyenGia INT
	SELECT @MaChuyenGia = MaChuyenGia
	FROM INSERTED 

	IF (@MaChuyenGia = NULL)
	BEGIN
		SELECT @MaChuyenGia = MaChuyenGia
		FROM DELETED
	END

	UPDATE ChuyenGia
	SET SoLuongDuAn = (
		SELECT COUNT(MaDuAn)
		FROM ChuyenGia_DuAn 
		WHERE MaChuyenGia = @MaChuyenGia
	)
END

-- 137. Tạo một trigger để tự động tính toán và cập nhật tỷ lệ thành công của công ty dựa trên số dự án hoàn thành và tổng số dự án.
CREATE TRIGGER trg_tltc ON DuAn
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE CongTy
    SET TyLeThanhCong = 
        CASE 
            WHEN TotalProjects = 0 THEN 0
            ELSE CAST((CompletedProjects * 100.0) / TotalProjects AS DECIMAL(5, 2))
        END
    FROM CongTy
    CROSS APPLY (
        SELECT 
            COUNT(*) AS TotalProjects,
            SUM(CASE WHEN TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS CompletedProjects
        FROM DuAn
        WHERE DuAn.MaCongTy = CongTy.MaCongTy
    ) AS Stats;
END;

-- 138. Tạo một trigger để tự động ghi log mỗi khi có thay đổi trong bảng lương của chuyên gia.
CREATE TRIGGER trg_log_luong ON ChuyenGia
FOR UPDATE
AS
BEGIN
	DECLARE @LuongCu MONEY, @LuongMoi MONEY
	SELECT @LuongCu = Luong
	FROM DELETED

	SELECT @LuongMoi = Luong
	FROM INSERTED 

	IF (@LuongCu <> @LuongMoi)
	BEGIN
		PRINT N'Bảng lương đã được cập nhật'
	END
END

-- 139. Tạo một trigger để tự động cập nhật số lượng chuyên gia cấp cao trong mỗi công ty.
ALTER TABLE CongTy
ADD SoChuyenGiaCapCao INT

CREATE TRIGGER trg_slgchgcc ON ChuyenGia
FOR INSERT
AS
BEGIN
	DECLARE @SoLuong INT, @MaCongTy INT, @MaChuyenGia INT
	
	SELECT @MaChuyenGia = MaChuyenGia, @MaCongTy = MaCongTy
	FROM INSERTED

	SET @SoLuong = (
		SELECT COUNT(@MaChuyenGia)
		FROM ChuyenGia
		WHERE MaCongTy = @MaCongTy
	)

	UPDATE CongTy
	SET SoChuyenGiaCapCao = @SoLuong
	WHERE MaCongTy = @MaCongTy
END

-- 140. Tạo một trigger để tự động cập nhật trạng thái "cần bổ sung nhân lực" cho dự án khi số lượng chuyên gia tham gia ít hơn yêu cầu.
CREATE TRIGGER trg_cntrgthai ON ChuyenGia_DuAn
FOR INSERT, DELETE
AS
BEGIN
    UPDATE DuAn
    SET TrangThai = 
        CASE 
            WHEN (SELECT COUNT(*) 
                  FROM ChuyenGia_DuAn 
                  WHERE ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn) < DuAn.SoLuongChuyenGiaYeuCau
            THEN N'Cần bổ sung nhân lực'
            ELSE N'Đủ nhân lực'
        END
    WHERE DuAn.MaDuAn IN (
        SELECT DISTINCT MaDuAn FROM INSERTED
        UNION
        SELECT DISTINCT MaDuAn FROM DELETED
    );
END;