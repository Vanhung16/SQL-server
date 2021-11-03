create database QUANLIDAOTAO
use QUANLIDAOTAO

create table hocvien
(
mahv nvarchar(10) primary key,
tenhv nvarchar(30),
diachi nvarchar(30),
ngaysinh date
)

create table monhoc
(
mamh nvarchar(10) primary key,
tenmh nvarchar(30),
mota nvarchar(30)
)

create table diem
(
mahv nvarchar(10),
mamh nvarchar(10),
diempra int,
diemqfx int,
ngaythi date,
primary key(mahv,mamh),
foreign key(mahv) references hocvien(mahv) on update cascade on delete cascade,
foreign key(mamh) references monhoc(mamh) on update cascade on delete cascade
)

--insert data
--cau1:
alter trigger cau1
on hocvien
for insert
as
begin
	declare @tuoi date
	select @tuoi = dateadd(year,18,inserted.ngaysinh) from hocvien inner join inserted on hocvien.mahv = inserted.mahv
	if(@tuoi > getdate())
		begin
			print N'vô lí vcl'
			rollback transaction
		end
	else
			print N'oke đã nhập thành công'
end

insert into hocvien values ('K007','Nguyen Huu Nguyen','Phu Li-Ha Nam','12/12/2009')

insert into hocvien values('K006','Vu Linh Chi','ha Dong-Ha Noi','07/12/1990')
select * from hocvien
drop database QUANLIDAOTAO