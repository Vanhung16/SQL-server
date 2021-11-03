create database Hang
use Hang

create table Hang(
mahang int,
tenhang nvarchar(20),
soluong int,
giaban money,
constraint pk_Hang_mahang primary key(mahang)
)

create table Hoadon(
mahd int,
mahang int, 
soluongban int,
ngayban datetime,
constraint pk_Hoadon_mahd primary key(mahd),
constraint fk_Hoadon_mahang foreign key(mahang) references Hang(mahang) on update cascade on delete cascade
)
insert into Hang values(1,'tenhang 1',5,100000)
insert into Hang values(2,'tenhang 2',100,1000000)
insert into Hoadon values(1,1,3,'12/2/2021')
/*Bài 1. Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn
tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
-- Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy
đưa ra thông báo.
-- Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongban
*/
create trigger chen
on Hoadon 
for insert
as
	begin
	if(not exists (select * from Hang inner join inserted on Hang.mahang = inserted.mahang))
		begin 
			raiserror('loi khong co hang',16,1)
			rollback transaction
		end
	else
		begin
			declare @soluong int
			declare @soluongban int
			select @soluong = soluong from Hang inner join inserted on Hang.mahang = inserted.mahang

			select @soluongban = inserted.soluongban from inserted

			if(@soluong < @soluongban)
				begin	
					raiserror('ban khong du hang',16,1)
					rollback transaction
				end
			else
				update Hang set soluong = soluong - @soluongban
				from Hang inner join inserted on Hang.mahang = inserted.mahang
		end
	end

	--test
	select * from Hang
	select * from Hoadon
	insert into Hoadon values(5,3,2,'2/9/1999')
	select * from Hang
	select * from Hoadon