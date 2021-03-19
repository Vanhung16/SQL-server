create database QLTHUOC
USE QLTHUOC

CREATE TABLE nsx(
mansx varchar(10) not null primary key,
tennsx char(30),
dc char(30),
dt int
)
create table thuoc(
mathuoc varchar(10) not  null primary key,
tenthuoc char(30),
slco int,
solo int,
ngaysx datetime,
hansudung int,
mansx varchar(10),
foreign key (mansx) references nsx(mansx) on update cascade on delete cascade
)
create table pn(
sopn int not null,
mathuoc varchar(10) not null,
ngaynhap datetime,
soluong int,
dongia money,
primary key(sopn,mathuoc),
foreign key (mathuoc) references thuoc(mathuoc) on update cascade on delete cascade
)
--insert data
insert into nsx values ('mansx 1','ten nsx 1','dia chi 1',123),
						('mansx 2','ten nsx 2','dia chi 2',1234),
						('mansx 3','ten nsx 3','dia chi 3',12345)
insert into thuoc values('mathuoc 1','tenthuoc 1',500,3,'12/12/2019',24,'mansx 1'),
						('mathuoc 2','tenthuoc 2',400,3,'11/12/2019',12,'mansx 2'),
						('mathuoc 3','tenthuoc 3',600,3,'9/12/2019',36,'mansx 3'),
						('mathuoc 4','tenthuoc 4',200,3,'3/12/2019',5,'mansx 1')
insert into pn values(1,'mathuoc 1','1/1/2020',300,5000),
					(2,'mathuoc 2','1/2/2020',300,1000),
					(3,'mathuoc 3','1/3/2020',300,3000),
					(4,'mathuoc 4','1/4/2020',300,1000),
					(5,'mathuoc 3','1/5/2020',300,2000),
					(6,'mathuoc 2','1/6/2020',300,1000)
--
select * from nsx
select * from thuoc
select * from pn
--cau 2: tạo 1 hàm đưa ra tổng số lượng nhập của từng mặt hàng nhập từ bàn phím
--tạo một hàm thống kê loại thuốc quá hạn
create function tong(@mathuoc varchar(10))
returns int
as
begin	
	declare @tong int;
	select @tong = sum(pn.soluong)
	from pn
	where mathuoc = @mathuoc
	group by mathuoc
return @tong
end

select dbo.tong('mathuoc 1') as N'tổng'

create function thuochethan()
returns @danhsach table(
						mathuoc varchar(10),
						tenthuoc char(30)
						)
as
	begin
		insert into @danhsach
		select mathuoc,tenthuoc from thuoc
		where 	hansudung <  (month(getdate()) - month(ngaysx)) 
	return
end

select * from dbo.thuochethan ()
--câu 3:tạo thủ tục thêm 1  nhà sản xuất với mã NSX nhập từ bàn phím. nếu mã đã có thì thông báo, 


create proc them_nsx(@mansx varchar(10),@tennsx char(30),@dc char(30),@dt int)
as
begin
	if(exists (select * from nsx where mansx = @mansx))
			print 'da co nha san xuat co ma la ' + @mansx
	else
			insert into nsx values (@mansx ,@tennsx ,@dc ,@dt )
end

select * from nsx
exec them_nsx 'mansx 1','tennsx 1','dc 1',1234
exec them_nsx 'mansx 4','tennsx 1','dc 1',1234
select * from nsx
-- tạo thủ tục tìm 1 thuốc với mã thuốc nhập từ bàn phím . nếu mã không có thì thông báo
create proc search_thuoc(@mathuoc varchar(10))
as
	begin
		if( not exists (select * from thuoc where mathuoc = @mathuoc))
			print 'khong ton tai thuoc co ma thuoc la ' + @mathuoc
		else
			select * from thuoc where mathuoc = @mathuoc
	end

exec search_thuoc 'mathuoc 1'