create database QLKHO;
use QLKHO;

create table Ton(
MaVT char(12) not NULL PRIMARY KEY,
TenVT char(100) not NULL,
SoLuongT int not NULL,
)
create table Nhap(
MaVT char(12) not NULL,
SoHDN char(12) not NULL,
SoLuongN int not NULL,
DonGiaN money not NULL,
NgayN datetime not NULL,
primary key(MaVT,SoHDN),
foreign key (MaVT) references Ton(MaVT)
)
create table Xuat(
MaVT char(12) not NULL,
SoHDX char(12) not NULL,
SoLuongX int not NUll,
DonGiaX money not NULL,
NgayX datetime not NULL,
primary key (MaVT,SoHDX),
foreign key (MaVT) references Ton(MaVT)
)

insert into Ton values('VT1','laptop',27)
insert into Ton values('VT2','balo',50)
insert into Ton values('VT3','mouse',75)
insert into Ton values('VT4','mouse mat',90)
insert into Ton values('VT5','keyboard',87)

select*from Ton

insert into Nhap values('VT1','N01',34,456,'12/23/2012')
insert into Nhap values('VT2','N03',45,496,'01/12/2012')
insert into Nhap values('VT3','N02',34,234,'12/23/2012')

select*from Nhap

insert into Xuat values('VT2','X01',37,800,'01/23/2013')
insert into Xuat values('VT3','X02',23,400,'12/09/2013')

select*from Xuat
--1.thống kê tiền bán theo mã vật tư gồm MaVT,TenVT,TienBan(TienBan = SoLuongX*DonGiaX)
select Xuat.MaVT, TenVT ,sum(SoLuongX*DonGiaX) as TienBan
from Ton INNER JOIN Xuat ON Ton.MaVT = Xuat.MaVt
group by Xuat.MaVT, TenVT
--2.thống kê số lượng xuât theo tên vật tư
select TenVT,SoLuongX
from Ton inner join Xuat on Ton.MaVT=Xuat.MaVT
--3.thống kê số lượng nhập theo tên vật tư
select TenVT,SoLuongN
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT
--4.đưa ra tổng số lượng còn trong kho biết còn = nhập - xuất + tồn theo từng nhóm vật tư
select Ton.MaVT, sum(SoLuongN) - sum(SoLuongX) + sum(SoLuongT) as còn
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT inner join Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT
--5.đưa ra tên vật tư có số lượng tồn nhiều nhất
select TenVT from Ton
where SoLuongT = (select max(SoLuongT) from Ton)
--6.đưa ra các vật tư có tổng số lượng xuất lớn hơn 100
select TenVT,Ton.MaVT from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT inner join Xuat on Ton.MaVT=Xuat.MaVT
where SoLuongX >100
--7.đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo tháng và năm xuất
select month(NgayX) as tháng,year(NgayX)as năm,sum(SoLuongX) as 'tổng số lượng xuất'
from Xuat
group by month(NgayX),year(NgayX)
--8	đưa ra mã vật tư, TenVT,SoLuongN,SoLuongX,DonGiaN,DonGiaX,NgayN,NgayX
select Ton.MaVT,TenVT,SoLuongN,SoLuongX,DonGiaN,DonGiaX,NgayN,NgayX
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT inner join Xuat on Ton.MaVT=Xuat.MaVT
--9 đửaa MaVT,TenVT và tổng số lượng còn lại trong kho biết còn lại = SoLuongN-SoLuongX+SoLuongT theo từng loại vật tư trong năm 2015
select Ton.MaVT, TenVT, sum(SoLuongN-SoLuongX+SoLuongT) as 'còn lại'
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT inner join Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT,TenVT
--10. hiển thị danh sách vật tư chưa được xuất lần nào
select TenVT,MaVT from Ton 
where MaVT not in (select MaVT from Xuat)
--cau2:
create view cau2 as 
select Xuat.MaVT, TenVT ,sum(SoLuongX*DonGiaX) as TienBan
from Ton INNER JOIN Xuat ON Ton.MaVT = Xuat.MaVt
group by Xuat.MaVT, TenVT
--TEST
select*from cau2
--CAU3:
CREATE VIEW CAU3 AS
select TenVT,SoLuongX
from Ton inner join Xuat on Ton.MaVT=Xuat.MaVT
--TEST CAU3
SELECT*FROM CAU3
--CAU4:
CREATE VIEW CAU4 AS
select TenVT,SoLuongN
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT
--TEST CAU4
SELECT*FROM CAU4
--CAU5:
CREATE VIEW CAU5 AS
select Ton.MaVT, sum(SoLuongN) - sum(SoLuongX) + sum(SoLuongT) as còn
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT inner join Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT
--TEST CAU5
SELECT*FROM CAU5;

