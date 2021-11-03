CREATE DATABASE QLBanHang;
USE QLBanHang;
go
CREATE TABLE VatTu(
MaVTu CHAR(4) not NULL PRIMARY KEY,
TenVTu NVARCHAR(100) not NULL,
DvTinh NVARCHAR(10) not NULL,
PhanTram REAL,
)
create table NHACC(
MaNhaCc char(3) not NULL ,
TenNhaCc nvarchar(100) not NULL,
DiaChi nvarchar(200) not NULL,
DienThoai varchar(20)not NULL,
primary key(MaNhaCc),
)
create table DONDH(
SoDh char(4) not NULL primary key,
NgayDh datetime not NULL,
MaNhaCc char(3) not NULL,
foreign key(MaNhaCc) references NHACC(MaNhaCc),
foreign key(SoDh) references DONDH(SoDh),
)
create table PNHAP(
SoPn char(4) not NULL primary key,
NgayNhap datetime not NULL,
SoDh char(4) not NULL,

)create table PXUAT(
SoPx char(4) not NULL primary key,
NgayXuat datetime not NULL,
TenKh nvarchar(100) not NULL,
)

create table CTDONDH(
SoDh char(4) not NULL ,
MaVTu char(4) not NULL,
SlDat int not NULL,
primary key (SoDh,MaVTu),
foreign key(SoDh) references DONDH(SoDh),
foreign key(MaVTu) references VatTu(MaVTu),
)

create table CTPNHAP(
SoPn char(4) not NULL ,
MaVTu char(4) not NULL,
SlNhap int not NULL,
DgNhap money not NULL,
primary key (SoPn,MaVTu),
foreign key(SoPn) references PNHAP(SoPn),
foreign key(MaVTu) references VatTu(MaVTu),

)
create table CTPXUAT(
SoPx char(4) not NULL ,
MaVTu char(4) not NULL,
SlXuat int not NULL,
DgXuat money not NULL,
primary key (SoPx,MaVTu),
foreign key(SoPx) references PXUAT(SoPx),
foreign key(MaVTu) references VatTu(MaVTu),
)

create table TONKHO(
NamThang char(6) not NULL,
MaVTu char(4) not NULL,
SLDau int not NULL,
TONGSLN int not NULL,
TONGSLX int not NULL,
SLCuoi int not NULL,
primary key(NamThang,MaVTu),
foreign key(MaVTu) references VatTu(MaVTu),
)

insert into NHACC values('C01','Lê Minh Trí','54 Hậu Giang Q6 HCM','8781024');
insert into NHACC values('C02','Trần Minh Thạch','145 Hùng Vương Mỹ tho','7698154');
insert into NHACC values('C03','Hồng Phương','154/85 Lê Lai Q1 HCM','9600125');
insert into NHACC values('C04','Nhật Thắng','198/40 Hương Lộ 14 QTB HCM','8757757');
insert into NHACC values('C05','Lưu Nguyệt Quế','178 Nguyễn Văn Lương Đà Lạt','7964251');
insert into NHACC values('C07','Cao Minh Trung','125 Lê Quang Sung','Chưa có');
select*from NHACC;
insert into DONDH values('D001','01/15/2005','C03');
insert into DONDH values('D002','01/30/2005','C01');
insert into DONDH values('D003','02/10/2005','C02');
insert into DONDH values('D004','02/17/2005','C05');
insert into DONDH values('D005','03/01/2005','C02');
insert into DONDH values('D006','03/12/2005','C05');

insert into PNHAP values('N001','01/17/2005','D001');
insert into PNHAP values('N002','01/20/2005','D001');
insert into PNHAP values('N003','01/31/2005','D002');
insert into PNHAP values('N004','02/15/2005','D003');

insert into CTDONDH values('D001','DD01',10);
insert into CTDONDH values('D001','DD02',15);
insert into CTDONDH values('D002','VD02',30);
insert into CTDONDH values('D003','TV14',10);
insert into CTDONDH values('D003','TV29',20);
insert into CTDONDH values('D004','TL90',10);
insert into CTDONDH values('D005','TV14',10);
insert into CTDONDH values('D005','TV29',20);
insert into CTDONDH values('D006','TV14',10);
insert into CTDONDH values('D006','TV29',20);
insert into CTDONDH values('D006','VD01',20);

insert into CTPNHAP values('N001','DD01',8,2500000);
insert into CTPNHAP values('N001','DD02',10,3500000);
insert into CTPNHAP values('N002','DD01',2,2500000);
insert into CTPNHAP values('N002','DD02',5,2500000);
insert into CTPNHAP values('N003','VD02',30,2500000);
insert into CTPNHAP values('N004','TV14',5,2500000);
insert into CTPNHAP values('N004','TV29',12,2500000);

insert into PXUAT(SoPx,NgayXuat) values('X001','01/17/2005'/*,'Nguyễn Ngọc Phương Nhi'*/);
insert into PXUAT values('X002','01/25/2005','Nguyễn Hoàng Phương');
insert into PXUAT values('X003','01/31/2005','Nguyễn Tuấn Tú');

insert into CTPXUAT values('X001','DD01',2,3500000);
insert into CTPXUAT values('X002','DD01',1,3500000);
insert into CTPXUAT values('X002','DD02',5,4900000);
insert into CTPXUAT values('X003','DD01',3,3500000);
insert into CTPXUAT values('X003','DD02',2,4900000);
insert into CTPXUAT values('X003','VD02',10,3250000);


insert into TONKHO values('200501','DD01',0,10,6,4);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200501','DD02',0,15,7);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200501','VD02',0,30,10);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200502','DD01',4,0,0);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200502','DD01',8,0,0);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200502','DD01',20,0,0);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200502','DD01',5,0,0);
insert into TONKHO(NamThang,MaVTu,SLDau,SLCuoi,TONGSLN,TONGSLX) values('200502','DD01',12,0,0);
