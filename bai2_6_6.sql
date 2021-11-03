create database bai2
use bai2

create table vattu
(
mavt nvarchar(10) primary key,
tenvt nvarchar(30),
dvtinh nvarchar(5),
slcon int
)

create table hoadon
(
mahd nvarchar(10) primary key,
ngaylap date,
hotenkhach nvarchar(30)
)

create table cthoadon
(
mahd nvarchar(10),
mavt nvarchar(10),
dongiaban money,
slban int,
primary key(mahd,mavt),
foreign key (mahd) references hoadon(mahd) on update cascade on delete cascade,
foreign key (mavt) references vattu(mavt) on update cascade on delete cascade
)

--insert data
insert into vattu values ('mavt 1','sach','cuon',30),('mavt 2','but','chiec',50),('mavt 3','tay','chiec',50)

insert into hoadon values ('mahd 1','1/4/2020','xuan hoang'),('mahd 2','5/4/2020','hoang BG'),('mahd 3','1/6/2020','van hung')

insert into cthoadon values ('mahd 1','mavt 1',5000,2)
insert into cthoadon values ('mahd 2','mavt 2',2000,2)
insert into cthoadon values ('mahd 3','mavt 3',5000,7)
insert into cthoadon values ('mahd 1 ','mavt 2',2000,2)
insert into cthoadon values ('mahd 3','mavt 2',7000,4)

select * from vattu
select * from hoadon
select * from cthoadon

--cau2: tạo hàm đưa ra tổng tiền bán hàng của vật tư có tên vật tư và ngày tháng năm bán được nhập vào từ bàn phím.
-- tiền bán hàng = đơn giá bán * số lượng bán

create function cauthu2(@tenvt nvarchar(30),@ngay date)
returns money
as
begin
	declare @tongtien money
	select @tongtien = sum(cthoadon.dongiaban * slban)
	from cthoadon inner join vattu on cthoadon.mavt = vattu.mavt inner join hoadon on cthoadon.mahd = hoadon.mahd
	where tenvt = @tenvt and ngaylap = @ngay

	return @tongtien
end

select dbo.cauthu2('sach','1/4/2020') as 'tong tien'
--cau 3: hãy tạo thủ tục đưa ra tổng số lượng vật tư bán trong 
--tháng , năm  là bao nhiêu ?(với tham số truyền vào là tháng năm). chuỗi in ra như sau: tổng số lượng vật
--tư bán trong tháng 4-2020 là: 6

alter proc cau3(@thang int, @year int)
as
begin
	declare @tong int
	select @tong = sum(slban) from cthoadon inner join hoadon on hoadon.mahd = cthoadon.mahd
	where year(ngaylap) = @year and month(ngaylap) = @thang
	print concat(N'tổng số lượng vật tư bán trong tháng ' , @thang , ' - ' , @year , ' la: ' , @tong)
	
end

select * from vattu
select * from hoadon
select * from cthoadon
exec cau3 5,2020

--cau4: hãy tạo trigger để khi xóa dữ liệu  trong bảng cthoadon thì tăng số lượng còn trong bảng vật tư
--nếu dòng bị xóa là dòng duy nhất của hóa đơn thì hiển thị thông báo và không cho phép xóa.

alter trigger cau4
on cthoadon
for delete
as
begin
	declare @dem int
	select @dem = count(*) from cthoadon
	if(@dem < 2)
		begin
			raiserror ('warnning',16,1)
			rollback transaction
		end
	else
		begin
			update vattu set slcon = slcon + deleted.slban 
			from vattu inner join deleted on vattu.mavt = deleted.mavt
			where vattu.mavt = deleted.mavt
		end
end

select * from vattu
select * from cthoadon
delete from cthoadon where mavt = 'mavt 1'
select * from vattu
select * from cthoadon