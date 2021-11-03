create database chua_de27
drop database chua_de27
use chua_de27

create table sach(
masach nvarchar(10) primary key,
tensach nvarchar(30),
sotrang int,
slton int
)

create table phieumuon(
mapm nvarchar(10) primary key,
ngaymuon date,
hotendg nvarchar(30)
)

create table sachmuon
(
mapm nvarchar(10),
masach nvarchar(10),
songaymuon int,
primary key(mapm,masach),
foreign key (mapm) references phieumuon(mapm) on update cascade on delete cascade,
foreign key (masach) references sach(masach) on update cascade on delete cascade
)

--insert data
insert into sach values ('masach 1','tensach 1',15,10),('masach 2','tensach 2',30,15)

insert into phieumuon values ('mapm 1','1/1/2021','tendg 1'),('mapm 2','2/2/2021','tendg 2')

insert into sachmuon values ('mapm 1','masach 1',10),('mapm 2','masach 2',12),('mapm 1','masach 2',7),('mapm 2','masach 1',5)

select * from sach
select * from phieumuon
select * from sachmuon

--casu 2:
alter proc cau2(@ngay int, @thang int, @nam int)
as
begin
	
	select  count(sachmuon.masach) 
	from sachmuon inner join phieumuon on sachmuon.mapm = phieumuon.mapm inner join sach on sach.masach = sachmuon.masach
	where 
	dateadd(day,songaymuon,ngaymuon) >= DATEFROMPARTS(2021,1,3)
	--year(dateadd(day,songaymuon,ngaymuon)) <= @nam
	--and month(dateadd(day,songaymuon,ngaymuon)) <= @thang
	--and day(dateadd(day,songaymuon,ngaymuon)) < @ngay
end

select * from phieumuon
select * from sachmuon
exec cau2 3,1,2021
