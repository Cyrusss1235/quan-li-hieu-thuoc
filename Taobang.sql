create table KHACHHANGGG(
	MAKHACHHANG VARCHAR(20) PRIMARY KEY NOT NULL,
	TENKHACHHANG NVARCHAR(50) NOT NULL,
	DIACHI NVARCHAR(50) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	DIENTHOAI VARCHAR(13)
);
CREATE TABLE HOADONBAN(
SOHOADON VARCHAR(20) PRIMARY KEY NOT NULL ,
MAKHACHHANG VARCHAR(20)NOT NULL,
MANHANVIEN VARCHAR(20)NOT NULL,
NGAYMUA DATE NOT NULL,
);
CREATE TABLE NHANVIEN(
MANHANVIEN VARCHAR(20) PRIMARY KEY NOT NULL,
HO NVARCHAR(20) NOT NULL,
TEN NVARCHAR(20) NOT NULL,
NGAYSINH DATE NOT NULL,
NGAYLAMVIEC DATE NOT NULL,
DIACHI NVARCHAR(50) NOT NULL,
DIENTHOAI VARCHAR(13) ,
LUONGCOBAN INT
);
CREATE TABLE NHACUNGCAP(
MACONGTY VARCHAR(20) PRIMARY KEY NOT NULL,
TENCONGTY NVARCHAR(150) NOT NULL,
DIACHI NVARCHAR(150) NOT NULL,
DIENTHOAI VARCHAR(13) ,
EMAIL VARCHAR(50) NOT NULL,
);
CREATE TABLE CHITIETHOADON(
SOHOADON VARCHAR(20) NOT NULL,
MATHUOC VARCHAR(20) NOT NULL,
CONSTRAINT PK_MA PRIMARY KEY(SOHOADON,MATHUOC),
GIABAN INT NOT NULL,
SOLUONG INT NOT NULL,
MUCGIAMGIA INT NOT NULL CHECK(MUCGIAMGIA BETWEEN 0 AND 100)
);
CREATE TABLE THUOC(
MATHUOC VARCHAR(20) PRIMARY KEY NOT NULL,
TENTHUOC NVARCHAR(50) NOT NULL,
MACONGTY VARCHAR(20) NOT NULL,
MANHOMTHUOC VARCHAR(20) NOT NULL,
NSX DATE NOT NULL,
HSD DATE NOT NULL,
SOLUONG INT NOT NULL,
DONVITINH NVARCHAR(10) NOT NULL,
GIATHUOC INT NOT NULL
);
CREATE TABLE NHOMTHUOC(
MANHOMTHUOC VARCHAR(20) PRIMARY KEY NOT NULL,
TENNHOMTHUOC NVARCHAR(50) NOT NULL
);
ALTER TABLE HOADONBAN ADD 
CONSTRAINT FK_DH FOREIGN KEY (MAKHACHHANG) REFERENCES KHACHHANG(MAKHACHHANG),
CONSTRAINT FK_DH1 FOREIGN KEY (MANHANVIEN) REFERENCES NHANVIEN(MANHANVIEN)

ALTER TABLE CHITIETHOADON ADD
CONSTRAINT FK_DATHANG FOREIGN KEY (SOHOADON) REFERENCES HOADONBAN(SOHOADON),
CONSTRAINT FKDATHANG1 FOREIGN KEY (MATHUOC) REFERENCES THUOC(MATHUOC)

ALTER TABLE THUOC ADD
CONSTRAINT FK_MH FOREIGN KEY (MACONGTY) REFERENCES NHACUNGCAP(MACONGTY),
CONSTRAINT FK_MH1 FOREIGN KEY (MANHOMTHUOC) REFERENCES NHOMTHUOC(MANHOMTHUOC)
