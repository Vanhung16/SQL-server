use BanHang;

--a. Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
create function timhang(@MaSP char(12))
returns char(12)
as
begin
declare @ten char(12)
select @ten = HangSX.TenHang from SanPham inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
where MaSP = @MaSP
return @ten
end

select dbo.timhang('MaSP1') aS 'Tên Hàng'
--b. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, với x, y được nhập vào từ bàn phím
create function sum_enter(@x int, @y int)
returns int
as
begin
declare @tongtien int
select @tongtien = sum(Nhap.SoLuongN*Nhap.DonGiaN) from Nhap inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
where year(PNhap.NgayNhap) between @x and @y
return @tongtien
end

select dbo.sum_enter(2001,2019)
--c. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.
create function thongketongsoluong(@TenSP char(100),@nam int)
returns int
as
begin
declare @tongnhap int
declare @tongxuat int
declare @thaydoi int
	select @tongnhap = sum(Nhap.SoLuongN) from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
	where TenSP = @TenSP and year(PNhap.NgayNhap) = @nam
	select @tongxuat = sum(Xuat.SoLuongX) from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
	where TenSP = @TenSP and year(PXuat.NgayXuat) = @nam
	set @thaydoi = @tongnhap-@tongxuat
return @thaydoi
end

select dbo.thongketongsoluong('TenSP1',2001)


--d. Hãy xây dựng hàm Đưa ra tổng giá trị nhập từ ngày nhập x đến ngày nhập y, với x, y được nhập vào từ bàn phím.
create function thongketheongay(@x int, @y int)
returns int
as
begin
declare @tong int
select @tong = sum(Nhap.SoLuongN*Nhap.DonGiaN) from Nhap inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
where day(PNhap.NgayNhap) between @x and @y
return @tong
end
select*from Nhap
select*from PNhap
select dbo.thongketheongay(1,2)

--e. Hãy xây dựng hàm Đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm tài khóa x, với A, x được nhập từ bàn phím.

create function tongtheohang(@Tenhang char(100), @nam int)
returns int
as
begin
declare @tong int
select @tong = sum(Xuat.SoLuongX*
--f. Hãy xây dựng hàm thống kê số lượng nhân viên mỗi phòng với tên phòng nhập từ bàn phím.
create function thongkenhanvien(@TenPhong char(100))
returns @danhsach table (
						TenPhong char(100),
						sl int
						)
as
begin
insert into @danhsach
select NhanVien.TenPhong, count(NhanVien.MaNV) from NhanVien 
where NhanVien.TenPhong = @TenPhong
group by NhanVien.TenPhong
return
end

select * from dbo.thongkenhanvien('TenPhong1')
--g. Hãy viết hàm thống kê xem tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong ngày y, với x,y nhập từ bản phím.
create function thongkesanpham(@TenSP char(100), @ngay int)
returns int
as
begin
declare @tong int
select @tong = sum(Xuat.SoLuongX) from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
where SanPham.TenSP = @TenSP and day(PXuat.NgayXuat) = @ngay
return @tong
end
select * from SanPham
select * from PXuat
select dbo.thongkesanpham('TenSP1',2)
--h. Hãy viết hàm trả về số diện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ bàn phím.

create function duasdt(@SoHDX char(15) )
returns int
as
begin
declare @so int
select @so = NhanVien.SoDT from NhanVien inner join PXuat on NhanVien.MaNV = PXuat.MaNV
where PXuat.SoHDX = @SoHDX
return @so
end

select dbo.duasdt('SoHDX1')
--i. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.

create function thaydoinhapxuat(@TenSP char(100),@nam int)
returns int
as
begin
declare @tongnhap int
declare @tongxuat int
declare @thaydoi int
	select @tongnhap = sum(Nhap.SoLuongN) 
	from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP 
		inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
	where SanPham.TenSP = @TenSP and year(PNhap.NgayNhap) = @nam

	select @tongxuat = sum(Xuat.SoLuongX)
	from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
		inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
	where SanPham.TenSP = @TenSP and year(PXuat.NgayXuat) = @nam

	set @thaydoi = @tongnhap - @tongxuat
	return @thaydoi
end

select dbo.thaydoinhapxuat('TenSP1',2001)

--j. Hãy viết hàm thống kê tổng số lượng sản phầm của hãng x, với tên hãng nhập từ bàn phím

create function thongkesanpham1(@tenhang char(100))
returns int
as 
begin
declare @tong  int
select @tong = sum(SanPham.SoLuong) 
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
where HangSX.TenHang = @tenhang
group by HangSX.TenHang
return @tong
end

select dbo.thongkesanpham1('TenHang1')