create database QLTruongHoc

use QLTruongHoc

create table giaovien
(
magv nvarchar(10) primary key,
tengv nvarchar(30)
)

create table lop
(
malop nvarchar(10) primary key,
tenlop nvarchar(30),
phong nvarchar(10),
siso int,
magv nvarchar(10),
foreign key(magv) references giaovien(magv) on update cascade on delete cascade
)

create table sinhvien
(
masv nvarchar(10) primary key,
tensv nvarchar(30),
gioitinh nvarchar(10),
quequan nvarchar(30),
malop nvarchar(10),
foreign key (malop) references lop(malop) on update cascade on delete cascade
)

--insert data
insert into	giaovien values('magv 1','NGUYEN THI HUYEN'),('magv 2','NGUYEN THI NHUNG'),('magv 3','NGUYEN TUAN TU')

insert into lop values ('malop 1','CNTT','212',60,'magv 1'),
						('malop 2','HTTT','213',65,'magv 2'),
						('malop 3','KHMT','214',65,'magv 3')

insert into sinhvien values ('masv 1','NGUYEN VAN HUNG','NAM','HANOI','malop 1'),
							('masv 2','NGUYEN XUAN HOANG','NAM','BACGIANG','malop 2'),
							('masv 3','NGUYEN THI HOA','NU','HANOI','malop 3'),
							('masv 4','TRAN NGOC HUNG','NAM','THAIBINH','malop 2'),
							('masv 5','NGUYEN THI LINH','NU','NGHEAN','malop 1')

SELECT * FROM giaovien
SELECT * FROM lop
SELECT * FROM sinhvien

--CAU2:
create function cau2(@tenlop nvarchar(30),@tengv nvarchar(30))
returns @danhsach table(
						masv nvarchar(10),
						tensv nvarchar(30),
						gioitinh nvarchar(10),
						quequan nvarchar(30),
						malop nvarchar(10)
						)
as
begin
	insert into @danhsach
	select masv,tensv,gioitinh,quequan,sinhvien.malop
	from sinhvien inner join lop on sinhvien.malop = lop.malop
	inner join giaovien on lop.magv = giaovien.magv
	where tenlop = @tenlop and tengv = @tengv
	return
end

SELECT * FROM giaovien
SELECT * FROM lop
SELECT * FROM sinhvien
select * from cau2('CNTT','NGUYEN THI HUYEN')

--CAU3:
create proc cau3(@masv nvarchar(10),@tensv nvarchar(30),@gioitinh nvarchar(10),@quequan nvarchar(30),@tenlop nvarchar(30))
as
begin
	if(not exists(select malop from lop where tenlop = @tenlop))
		begin
			print concat(N'tên lớp ',@tenlop,N' không tồn tại')
		end
	else
		begin
			declare @malop nvarchar(10)
			select @malop = malop from lop where tenlop = @tenlop
			insert into sinhvien values(@masv,@tensv,@gioitinh,@quequan,@malop)
		end
end

SELECT * FROM sinhvien
exec cau3 'masv 6','TRAN MANH QUANG','NAM','HANOI','CNTT'
SELECT * FROM sinhvien

--CAU4
create trigger cau4
on sinhvien
for update
as
begin
	declare @malop nvarchar(10)
	select @malop = sinhvien.malop 
	from sinhvien inner join inserted on sinhvien.masv = inserted.masv
	declare @siso int
	select @siso = siso from lop
	update lop set siso = @siso + 1 where malop = @malop
end

select * from sinhvien
select * from lop
update sinhvien set malop = 'malop 2' where masv = 'masv 1'
select * from sinhvien
select * from lop
