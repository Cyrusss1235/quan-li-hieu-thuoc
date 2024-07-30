
-- 8 CÂU TRUY VẤN
--1. Đưa ra thông tin chi tiết của hóa đơn HD006
SELECT MATHUOC,SOLUONG,SUM((GIABAN*SOLUONG)-MUCGIAMGIA*(GIABAN*SOLUONG)/100) 'TỔNG TIỀN'
FROM CHITIETHOADON 
WHERE SOHOADON = 'HD006'
GROUP BY MATHUOC,SOLUONG;
--2. Đưa ra danh sách thuốc và nhà cung cấp của thuốc
SELECT THUOC.TENTHUOC, NHACUNGCAP.TENCONGTY
FROM THUOC INNER JOIN NHACUNGCAP ON THUOC.MACONGTY = NHACUNGCAP.MACONGTY;
--3. Đưa ra danh sách các hóa đơn bán trong tháng 5 năm 2024
SELECT * FROM HOADONBAN
WHERE NGAYMUA LIKE '2024-05%';
--4 . Tính tổng số tiền của THUOC đã bán
SELECT CT.MATHUOC,TENTHUOC,SUM((GIABAN*CT.SOLUONG)-MUCGIAMGIA*(GIABAN*CT.SOLUONG)/100) 'TỔNG TIỀN'
FROM CHITIETHOADON CT INNER JOIN THUOC MT ON CT.MATHUOC=MT.MATHUOC
GROUP BY CT.MATHUOC, TENTHUOC;
--5. Đưa ra những khách hàng mua hàng với tổng tiền cao nhất.
SELECT TOP 1 WITH TIES KH.TENKHACHHANG,SUM((GIABAN*CT.SOLUONG)-MUCGIAMGIA*(GIABAN*CT.SOLUONG)/100) 'TỔNG TIỀN'
FROM KHACHHANG KH INNER JOIN HOADONBAN HD ON KH.MAKHACHHANG=HD.MAKHACHHANG INNER JOIN CHITIETHOADON CT ON HD.SOHOADON=CT.SOHOADON
GROUP BY KH.TENKHACHHANG
ORDER BY [TỔNG TIỀN] DESC;
--6 Đưa ra danh sách khách hàng có tổng số tiền mua hàng lớn hơn KH001
SELECT KH.MAKHACHHANG,TENKHACHHANG,SUM((CT.SOLUONG*GIABAN)-(CT.SOLUONG*GIABAN*MUCGIAMGIA/100)) 'TONG TIEN'
FROM KHACHHANG KH INNER JOIN HOADONBAN HD ON KH.MAKHACHHANG=HD.MAKHACHHANG INNER JOIN CHITIETHOADON CT ON HD.SOHOADON=CT.SOHOADON
GROUP BY KH.MAKHACHHANG,TENKHACHHANG
HAVING SUM((CT.SOLUONG*GIABAN)-(CT.SOLUONG*GIABAN*MUCGIAMGIA/100))>(SELECT SUM((CT.SOLUONG*GIABAN)-(CT.SOLUONG*GIABAN*MUCGIAMGIA/100)) 'TONG TIEN'
FROM HOADONBAN HD INNER JOIN CHITIETHOADON CT ON HD.SOHOADON=CT.SOHOADON
WHERE HD.MAKHACHHANG='KH001')
--7 Đưa ra danh sách thuốc chưa từng được bán
SELECT *
FROM THUOC 
WHERE MATHUOC NOT IN (SELECT MATHUOC FROM CHITIETHOADON GROUP BY MATHUOC)
--8 Đưa ra nhà cung cấp cung cấp lượng mã thuốc lớn hơn 5
SELECT NCC.MACONGTY,NCC.TENCONGTY,COUNT(THUOC.MATHUOC) 'SO MA THUOC'
FROM NHACUNGCAP NCC INNER JOIN THUOC ON NCC.MACONGTY=THUOC.MACONGTY
GROUP BY NCC.MACONGTY,NCC.TENCONGTY
HAVING COUNT(THUOC.MATHUOC)>5
--9 Đưa ra thuốc có hạn sử dụng lớn hơn 3 tháng tính từ ngày hiện tại


-------------------------------------------------------------------------------

--5 CÂU THỦ TỤC
--1 Thủ tục tính tổng số lượng của 2 thuốc bất kì
create procedure sl2mathang(@mh1 nvarchar(20),@mh2 nvarchar(20))
as
	declare @sl1 int
	declare @sl2 int
	declare @tongsl int
	if  not exists (select mathuoc from THUOC where MATHUOC=@mh1)
	print N'Mã thuốc '+@mh1+ N' không tồn tại'
	else if  not exists (select mathuoc from THUOC where MATHUOC=@mh2)
	print N'Mã thuốc '+@mh2+ N' không tồn tại'
	else begin
	select @sl1=soluong from THUOC where mathuoc=@mh1
	select @sl2=soluong from THUOC where mathuoc=@mh2 
	select @tongsl=@sl1+@sl2
	print 'Tong so luong 2 mat hang='+ str(@tongsl)
	end
	select* from thuoc
	sl2mathang T001,T00200
--2 thủ tục đưa ra tổng số lượng 2 nhóm thuốc bất kì
create procedure sl2nhomthuoc(@mh1 nvarchar(20),@mh2 nvarchar(20))
as
	declare @sl1 int
	declare @sl2 int
	declare @tongsl int
	if  not exists (select MANHOMTHUOC from THUOC where MANHOMTHUOC=@mh1)
	print N'Nhóm thuốc '+@mh1+N' không tồn tại'
	else if  not exists (select MANHOMTHUOC from THUOC where MANHOMTHUOC=@mh2)
	print N'Nhóm thuốc '+@mh2+N' không tồn tại'
	else begin
	select @sl1=sum(soluong) from THUOC,NHOMTHUOC where thuoc.MANHOMTHUOC=@mh1 and thuoc.MANHOMTHUOC=NHOMTHUOC.MANHOMTHUOC 
	select @sl2=sum(soluong) from THUOC,NHOMTHUOC where thuoc.MANHOMTHUOC=@mh2 and thuoc.MANHOMTHUOC=NHOMTHUOC.MANHOMTHUOC 
	select @tongsl=@sl1+@sl2
	print 'Tong so luong 2 mat hang='+ str(@tongsl)
	end
--3 thủ tục đưa ra \những mã thuốc có hạn sử dụng nhỏ hơn 3 tháng kể từ ngày bất kì
CREATE PROCEDURE LayThuocHanSuDungDuoi3Thang(@ngay Date)
as
BEGIN
    
    DECLARE @NgaySau3Thang DATE;
    select @NgaySau3Thang = DATEADD(MONTH, +3, @Ngay);

    SELECT *
    FROM 
        THUOC
    WHERE 
        HSD <= @NgaySau3Thang
		and
		HSD > @Ngay
END;
LayThuocHanSuDungDuoi3Thang '2025-05-20'
--4 thủ tục đưa ra thông tin cảu một khách hàng bất kì
create proc thongtinkh (@kh nvarchar(20))
as
begin
if  not exists (select makhachhang from KHACHHANG where MAKHACHHANG=@kh)
	print N'Khách hàng không tồn tại'
else 
Select * From KHACHHANG where MAKHACHHANG=@kh
end
--5 thủ tục so sánh số lượng cảu 2 mã thuốc bất kì
create procedure sosanhsoluong(@mh1 nvarchar(20),@mh2 nvarchar(20))
as
	declare @sl1 int
	declare @sl2 int
	declare @tongsl int
	
	if  not exists (select mathuoc from THUOC where MATHUOC=@mh1)
	print N'Mã thuốc '+@mh1+N' không tồn tại'
	else if  not exists (select mathuoc from THUOC where MATHUOC=@mh2)
	print N'Mã thuốc '+@mh2+N' không tồn tại'
	else begin
	select @sl1=soluong from THUOC where mathuoc=@mh1
	select @sl2=soluong from THUOC where mathuoc=@mh2 
	if(@sl1>@sl2)
	print N'Mã thuốc'+@mh1+N'có số lượng nhiều hơn!'
	else
	print N'Mã thuốc'+@mh2+N'có số lượng nhiều hơn!'
	end
-------------------------------------------------------------------------------

-- 5 CÂU TRIGGER
--1 hạn sử dụng phải lớn hơn ngày sản xuất khi thêm dữ liệu
CREATE TRIGGER trg_CHECK_HSD
ON THUOC
For INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED WHERE HSD <= NSX)
    BEGIN
        print N'Hạn sử dụng (HSD) phải lớn hơn ngày sản xuất (NSX).';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO THUOC (MATHUOC, TENTHUOC, MACONGTY, MANHOMTHUOC, NSX, HSD, SOLUONG, DONVITINH, GIATHUOC)
        SELECT MATHUOC, TENTHUOC, MACONGTY, MANHOMTHUOC, NSX, HSD, SOLUONG, DONVITINH, GIATHUOC
        FROM INSERTED;
    END
END;
--2 giảm số lượng thuốc khi thêm dữ liệu vào bảng chi tiết đơn hàng
create trigger trg_insert
on chitiethoadon
for insert
as
update thuoc
set thuoc.SOLUONG= thuoc.SOLUONG-inserted.soluong
from THUOC inner join inserted on thuoc.mathuoc=inserted.mathuoc
--3 tăng số lượng khi xoá dữ liệu bảng chi tiết đơn hàng
create trigger trg_delete
on chitiethoadon
for delete
as
update thuoc
set SOLUONG=thuoc.soluong+deleted.soluong
from thuoc inner join deleted on thuoc.mathuoc=deleted.mathuoc
--4 sửa dữ liệu bảng thuốc khi sửa dữ liệu bảng chi tiết đơn hàng
create trigger trg_update
on chitiethoadon
for update
as
update thuoc
set  soluong=thuoc.soluong-(inserted.soluong-deleted.soluong)
from thuoc inner join deleted on thuoc.mathuoc=deleted.mathuoc 
inner join inserted on thuoc.mathuoc=inserted.mathuoc
--5 bắt lỗi thêm dữ liệu vào chi tiết đặt hàng số lượng phải lớn hơn 0
create trigger trg_sl
on chitiethoadon
for insert
as
begin 
if exists (select soluong from inserted where soluong<1)
begin
	print N'Vui Lòng Nhập Số Lượng Lớn Hơn 0'
	rollback transaction
end
else
BEGIN
INSERT INTO CHITIETHOADON (SOHOADON, MATHUOC, GIABAN, SOLUONG, MUCGIAMGIA)
SELECT SOHOADON, MATHUOC, GIABAN, SOLUONG, MUCGIAMGIA FROM INSERTED;
    END
	end;
