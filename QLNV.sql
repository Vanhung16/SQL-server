create database QLNV;
use QLNV

create table chucvu(
maCV nvarchar(2) not null primary key,
tenCV nvarchar(30)
)
create table nhanvien(
maNV nvarchar(4) not null primary key,
maCV nvarchar(2) not null,
tenNV nvarchar(30),
ngaysinh datetime,
luongcanban float,
ngaycong int,
phucap float
foreign key (maCV) references chucvu(maCV)

)
insert into chucvu values ('BV','bao ve'),('GD','Giam doc'),('HC','Hanh Chinh'),('KT','Ke Toan'),('TQ','Thu Quy'),('VS','Ve Sinh')
select * from chucvu
insert into nhanvien values ('NV01','GD','Nguyen Van An','12/12/1977',700000,25,500000),
							('NV02','BV','Bui Van Ti','10/10/1978',400000,24,100000),
							('NV03','KT','Tran Thanh Nhat','9/9/1977',600000,26,400000),
							('NV04','VS','Nguyen Thi Ut','10/10/1980',300000,26,300000),
							('NV05','HC','Le Thi Ha','10/10/1979',500000,27,200000)
select * from nhanvien
/*a. Viết thủ tục SP_Them_Nhan_Vien, biết tham biến là MaNV, MaCV, 
TenNV,Ngaysinh,LuongCanBan,NgayCong,PhuCap. Kiểm tra MaCV có tồn tại 
trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho thêm nhân viên 
mới, nếu không thì đưa ra thông báo*/
alter proc SP_Them_Nhan_Vien(@manv nvarchar(4),@macv nvarchar(4), @tennv nvarchar(30),@ngaysinh datetime,@luongcanban float,@ngaycong int,@phucap float)
as 
	begin	
		if( not exists (select * from chucvu where maCV = @macv))
			print 'ma cong viec ' + @macv + ' khong ton tai'
		else
			insert into nhanvien values(@manv ,@macv , @tennv ,@ngaysinh ,@luongcanban ,@ngaycong ,@phucap )
	end

exec SP_Them_Nhan_Vien 'NV06','HC','Le Thi Ha','10/10/1979',500000,27,200000
exec SP_Them_Nhan_Vien 'NV07','BV','Le Thi Ha','10/10/1979',500000,27,200000
select * from nhanvien

/*b. Viết thủ tục SP_CapNhat_Nhan_Vien ( không cập nhật mã), biết tham biến là 
MaNV, MaCV, TenNV, Ngaysinh, LuongCanBan, NgayCong, PhuCap. Kiểm tra 
MaCV có tồn tại trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho 
cập nhật, nếu không thì đưa ra thông báo.*/create proc SP_CapNhat_Nhan_Vien(@manv nvarchar(4),@macv nvarchar(2),@tennv nvarchar(30),@ngaysinh datetime,@luongcanban float,@ngaycong int, @phucap float)as 	begin		if(exists (select * from chucvu where maCV = @macv))			update nhanvien set maCV = @macv, tenNV = @tennv, ngaysinh = @ngaysinh,luongcanban = @luongcanban,ngaycong = @ngaycong,phucap = @phucap			where maNV = @manv		else 			print 'khong ton tai ma cong viec la ' + @macv 	endselect * from nhanvienexec SP_CapNhat_Nhan_Vien 'NV01','GD','Nguyen Van Hung','11/16/2001',10000000,30,1000000select * from nhanvien/*c. Viết thủ tục SP_LuongLN với Luong=LuongCanBan*NgayCong + PhuCap, biết 3
thủ tục trả về, không truyền tham biến.*/
alter proc SP_LuongLN 
as 
	
	begin
		
		select  nhanvien.luongcanban*nhanvien.ngaycong + nhanvien.phucap  as luong from nhanvien
	
	end

exec dbo.SP_LuongLN 
