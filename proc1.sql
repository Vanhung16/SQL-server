use BTCTC

/*ài tập 1, Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa, 
nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2 
trường hợp.*/create proc them_khoa(@makhoa varchar(10), @tenkhoa char(30), @dienthoai char(12))as	begin			if(exists (select * from khoa where tenkhoa = @tenkhoa))			print 'ten khoa ' + @tenkhoa + ' da ton tai!'		else 			insert into khoa values (@makhoa,@tenkhoa,@dienthoai)	endselect * from khoaexec them_khoa '123','cntt','1234'/*Bài tập 2. Hãy viết thủ tục nhập dữ liệu cho bảng Lop với các tham biến Malop,
Tenlop, Khoa,Hedt,Namnhaphoc,Makhoa nhập từ bàn phím.
 - Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo
 - Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông 
báo
 - Nếu đầy đủ thông tin thì cho nhập*/
create proc nhapdulieu(@malop varchar(10),@tenlop char(30),@tenkhoa char(30),@hedt char(12),@namnhaphoc int,@makhoa varchar(10))
as
	begin
		if(exists (select * from lop where tenlop = @tenlop))
			print 'ten lop ' + @tenlop +' da ton tai'
		
			if(not exists (select * from khoa where makhoa = @makhoa))
				print 'ma khoa ' + @makhoa + ' khong ton tai'
			else
				insert into lop values( @malop,@tenlop,@hedt,@namnhaphoc,@makhoa)
	end

SELECT * FROM LOP
 SELECT * FROM khoa
 EXEC nhapdulieu '1','TIN22','2','DH','2011','123'
 /*Bài tập 3, Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến: 
makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa, 
nếu đã tồn tại trả về giá trị 0, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2 
trường hợp.*/
alter proc nhapdulieukhoa(@makhoa varchar(10),@tenkhoa char(30), @dienthoai int, @KQ int output)
as
	begin	
		if(exists (select * from khoa where tenkhoa = @tenkhoa))
			set @KQ =0
		else 
			insert into khoa values (@makhoa,@tenkhoa,@dienthoai)
	end
declare @check int
select * from khoa
exec nhapdulieukhoa '1','abc',123,@check
select @check

/*Bài tập 4. Hãy viết thủ tục nhập dữ liệu cho bảng lop với các tham biến 
malop,tenlop,khoa,hedt,namnhaphoc,makhoa.
 - Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0.
 - Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì tra ve 
1.
 - Nếu đầy đủ thông tin thì cho nhập và trả về 2*/
alter proc nhaplop(@malop varchar(10),@tenlop char(30),@tenkhoa char(30), @hedt char(12), @namnhaphoc int, @makhoa varchar(10), @KQ int output)
 as
	begin
		if(exists (select * from lop where tenlop = @tenlop))
			set @KQ = 0
		else
			if( not exists (select * from khoa where makhoa = @makhoa))
				set @KQ = 1
			else
			insert into lop values( @malop,@tenlop,@hedt,@namnhaphoc,@makhoa)
				set @KQ = 2
	return @KQ
	end
declare @loi int
exec nhaplop '1','cntt','dsa','dsa',1,'dsa', @loi output
select * from lop
select @loi