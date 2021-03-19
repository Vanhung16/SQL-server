create database BanHang;
use BanHang;


create table HangSX(
MaHangSX char(12) not NULL PRIMARY KEY,
TenHang char(100) not NULL,
DiaChi char(15) not NULL,
SoDT int not NULL,
Email char(100) not NULL,

)
create table SanPham(
MaSP char(12) not NULL PRIMARY KEY,
MaHangSX char(12) not NULL,
TenSP char(100) not NULL,
SoLuong int not NULL,
MauSac char(10) not NULL,
GiaBan money not NULL,
DonViTinh char(10) not NULL,
MoTa char(15) not  NULL,
foreign key (MaHangSX) references HangSX(MaHangSX)

)

create table NhanVien(
MaNV char(12) not NULL PRIMARY KEY,
TenNV char(100) not NULL,
GioiTinh char(10) not NUll,
DiaChi char(15) not NULL,
SoDT int not NULL,
Email char(100) not NULL,
TenPhong char(100) not NULL
)

create table PNhap(
SoHDN char(15) not NULL primary key,
NgayNhap datetime not NULL,
MaNV char(12) not NULL,
foreign key (MaNV) references NhanVien(MaNV)
)
create table PXuat(
SoHDX char(15) not NULL primary key,
NgayXuat datetime not NULL,
MaNV char(12) not NULL,
foreign key (MaNV) references NhanVien(MaNV)
)
create table Nhap(
SoHDN char(15) not NULL,
MaSP char(12) not NULL,
SoLuongN int not NULL,
DonGiaN money not NULL,
primary key(SoHDN,MaSP),
foreign key(SoHDN) references PNhap(SoHDN),
foreign key(MaSP) references SanPham(MaSP)
)
create table Xuat(
SoHDX char(15) not NULL,
MaSP char(12) not NULL,
SoLuongX int not NULL,
primary key(SoHDX,MaSP),
foreign key(SoHDX) references PXuat(SoHDX),
foreign key(MaSP) references SanPham(MaSP)
)

insert into SanPham values('MaSP1', 'MaHangSX1', 'TenSP1', 10, 'MauSac1', 100, 'DonViTinh1', 'MoTa1');
insert into SanPham values('MaSP2', 'MaHangSX2', 'TenSP2', 20, 'MauSac2', 200, 'DonViTinh2', 'MoTa2');
insert into SanPham values('MaSP3', 'MaHangSX3', 'TenSP3', 30, 'MauSac3', 300, 'DonViTinh3', 'MoTa3');
select * from SanPham

insert into HangSX values('MaHangSX1', 'TenHang1', 'DiaChi1', 123, 'Email1');
insert into HangSX values('MaHangSX2', 'TenHang2', 'DiaChi2', 456, 'Email2');
insert into HangSX values('MaHangSX3', 'TenHang3', 'DiaChi3', 789, 'Email3');
select * from HangSX

insert into NhanVien values('MaNV1', 'TenNV1', 'GioiTinh1', 'DiaChi1', 321, 'Email1', 'TenPhong1');
insert into NhanVien values('MaNV2', 'TenNV2', 'GioiTinh2', 'DiaChi2', 654, 'Email2', 'TenPhong2');
insert into NhanVien values('MaNV3', 'TenNV3', 'GioiTinh3', 'DiaChi3', 987, 'Email3', 'TenPhong3');
select * from NhanVien

insert into PNhap values('SoHDN1','1/2/2001','MaNV1');
insert into PNhap values('SoHDN2','2/2/2001','MaNV2');
insert into PNhap values('SoHDN3','3/2/2001','MaNV3');
insert into PNhap values('SoHDN4','3/2/2018','MaNV4');
select * from PNhap
insert into Nhap values('SoHDN1', 'MaSP1', 10, 1000);
insert into Nhap values('SoHDN2', 'MaSP2', 20, 2000);
insert into Nhap values('SoHDN3', 'MaSP3', 30, 3000);
insert into Nhap values('SoHDN4', 'MaSP4', 30, 3000);
select * from Nhap




insert into Xuat values('SoHDX1', 'MaSP1', 100);
insert into Xuat values('SoHDX2', 'MaSP2', 200);
insert into Xuat values('SoHDX3', 'MaSP3', 300);


insert into PXuat values('SoHDX1','1/2/2021','MaNV1');
insert into PXuat values('SoHDX2','2/2/2021','MaNV2');
insert into PXuat values('SoHDX3','3/2/2021','MaNV3');

--câu a:Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
create view CAUA AS
SELECT HangSX.MaHangSX,TenHang,count(*) as' số lượng SP'
from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
group by HangSX.MaHangSX,TenHang

select*from CAUA
--câu b:Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.

create view CAUB as
Select SanPham.MaSP,TenSP, sum(SoLuongN*DonGiaN) As 'Tổng tiền nhập'
From Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
 Inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
Where Year(NgayNhap)=2020
Group by SanPham.MaSP,TenSP
--test
select*from CAUB
--câu c: Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung.
create view CAUC as
Select SanPham.MaSP,TenSP,sum(SoLuongX) As 'Tổng xuất'
From Xuat Inner join SanPham on Xuat.MaSP = SanPham.MaSP
 Inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
 Inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
Where Year(NgayXuat)=2018 And TenHang = 'Samsung'
Group by SanPham.MaSP,TenSP
Having sum(SoLuongX) >=10000
--test
select*from CAUC
--câu d:Thống kê số lượng nhân viên Nam của mỗi phòng ban.
create view CAUD as
select TenPhong, count(MaNV) as 'số nhân viên nam'
from NhanVien 
where GioiTinh = 'Nam'
group by TenPhong
--test:
select*from CAUD
--câu e:Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
create view CAUE as
select SanPham.MaHangSX,sum(Nhap.SoLuongN) as'tổng SLN'
from Nhap inner join SanPham on Nhap.MaSP=SanPham.MaSP inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
where year(NgayNhap) = 2018
group by SanPham.MaHangsx
--test
select*from CAUE
--câu f: Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu

select NhanVien.MaNV, sum(SoLuongX*GiaBan) as 'tổng tiền xuất'
from NhanVien inner join PXuat on NhanVien.MaNV = PXuat.MaNV
inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
inner join SanPham on Xuat.MaSP = SanPham.MaSP
where year(PXuat.NgayXuat) = 2018
group by NhanVien.MaNV;

--câu g
create view CauG
as
select NhanVien.MaNV, TenNV, sum(SoLuongN * DonGiaN) as 'Tong Tien Nhap'
from NhanVien inner join PNhap on NhanVien.MaNV = PNhap.MaNV
			  inner join Nhap on PNhap.SoHDN = Nhap.SoHDN
where year(NgayNhap) = '2018' and month(NgayNhap) = '8'
group by NhanVien.MaNV, TenNV
having sum(SoLuongN * DonGiaN) > 100000

--câu h
create view CauH
as
Select SanPham.MaSP,TenSP
From SanPham Inner join nhap on SanPham.MaSP = nhap.MaSP
Where SanPham.MaSP Not In (Select MaSP From Xuat)

--câu i
create view CauI
as
select TenSP, SanPham.MaSP
from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
			 inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
			 inner join Xuat on SanPham.MaSP = Xuat.MaSP
			 inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
where YEAR(NgayNhap) = '2020' and year(NgayXuat) = '2020'
and SanPham.MaSP in (select Nhap.MaSP from Nhap)
and SanPham.MaSP in (select Xuat.MaSP from Xuat);

--câu j
create view CauJ
as
select TenNV, NhanVien.MaNV
from NhanVien inner join PNhap on NhanVien.MaNV = PNhap.MaNV
			  inner join Nhap on Nhap.SoHDN = PNhap.SoHDN
			  inner join PXuat on NhanVien.MaNV = PXuat.MaNV
			  inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
where NhanVien.MaNV in (select PNhap.MaNV from PNhap)
and NhanVien.MaNV in (select PXuat.MaNV from PXuat);

--câu k
create view Cauk
as
select TenNV, NhanVien.MaNV
from NhanVien inner join PNhap on NhanVien.MaNV = PNhap.MaNV
			  inner join Nhap on Nhap.SoHDN = PNhap.SoHDN
			  inner join PXuat on NhanVien.MaNV = PXuat.MaNV
			  inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
where NhanVien.MaNV not in (select PNhap.MaNV from PNhap)
and NhanVien.MaNV  not in (select PXuat.MaNV from PXuat);

--câu l

create view demo
as
select SanPham.MaSP, sum(soluongx) as TongSl
from SanPham inner join xuat on SanPham.MaSP = Xuat.MaSP
group by SanPham.masp

create view CauL
as
select TenSP
from SanPham inner join Xuat on SanPham.MaSP = Xuat.MaSP
			 inner join PXuat on Xuat.SoHDX = Xuat.SoHDX
group by TenSP
having sum(SoLuongX) = (select max(TongSl) from demo)


--câu m
create view m
as 
select TenSP, TenHang
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
where GiaBan = (select min(GiaBan) from SanPham);

--câu cuối

create view caucuoi
as
select tensp
from SanPham inner join Xuat on SanPham.MaSP = Xuat.MaSP
				inner join PXuat on PXuat.SoHDX = Xuat.SoHDX
where year(NgayXuat) = '2020'
group by TenSP
having count(TenSP) > 10

