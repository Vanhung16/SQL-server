use BanHang;

--a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.

create function thongtinsp(@TenHang char(100))
returns @danhsach table (
						MaSP char(12),
						MaHangSX char(12),
						TenSP char(100),
						SoLuong int,
						MauSac char(10),
						GiaBan money,
						DonViTinh char(10),
						MoTa char(15)
						)
as 
begin
insert into @danhsach
select MaSP ,SanPham.MaHangSX ,	TenSP ,	SoLuong,MauSac,	GiaBan ,DonViTinh ,	MoTa from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
where HangSX.TenHang = @TenHang
return
end

select *from dbo.thongtinsp('TenHang1')
--b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập từ ngày x đến ngày y, với x,y nhập từ bàn phím.

create function danhsach(@x int, @y int)
returns @bang table(MaSP char(12),
					MaHangSX char(12),
					TenSP char(100),
					SoLuong int,
					MauSac char(10),
					GiaBan money,
					DonViTinh char(10),
					MoTa char(15),
					tenHang char(100),
					DiaChi char(15),
					SoDT int,
					Email char(100)
					)
as
begin
insert into @bang
select SanPham.MaSP ,SanPham.MaHangSX ,TenSP ,SoLuong ,	MauSac ,GiaBan ,DonViTinh ,	MoTa ,tenHang ,	DiaChi ,SoDT ,Email 
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX 
	inner join Nhap on SanPham.MaSP = Nhap.MaSP
	inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
where day(PNhap.NgayNhap) between @x and @y
return
end

select * from dbo.danhsach(1,2)
/*c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn
=1 thì Đưa ra danh sách các sản phẩm có SoLuong >0.*/

Create Function fn_DSSPTheoSL(@TenHang char(100), @Flag int)
Returns @bang Table (
 MaSP char(12),
 TenSP char(100),
 TenHang char(100), 
 SoLuong int,
 MauSac char(10),
 GiaBan money,
 DonViTinh char(10),
 MoTa char(15)
 )
As
Begin
 If(@flag=0)
 Insert Into @bang
 Select MaSP,TenSP,TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
 From SanPham Inner join HangSX
 on SanPham.MaHangSX = HangSX.MaHangSX
 Where TenHang = @TenHang And SoLuong=0
 Else
 If(@flag =1)
 Insert Into @bang
 Select MaSP,TenSP,TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
 From SanPham Inner join HangSX
 on SanPham.MaHangSX = HangSX.MaHangSX
 Where TenHang = @TenHang And SoLuong >0
 Return
End

select *from fn_DSSPTheoSL('TenHang1',0)

--d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.

create function dsnhanvien(@TenPhong char(100))
returns @bang table(
					MaNV char(12),
					tenNV char(100),
					GioiTinh char(10),
					DiaChi char(15),
					SoDT int,
					Email char(100),
					TenPhong char(100)
					)
as 
begin
insert into @bang
select MaNV, TenNV, GioiTinh,DiaChi,SoDT,Email,TenPhong
from NhanVien
Where TenPhong = @TenPhong
return
end

select * from dbo.dsnhanvien('TenPhong1')
--e. Hãy tạo hàm Đưa ra danh sách các hãng sản xuất có địa chỉ nhập vào từ bàn phím (Lưu ý – Dùng hàm Like để lọc)

create function dshsx(@DiaChi char(15))
returns @bang table(
					MaHangSX char(12),
					TenHang char(100),
					DiaChi char(15),
					SoDT int,
					Email char(100)
					)
as
begin
insert into @bang
select MaHangSX,TenHang,DiaChi,SoDT,Email
from HangSX
where DiaChi = @Diachi
return
end

select * from dbo.dshsx('DiaChi1')
--f. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được xuất từ năm x đến năm y, với x,y nhập từ bàn phím.

create function dsspvahsx(@nam1 int, @nam2 int)
returns @bang table(
					MaSP char(12),
					tenSP char(100),
					SoLuong int,
					MauSac char(10),
					GiaBan money,
					MaHangSX char(12),
					tenHang char(100),
					DiaChi char(15),
					SoLuongX int
					)
as 
begin 
insert into @bang
select SanPham.MaSP,TenSP,SoLuong,MauSac,GiaBan,HangSX.MaHangSX,TenHang,DiaChi,SoLuong
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
inner join Xuat on Xuat.MaSP = SanPham.MaSP
inner join PXuat on PXuat.SoHDX = Xuat.SoHDX
where year(PXuat.NgayXuat) between @nam1 and @nam2
return
end

select*from dbo.dsspvahsx(2001,2015)

/*g. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa chọn =1
thì Đưa ra danh sách các sản phẩm đã được xuất.
*/

create function dssptheohsx(@TenHang char(100), @luachon int)
returns @bang table(
					MaSP char(12),
					MaHangSX char(12),
					TenSP char(100),
					SoLuong int,
					MauSac char(10),
					MoTa char(100),
					TenHang char(100)
					)
as
begin 
if(@luachon = 0)
insert into @bang
select SanPham.MaSP,HangSX.MaHangSX,TenSP,SoLuong,MauSac,MoTa,TenHang
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	inner join Nhap on Nhap.MaSP = SanPham.MaSP
where TenHang = @TenHang
else 
if(@luachon = 1)
insert into @bang
select  SanPham.MaSP,HangSX.MaHangSX,TenSP,SoLuong,MauSac,MoTa,TenHang
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	inner join Xuat on SanPham.MaSP = Xuat.MaSP
where TenHang = @TenHang
return
end

select *from dbo.dssptheohsx('TenHang1',0)
select *from dbo.dssptheohsx('TenHang2',1)
--h. Hãy xây dựng hàm Đưa ra danh sách các nhân viên đã nhập hàng vào ngày được đưa vào từ bàn phím.

create function ds_nhanvien_nhaphang(@ngay datetime)
returns @bang table(
					MaNV char(12),
					TenNV char(100),
					GioiTinh char(10),
					DiaChi char(15),
					SoDT int,
					Email char(100),
					TenPhong char(100)
					)
as
begin
insert into @bang
select NhanVien.MaNV,TenNV,GioiTinh,DiaChi,SoDT,Email,TenPhong 
from NhanVien inner join PNhap on NhanVien.MaNV=PNhap.MaNV
where PNhap.NgayNhap = @ngay
return 
end

select * from dbo.ds_nhanvien_nhaphang('1/1/2001')
--i. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm có giá bán từ x đến y, do hãng z sản xuất, với x,y,z nhập từ bàn phím.

create function ds_sanphamgiatri(@x money,@y money,@tenhang char(100))
returns @bang table(
					MaSP char(12),
					MaHangSX char(15),
					TenSP char(100),
					SoLuong int,
					GiaBan money,
					DonViTinh char(10),
					MoTa char(15)
					)
as
begin
insert into @bang
select MaSP,HangSX.MaHangSX,TenSP,SoLuong,GiaBan,DonViTinh,MoTa
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
where TenHang = @TenHang and GiaBan between @x and @y 
return
end

select *from dbo.ds_sanphamgiatri(1,2,'TenHang1')
--j. Hãy xây dựng hàm không tham biến Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng.

create function ds_sanpham_va_HSX()
returns @bang table(
					MaSP char(10),
					TenSP char(100),
					SoLuonng int,
					MauSac char(10),
					GiaBan money,
					DonViTinh char(10),
					MoTa char(100),
					MaHangSX char(12),
					TenHang char(100),
					DiaChi char(100)
					)
as
begin
insert into @bang
select SanPham.MaSP,TenSP,SoLuong,MauSac,GiaBan,DonViTinh,MoTa,HangSX.MaHangSX,TenHang,DiaChi
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
return 
end

select * from  ds_sanpham_va_HSX()