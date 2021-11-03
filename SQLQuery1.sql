/*Tạo csdl QLBenhVien gồm 3 bảng: 
+ DV(MaDV,TenDV, gia)
+ PhieuKham(Sophieu, MaDV, MaBN, ngay, sl)
+ BenhNhan(MaBN,HoTen,NgaySinh,GioiTinh(bit))
*/
create  database QLBenhVien1 
use QLBenhVien1

create table DV (
MaDV char(10) not null primAry key ,
TenDV char(20) ,
Gia money
)
create table BenhNhan(
MaBN char(10) not null primary key,
HoTen char(20), 
NgaySinh date,
GioiTinh bit 
)

create table PhieuKham(
SoPhieu char(10) not null,
MaDV char(10) not null, 
MaBN char(10) not null,
Ngay date,
SL int ,
constraint PK1 primary key (SoPhieu ,MaDV) ,
constraint FK_MaDV foreign key (MaDV) references DV(MaDV) on update cascade on delete cascade,
constraint FK_MaBN foreign key (MaBN) references BenhNhan(MaBN) on update cascade on delete cascade
) 

insert  into DV values ('DV1','AAAAA',200)
insert  into DV values ('DV2','BBBBB',100)

insert into BenhNhan values ('BN1','Nguyen Van A', '1/1/2001', 1)
insert into BenhNhan values ('BN2','Nguyen Thi B', '2/2/2001', 0)

insert into PhieuKham values ('P1','DV1','BN1', '1/1/2020',10)
insert into PhieuKham values ('P2','DV2','BN2', '10/12/2020',15)

--Hãy tạo View đưa ra thống kê số bệnh nhân Nữ khám theo từng ngày gồm các thông tin: Ngày, Giới tính, Số_người

create view Thongke
as
select Ngay,(case GioiTinh when 1 then 'Nam' else 'Nu' end) as GioiTinh,count(PhieuKham.SoPhieu) as SoNguoi
from PhieuKham inner join BenhNhan on PhieuKham.MaBN=BenhNhan.MaBN 
				inner join DV on DV.MaDV= PhieuKham.MaDV
where GioiTinh=0
group by Ngay

drop view Thongke
select * from Thongke