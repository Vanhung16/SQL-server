create database chuade_22
use chuade_22

create table sanpham
(
masp nvarchar(10) primary key,
tensp nvarchar(30),
mausac nvarchar(10),
soluong int,
giaban money
)

create table congty
(
mact nvarchar(10) primary key,
tenct nvarchar(30),
trangthai nvarchar(10),
thanhpho nvarchar(30)
)

create table cungung
(
mact nvarchar(10),
masp nvarchar(10),
soluongcungung int,
primary key(mact,masp),
foreign key(mact) references congty(mact) on update cascade on delete cascade,
foreign key(masp) references sanpham(masp) on update cascade on delete cascade
)
--insert data
insert into congty values ('mact 1','tenct 1','tot','ha noi'),('mact 2','tenct 2','tot','truong thinh'),('mact 3','tenct 3','tot','ung hoa')

insert into sanpham values ('masp 1','tensp 1','xanh',10,15),('masp 2','tensp 2','do',15,20),('masp 3','tensp 3','tim',20,30)

insert into cungung values ('mact 1','masp 1',50),('mact 2','masp 2',70),('mact 3','masp 3',100),('mact 1','masp 2',100),('mact 1','masp 3',100)

select * from congty
select * from sanpham
select * from cungung
--cau2:
create proc cau2(@masp nvarchar(10))
as
begin 
	if(not exists(select * from sanpham where masp = @masp))
		print 'khong ton tai ma san pham co ma la ' + @masp
	else
		if(exists (select * from sanpham where masp = @masp and soluong > 10))
			print 'khong duoc xoa san pham nay'
		else
			delete from sanpham where masp = @masp

end
select * from sanpham
exec cau2 'masp 1'