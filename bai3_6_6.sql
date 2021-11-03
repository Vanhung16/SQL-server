create database bai3
use bai3
--cau1
create table monhoc
(
mamon nvarchar(10) primary key,
tenmon nvarchar(30),
sotclt int,
sotcth int
)

create table sinhvien 
(
masv nvarchar(10) primary key,
hoten nvarchar(30),
ngaysinh date
)

create table dangky 
(
madk nvarchar(10) primary key,
masv nvarchar(10),
mamon nvarchar(10),
ngaydk date,
foreign key(masv) references sinhvien(masv) on update cascade on delete cascade,
foreign key(mamon) references monhoc(mamon) on update cascade on delete cascade
)
-- insert data
insert into monhoc values ('monhoc 01','CTDL-GT',2,1),
							('monhoc 02','PTDTYCPM',2,1),
							('monhoc 03','TRI TUE NHAN TAO',3,0)

insert into sinhvien values ('masv 01','NGUYEN VAN HUNG','11/10/2001'),
							('masv 02','NGUYEN NGOC HUNG','12/12/2001'),
							('masv 03','NGUYEN XUAN HOANG','1/1/2001')

INSERT INTO dangky values ('madk 01','masv 01','monhoc 01','7/7/2020'),
							('madk 02','masv 02','monhoc 02','7/7/2020'),
							('madk 03','masv 03','monhoc 03','7/7/2020'),
							('madk 04','masv 01','monhoc 02','7/7/2020'),
							('madk 05','masv 01','monhoc 03','7/7/2020')

select * from monhoc
select * from sinhvien
select * from dangky

--cau2: tạo hàm thống kê số sinh viên đăng kí môn học trước ngày x. 
--tên mh và x được nhập từ bàn phím

create function cau2(@ngay date, @tenmh nvarchar(30))
returns int
as
begin
	declare @tong int
	select @tong = count(DISTINCT masv)
	from dangky inner join monhoc on dangky.mamon = monhoc.mamon
	where ngaydk < @ngay and tenmon = @tenmh
	return @tong
end

select * from monhoc
select * from sinhvien
select * from dangky
select dbo.cau2('8/8/2020','TRI TUE NHAN TAO') as N'số sinh viên'

--CAU3: TẠO THỦ TỤC THÊM MỚI 1 DÒNG VÀO BẢNG ĐK VỚI MASV ,TENMH,NGAYDK
--NHẬP TỪ BÀN PHÍM. KIỂM TRA XEM TEENMH CÓ TRONG BẢNG MH HAY KO 
-- NẾU KO THÌ HIỂN THỊ THÔNG BÁO

CREATE PROC CAU3(@madk nvarchar(10),@masv nvarchar(10),@mamh nvarchar(30),@ngaydk date)
as
begin
	if(not exists (select mamon from monhoc where mamon = @mamh))
		begin
			print N' mã môn học có tên ' + @mamh + N' không tồn tại'
		end
	else
		begin
			insert into dangky values(@madk,@masv,@mamh,@ngaydk)
		end
end

select * from monhoc
select * from sinhvien
select * from dangky
exec CAU3 'madk 06','masv 02','monhoc 07','7/8/2020'

--cau4: TẠO TRIGGER KHI THÊM 1 DÒNG VÀO BẢNG ĐK. KTRA MÃ SINH VIÊN PHẢI
-- TỒN TẠI TRONG BẢNG SINHVIEN VÀ MAMH PHẢI TỒN TẠI TRONG BẢNG MONHOC
-- NẾU KHÔNG THÌ THÔNG BÁO

alter trigger cau4
on dangky
for insert
as
begin
	declare @masv nvarchar(10)
	select @masv = inserted.masv from sinhvien inner join inserted on sinhvien.masv = inserted.masv
	declare @mamh nvarchar(10)
	select @mamh = inserted.mamon from monhoc inner join inserted on monhoc.mamon = inserted.mamon
	if(not exists (select * from sinhvien where masv = @masv))
		begin
			raiserror(N' mã sinh viên không tồn tại',16,1)
			rollback transaction
		end
	else
		begin
			if(not exists (select * from monhoc where mamon = @mamh))
				begin
					raiserror(N' mã môn học không tồn tại',16,1)
					rollback transaction
				end
			print N'môn học đã được đăng kí'
		end	
end

select * from monhoc
select * from sinhvien
select * from dangky
insert into dangky values  ('madk 07','masv 04','monhoc 02','7/7/2020')