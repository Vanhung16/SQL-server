create database QLSinhVien
use QLSinhVien

create table khoa(
makhoa nvarchar(10) not null,
tenkhoa char(30) not null,
constraint pk_khoa_makhoa primary key(makhoa)
)

create table lop(
malop nvarchar(10) not null,
tenlop char(30) not null,
siso int default(0) not null,
makhoa nvarchar(10) not null,
constraint pk_lop_malop primary key (malop),
constraint fk_lop_malop foreign key (makhoa) references khoa(makhoa) on update cascade on delete cascade,
)
create table sinhvien(
masv nvarchar(10) not null,
hoten char(30) not null,
ngaysinh datetime not null,
gioitinh bit not null,
malop nvarchar(10) not null,
constraint pk_sinhvien_masv primary key(masv),
constraint fk_sinhvien_malop foreign key (malop) references lop(malop) on update cascade on delete cascade,
)
--insert data
insert into khoa values('makhoa 1','CNTT'),	('makhoa 2','HTTT')

insert into lop values('malop 1','TenLop 1',10,'makhoa 1')
insert into lop values('malop 3','TenLop 2',16,'makhoa 1')
insert into sinhvien values('masv 1','Văn Hùng','11/16/2001',1,'malop 1'),
							('masv 2','Nguyễn Văn Hùng','11/11/2001',1,'malop 2'),
							('masv 3','Nguyễn Thị A','11/1/2001',0,'malop 1'),
							('masv 4','Nguyễn Văn A','11/6/2001',1,'malop 2'),
							('masv 5','Nguyễn Thị B','1/16/2001',0,'malop 1'),
							('masv 6','Nguyễn Văn C','10/16/2001',1,'malop 2'),
							('masv 7','Nguyễn Thị D','1/1/2001',0,'malop 1')
select * from khoa
select * from lop
select * from sinhvien
--Câu 2 (2đ): Hãy tạo View đưa ra thống kê số lớp của từng khoa gồm các thông tin: TenKhoa, Số lớp
create view thongkesolop
as
select khoa.tenkhoa, count(lop.malop) as N'số lớp'
 from khoa inner join lop on khoa.makhoa = lop.makhoa
 group by khoa.tenkhoa

 select * from thongkesolop
 --Câu 3 (2đ): Viết hàm với tham số truyền vào là MaKhoa, hàm trả về một bảng gồm các thông tin:MaSV, HoTen, NgaySinh, GioiTinh (là “Nam“ hoặc “Nữ“), TenLop, TenKhoa.
 alter function  bang(@makhoa nvarchar(10))
 returns @danhsach table( 
						masv nvarchar(10),
						hoten char(30), 
						ngaysinh datetime,
						gioitinh char(10),
						tenlop char(30), 
						tenkhoa char(30)
						)
as 
	begin
		insert into @danhsach
		select masv , hoten, ngaysinh, (case gioitinh when 1 then 'Nam' else N'Nữ' end) as gioitinh, tenlop,tenkhoa
		from sinhvien inner join lop on sinhvien.malop = lop.malop 
			inner join khoa on khoa.makhoa = lop.makhoa
		where khoa.makhoa = @makhoa
		return
	end

select * from bang('makhoa 1')
/*Câu 4 (3đ): Hãy tạo thủ tục lưu trữ tìm kiếm sinh viên theo khoảng tuổi và lớp 
(Với 3 tham số vào là: TuTuoi và DenTuoi và tên lớp). Kết quả tìm được sẽ đưa ra một danh sách gồm: MaSV, HoTen, NgaySinh,TenLop,TenKhoa, Tuoi. */

alter proc timkiem(@tutuoi int,@dentuoi int, @tenlop char(30))
as
	begin 
		select masv,hoten,ngaysinh,tenlop,tenkhoa, (year(getdate()) - year(ngaysinh))as tuoi
		from sinhvien inner join lop on sinhvien.malop = lop.malop
		inner join khoa on khoa.makhoa = lop.makhoa
		where tenlop = @tenlop and ((year(getdate())-year(ngaysinh)) between @tutuoi and @dentuoi)
	end
			
exec timkiem 1,30,'TenLop 2'
/*Hoặc Câu 4: (3đ):
Tạo Hàm Đưa ra những sinh viên (của một khoa nào đó với tên khoa nhập từ bàn phím) gồm: MaSV, HoTen, Tuổi (năm hiện tại – năm sinh).
*/
create proc thongtin(@tenkhoa char(30))
as
	begin
		select masv,hoten,year(getdate())-year(ngaysinh) as tuoi
		from sinhvien inner join lop on sinhvien.malop = lop.malop
		inner join khoa on lop.makhoa = khoa.makhoa
		where tenkhoa = @tenkhoa
	end

exec thongtin 'HTTT'
exec thongtin 'CNTT'