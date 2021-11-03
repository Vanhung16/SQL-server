create database QLSV;
use QLSV;

create table SV(
MaSV nvarchar(10) not null primary key,
TenSV char(10) not null,
MaLop nvarchar(10) not null
)

create table LOP(
MaLop nvarchar(10) not null primary key,
TenLop char(10) not null,
Phong nvarchar(10) not null,
foreign key (MaLop) references LOP (MaLop)
)

insert into SV values (1,'A',1),(2,'B',2),(3,'C',1),(4,'D',3);


insert into LOP values (1,'CD',1),(2,'DH',2),(3,'LT',2),(4,'CH',4);


--1. Viết hàm thống kê xem mỗi lớp có bao nhiêu sinh viên với malop là tham số truyền vào từ bàn phím.

create function thongke(@MaLop nvarchar(10))
returns int
as
begin
declare @sl int
select @sl=count(SV.MaSV)
from SV inner join LOP on SV.MaLop = LOP.MaLop
where LOP.MaLop = @MaLop
group by LOP.MaLop
return @sl
end

select * from SV
select *from LOP
select  dbo.thongke('1') as 'số sinh viên'

--2. Đưa ra danh sách sinh viên(masv,tensv) học lớp với tenlop được truyền vào từ bàn phím.

create function danhsachsv(@TenLop char(10))
returns @danhsach table(
						MaSV nvarchar(10),
						TenSV char(10)
						)
as
begin 
	if(not exists(select MaLop from LOP where TenLop = @TenLop))
	insert into @danhsach
	select SV.MaSV , SV.TenSV
	from SV inner join LOP on SV.MaLop = LOP.MaLop
else
	insert into @danhsach
	select SV.MaSV , SV.TenSV
	from SV inner join LOP on SV.MaLop = LOP.MaLop
	where LOP.TenLop = @TenLop
return 
end
select * from SV
select *from LOP
select * from dbo.danhsachsv('A')
/*3. Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.*/

create function thongkesv(@TenLop char(10))
returns @thongke table (
						MaLop nvarchar(10),
						TenLop char(10),
						Sl int 
						)
as
begin
if(not exists (select MaLop from LOP where TenLop = @TenLop))
	insert into @thongke
	select LOP.MaLop,LOP.TenLop,count(Sv.MaSV) 
	from LOP inner join SV on LOP.MaLop = SV.MaLop
	group by LOP.MaLop,LOP.TenLop
else
	insert into @thongke
	select LOP.MaLop,LOP.TenLop,count(SV.MaSV)
	from LOP inner join SV on LOP.MaLop = SV.MaLop
	where LOP.TenLop = @TenLop
	group by LOP.MaLop,LOP.TenLop
return
end

select * from SV
select *from LOP
select *from dbo.thongkesv('DH')

--4. Đưa ra phòng học của tên sinh viên nhập từ bàn phím.

create function PhongHoc(@TenSV char(10))
returns nvarchar(10)
as
begin
declare @Phong nvarchar(10)
select @Phong = Phong
from LOP inner join SV on LOP.MaLop = SV.MaLop
where TenSV = @TenSV
return @Phong
end

select * from SV
select *from LOP
select dbo.PhongHoc('A') as 'phòng học'

/*5. Đưa ra thống kê masv,tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng
không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Neu phòng tồn tại thì đưa ra các
sinh vien của các lớp học phòng đó (Nhiều lớp học cùng phòng).*/

create function DUARASV(@Phong nvarchar(10))
returns @THONGKE TABLE (
						MaSV nvarchar(10),
						TenSV char(10),
						TenLop char(10)
						)
as 
begin
if(not exists (select MaLop from LOP where LOP.Phong = @Phong))
	insert into @THONGKE
	SELECT SV.MaSV,SV.TenSV,LOP.TenLop from SV inner join LOP on SV.MaLop = LOP.MaLop
else 
	insert into @THONGKE
	SELECT SV.MaSV,SV.TenSV,LOP.TenLop from SV inner join LOP on SV.MaLop = LOP.MaLop
	where Phong = @Phong
return
end


select * from SV
select *from LOP
select * from dbo.DUARASV(2)

--6. Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. Nếu phòng không tồn tại trả về giá trị 0

create function DEMLOP(@Phong nvarchar(10))
returns int
as
begin
if (NOT exists (select Phong from LOP where Phong =@Phong))
	return 0
else 
	DECLARE @sl INT
	select @sl = count(LOP.MaLop)
	from LOP
	where Phong = @Phong
	group by Lop.Phong
return @sl
end
drop function DEMLOP
select * from SV
select *from LOP
select dbo.DEMLOP(2) as 'số lớp'
	