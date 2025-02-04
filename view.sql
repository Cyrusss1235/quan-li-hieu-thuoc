﻿--5 CÂU VIEW
--1 Danh sách khách hàng và tổng số tiền đã chi tiêu
CREATE VIEW KhachHangTongChiTieu AS
SELECT 
    KHACHHANG.MAKHACHHANG, 
    KHACHHANG.TENKHACHHANG, 
    KHACHHANG.DIACHI, 
    KHACHHANG.EMAIL, 
    KHACHHANG.DIENTHOAI,
    SUM(CT.GIABAN * CT.SOLUONG * (1 - CT.MUCGIAMGIA / 100.0)) AS TONGCHI
FROM 
    KHACHHANG
JOIN 
    HOADONBAN HB ON KHACHHANG.MAKHACHHANG = HB.MAKHACHHANG
JOIN 
    CHITIETHOADON CT ON HB.SOHOADON = CT.SOHOADON
GROUP BY 
    KHACHHANG.MAKHACHHANG, 
    KHACHHANG.TENKHACHHANG, 
    KHACHHANG.DIACHI, 
    KHACHHANG.EMAIL, 
    KHACHHANG.DIENTHOAI;
--2 Danh sách nhân viên và tổng số hóa đơn bán được
CREATE VIEW NhanVienHoaDonBan AS
SELECT 
    NHANVIEN.MANHANVIEN, 
    NHANVIEN.HO, 
    NHANVIEN.TEN, 
    NHANVIEN.DIACHI, 
    NHANVIEN.DIENTHOAI, 
    NHANVIEN.LUONGCOBAN,
    COUNT(HB.SOHOADON) AS TONGHOADONBAN
FROM 
    NHANVIEN
LEFT JOIN 
    HOADONBAN HB ON NHANVIEN.MANHANVIEN = HB.MANHANVIEN
GROUP BY 
    NHANVIEN.MANHANVIEN, 
    NHANVIEN.HO, 
    NHANVIEN.TEN, 
    NHANVIEN.DIACHI, 
    NHANVIEN.DIENTHOAI, 
    NHANVIEN.LUONGCOBAN;

--3 Thông tin chi tiết hóa đơn bán hàng
CREATE VIEW ChiTietHoaDonBanHang AS
SELECT 
    HOADONBAN.SOHOADON, 
    KHACHHANG.TENKHACHHANG, 
    KHACHHANG.DIACHI AS DIACHIKHACHHANG, 
    KHACHHANG.DIENTHOAI AS DIENTHOAIKHACHHANG, 
    NHANVIEN.HO AS HONHANVIEN, 
    NHANVIEN.TEN AS TENNHANVIEN, 
    NHANVIEN.DIACHI AS DIACHINHANVIEN, 
    NHANVIEN.DIENTHOAI AS DIENTHOAINHANVIEN, 
    HOADONBAN.NGAYMUA 
FROM 
    HOADONBAN
JOIN 
    KHACHHANG ON HOADONBAN.MAKHACHHANG = KHACHHANG.MAKHACHHANG
JOIN 
    NHANVIEN ON HOADONBAN.MANHANVIEN = NHANVIEN.MANHANVIEN;


--4Thông tin chi tiết của các hóa đơn bán trong tháng 5
CREATE VIEW HoaDonThangHienTai AS
SELECT 
    HOADONBAN.SOHOADON, 
    KHACHHANG.TENKHACHHANG, 
    KHACHHANG.DIACHI AS DIACHIKHACHHANG, 
    KHACHHANG.DIENTHOAI AS DIENTHOAIKHACHHANG, 
    NHANVIEN.HO AS HONHANVIEN, 
    NHANVIEN.TEN AS TENNHANVIEN, 
    NHANVIEN.DIACHI AS DIACHINHANVIEN, 
    NHANVIEN.DIENTHOAI AS DIENTHOAINHANVIEN, 
    HOADONBAN.NGAYMUA
FROM 
    HOADONBAN
JOIN 
    KHACHHANG ON HOADONBAN.MAKHACHHANG = KHACHHANG.MAKHACHHANG
JOIN 
    NHANVIEN ON HOADONBAN.MANHANVIEN = NHANVIEN.MANHANVIEN
WHERE 
    NGAYMUA like '2024-05%'

--5 Danh sách các loại thuốc và thông tin nhà cung cấp
CREATE VIEW ThuocVaNhaCungCap AS
SELECT 
    THUOC.MATHUOC, 
    THUOC.TENTHUOC, 
    NHACUNGCAP.TENCONGTY, 
    NHACUNGCAP.DIACHI AS DIACHINHACUNGCAP, 
    NHACUNGCAP.DIENTHOAI AS DIENTHOAINHACUNGCAP,
    NHACUNGCAP.EMAIL AS EMAILNHACUNGCAP
FROM 
    THUOC
JOIN 
    NHACUNGCAP ON THUOC.MACONGTY = NHACUNGCAP.MACONGTY;

	select *from NhanVienHoaDonBan
	select *from ChiTietHoaDonBanHang
-----------------------------------------------------------------------------
