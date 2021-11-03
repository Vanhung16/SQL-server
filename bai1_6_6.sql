create database bai1
use bai1
create table congty(
mact nvarchar(10) primary key,
tenct nvarchar(30),
diachi nvarchar(30)
)

create table sanpham(
masp nvarchar(10) primary key,
tensp nvarchar(30),
slco int,
giaban money
)

create table cungung(
mact nvarchar(10),
masp nvarchar(10),
slcungung int,
primary key(mact,masp),
foreign key(mact) references congty(mact) on update cascade on delete cascade,
foreign key(masp) references sanpham(masp) on update cascade on delete cascade,
)

--insert data
insert into congty values('mact 1','tenct 1','hanoi'),('mact 2','tenct 2','hanam'),('mact 3','tenct 3','ung hoa')

insert into sanpham values('masp 1','tensp 1',15,1000),('masp 2','tensp 2',20,2000),('masp 3','tensp 3',30,3000)

insert into cungung values('mact 1','masp 1',10),('mact 2','masp 2',5),('mact 3','masp 3',5),('mact 1','masp 2',10),('mact 2','masp 1',5)

select * from congty
select * from sanpham
select * from cungung
--cau 2:tạo view đưa ra mã sp , tensp, slco,slcungung của các sp.
create view cau2
as
select  sanpham.masp ,tensp,slco,slcungung
from sanpham inner join cungung on sanpham.masp = cungung.masp

select * from cau2

--cau3: viết thủ tục thêm mới 1 công ty với mact, tenct,diachi nhập từ bàn phím,
--nếu tên ct đó tồn tại trước đó hãy hiển thị thông báo và trả về 1, ngược lại cho phép thêm mới và trả về 0

create proc cau3(@mact nvarchar(10),@tenct nvarchar(30),@diachi NVARCHAR(30), @kq INT output)
as
begin
	if(exists(select * from congty where tenct = @tenct))
		BEGIN
			print 'ten cong ty da ton tai'
			set @kq = 1
		END
	else
		BEGIN
			set @kq = 0
			insert into congty values(@mact,@tenct,@diachi)
		END
end

DECLARE @KQ INT 
SELECT * FROM congty
EXEC cau3 'mact 4','tenct 4','dongvu',@KQ output
SELECT @KQ as 'ketqua'
--cau4: tạo trigger update  trên bảng cungung cập nhật lại số lượng cung ứng, kiểm tra xem nếu số lượng cung ứng mới
-- -soluongcungung cũ  <= slco hay không? nếu thỏa mãn hãy cập nhật lại số lượng có trên bảng sanpham, ngược lại
-- đưa ra thông báo.

create trigger cau4
on cungung
for update
as
begin
	declare @soluongcungungmoi int
	declare @soluongcungungcu int
	declare @soluongco int
	declare @masp nvarchar(10)
	select @masp = inserted.masp from inserted
	select @soluongcungungmoi = inserted.slcungung from inserted inner join cungung on inserted.mact = cungung.mact
	select @soluongcungungcu = slcungung from cungung
	select @soluongco = slco from sanpham where masp = @masp
	if(@soluongcungungmoi - @soluongcungungcu > @soluongco)
		begin
			raiserror ('warnning',16,1)
			rollback transaction
		end
	else
		begin
			update sanpham set slco = @soluongco - (@soluongcungungmoi - @soluongcungungcu)
			from sanpham inner join inserted on sanpham.masp = inserted.masp
		end
end

select * from cungung
select * from sanpham
update cungung set slcungung = 10 where masp = 'masp 2'
select * from cungung
select * from sanpham
