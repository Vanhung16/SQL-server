create database QLBANHANG1
use QLBANHANG1

create table congty(
mact varchar(10) NOT NULL PRIMARY KEY,
tenct char(100),
trangthai char(100),
soluong int
)
create table sanpham(
masp varchar(10) not null primary key,
mausac char(10),
soluong int,
giaban money
)
create table cungung(
mact varchar(10) not null,
masp varchar(10) not null,
soluong int,
primary key(mact,masp),
foreign key(mact) references congty(mact),
foreign key(masp) references sanpham(masp)
)
--cau a
insert into congty values ('1','hung','tot',2),('2','van','tot',3),('3','nguyen','tot',5)
insert into sanpham values ('1','do',10,20),('2','xanh',20,30),('3','hồng',40,5)
insert into cungung values ('1','1',20),('2','3',3),('3','2',5)
insert into cungung values ('1','3',10),('1','2',15)


--cau b
select congty.mact,congty.tenct,sum(cungung.soluong*sanpham.giaban) as'tong tien cun ung'
from congty inner join cungung on congty.mact = cungung.mact
inner join sanpham on sanpham.masp = cungung.masp
group by congty.mact, congty.tenct


--cau c
alter proc danhsach(@tenct char(100))
as
	begin
		select sanpham.masp,mausac,sanpham.soluong,giaban from sanpham inner join cungung on sanpham.masp = cungung.masp
		inner join congty on congty.mact = cungung.mact
		where  tenct = @tenct
	end

select * from sanpham
exec danhsach 'hung'
