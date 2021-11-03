create database BTCTC
use BTCTC
--bang khoa
create table khoa(
makhoa varchar(10) not null primary key,
tenkhoa char(30) ,
dienthoai char(12),
)
--bang lop
create table lop(
malop varchar(10) not null primary key,
tenlop char(30),
hedt char(12),
namnhaphoc int,
makhoa varchar(10),
constraint fk1 foreign key (makhoa) references khoa(makhoa) on update cascade on delete cascade)
--chen du lieu
--thu tuc them
create proc SP_NHAPKHOA(@makhoa varchar(10),@tenkhoa char(30) ,@dienthoai char(12))
as 
	begin
		if(exists (select * from khoa where tenkhoa = @tenkhoa))
			print 'Ten khoa ' + @tenkhoa + ' da ton tai'
		else 
			insert into khoa values(@makhoa,@tenkhoa,@dienthoai)
	end

select * from khoa
exec SP_NHAPKHOA '1','XYZ','132'
exec SP_NHAPKHOA '2','CNTT','132'
--thủ tục xóa
create proc SP_XOAKHOA (@Makhoa varchar(10))
as
	begin
		if(not exists(select *from khoa where makhoa = @Makhoa))
			print 'ma khoa ' + @Makhoa + 'khong ton tai'
		else
			delete khoa where makhoa = @Makhoa
	end
select *from khoa
exec SP_XOAKHOA '2'
select *from khoa
--thủ tục sửa
create proc SP_SUAKHOA(@makhoa varchar(10),@tenkhoa char(30) ,@dienthoai char(12))
as
	begin
		if(not exists(select * from khoa where makhoa = @makhoa))
			print 'ma khoa ' + @makhoa + ' khong ton tai'
		else
		update khoa set tenkhoa = @tenkhoa,dienthoai = @dienthoai where makhoa = @makhoa
	end

	select * from khoa
	exec SP_SUAKHOA '2','HTTT','12343234'
	select * from khoa
--thu tuc tim kiem
create proc SP_timkiem(@makhoa varchar(10))
as
	begin
		if(not exists(select *from khoa where makhoa = @makhoa))
			print 'ma khoa ' + @makhoa + ' khong ton tai'
		else 
			select * from khoa where makhoa = @makhoa
	end

select * from khoa
exec SP_timkiem '1'
