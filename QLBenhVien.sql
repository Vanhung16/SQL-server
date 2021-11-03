create database QLBenhVien
use QLBenhVien

create table benhvien(
mabv varchar(10) not null primary key,
tenbv char(30)
)

create table khoakham(
makhoa varchar(10) not null primary key,
tenkhoa char(30),
sobenhnhan int,
mabv varchar(10),
foreign key (mabv) references benhvien(mabv) on update cascade on delete cascade
)

create table benhnhan(
mabn varchar(10) not null primary key,
hoten char(30),
ngaysinh datetime,
gioitinh bit,
songaynv int,
makhoa varchar(10),
foreign key (makhoa) references khoakham(makhoa) on update cascade on delete cascade
)

insert into benhvien values ('mabv 1','benh vien A'),('mabv 2','benh vien B')
select * from benhvien
insert into khoakham values ('makhoa 1','khoa A',10,'mabv 1'),('makhoa 2','khoa B',15,'mabv 2')
select * from khoakham
insert into benhnhan values ('mabn 1','hoten 1','3/3/1999',1,15,'makhoa 1'),
							('mabn 2','hoten 2','4/3/1998',1,10,'makhoa 2'),
							('mabn 3','hoten 3','3/3/1989',0,15,'makhoa 1'),
							('mabn 4','hoten 4','3/3/1992',1,3,'makhoa 2'),
							('mabn 5','hoten 5','3/3/1993',0,4,'makhoa 1'),
							('mabn 6','hoten 6','3/3/1994',1,5,'makhoa 2'),
							('mabn 7','hoten 7','3/3/1996',0,8,'makhoa 2')
select * from benhnhan

--câu 2: đưa ra những bệnh nhân có tuổi cao nhất gồm mabn,hoten,tuoi
select mabn,hoten,year(getdate())-year(ngaysinh) as tuoi from benhnhan
where year(ngaysinh) = (select min(year(ngaysinh)) from benhnhan)

--cau3: viết hàm với tham số truyền vào là mabn, hàm trả về môt bảng gồm các thông tin:
--mabn,hoten,ngaysinh,gioitinh(là nam hoặc là nữ),tenkhoa,tenbv

create function ham(@mabn varchar(10))
returns @danhsach table(
						mabn varchar(10),
						hoten char(30),
						ngaysinh datetime,
						gioitinh char(5),
						tenkhoa char(30),
						tenbv char(30)
						)
as
	begin
		insert into @danhsach
		select mabn,hoten,ngaysinh,(case gioitinh when 1 then 'Nam' else 'Nữ' end )as gioitinh,tenkhoa,tenbv 
		from benhnhan inner join khoakham on benhnhan.makhoa = khoakham.makhoa
		inner join benhvien on benhvien.mabv = khoakham.mabv
		where mabn = @mabn
	return
	end

select * from dbo.ham('mabn 1')

--caau 4: tạo thủ tục xóa 1 khoa với mã khoa nhập từ bàn phím nếu chưa
--có thì thông báo

create proc xoa(@makhoa varchar(10))
as
begin
	if(not exists (select * from khoakham where makhoa = @makhoa))
		print 'khong ton tai ma khoa la ' + @makhoa
	else
		delete khoakham where makhoa = @makhoa
end
select * from khoakham
exec xoa 'makhoa0'
exec xoa 'makhoa 1'
select * from khoakham