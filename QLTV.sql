create database QLTV
use QLTV
create table sach(
masach nvarchar(10) not null,
tensach char(30) not null,
sotrang int not null,
slton int not null,
constraint pk_sach_masach primary key (masach)
)

create table pm(
mapm nvarchar(10) not null,
ngaym datetime not null,
hotendg char(30) not null,
constraint pk_pm_mapm primary key (mapm)
)

create table sachmuon(
mapm nvarchar(10) not null,
masach nvarchar(10) not null,
songaymuon int not null,
constraint pk_sachmuon primary key(mapm, masach),
constraint fk_sachmuon_mapm foreign key (mapm) references pm(mapm) on update cascade on delete cascade,
constraint fk_sachmuon_masach foreign key (masach) references sach(masach) on update cascade on delete cascade
)
--insert data
insert into sach values ('masach 1','tensach 1',50,15),('masach 2','tensasch 2',72,50)

insert into pm values('mapm 1','1/1/2019','Van Hung'),('mapm 2','03/1/2021','Hung Nguyen')

insert into sachmuon values ('mapm 1','masach 1',50),('mapm 2','masach 2',100),('mapm 1','masach 2',1000),('mapm 2','masach 1',20)

select * from sach
select * from pm
select * from sachmuon

--cau 2:
create view cau2
as
	select sach.masach,hotendg,pm.ngaym,(pm.ngaym + songaymuon) as ngaytra
	from sach inner join sachmuon on sach.masach = sachmuon.masach
	inner join pm on pm.mapm = sachmuon.mapm

select * from cau2
--cau 3:
alter function cau3(@masach nvarchar(10))
returns int
as
	begin 
	declare @tong int
	select @tong = count(masach)
	from pm inner join sachmuon on pm.mapm=sachmuon.mapm
	where songaymuon < (getdate()-day(ngaym)) and masach = @masach
	return @tong
	end

select dbo.cau3('masach 1') as tong


select * from sach
select * from pm
select * from sachmuon

select * from cau2

select dbo.cau3('masach 2') as tong