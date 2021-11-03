/*
Created		3/11/2021
Modified		3/11/2021
Project		
Model			
Company		
Author		
Version		
Database		MS SQL 2005 
*/
create database a
use a

Create table [KHACHHANG]
(
	[MaKH] Integer Identity NOT NULL,
	[TenKH] Nvarchar(30) NOT NULL,
Primary Key ([MaKH])
) 
go

Create table [HOADON]
(
	[SoHD] Integer Identity NOT NULL,
	[Ngay] Datetime Default getdate() NOT NULL,
	[MaKH] Integer NOT NULL,
Primary Key ([SoHD])
) 
go

Create table [HANG]
(
	[MaHang] Integer Identity NOT NULL,
	[TenHang] Nvarchar(85) NOT NULL,
Primary Key ([MaHang])
) 
go

Create table [CHITIETHOADON]
(
	[MaHang] Integer NOT NULL,
	[SoHD] Integer NOT NULL,
	[SoLuong] Decimal(10,2) NOT NULL Check (SoLuong>0),
Primary Key ([MaHang],[SoHD])
) 
go


Alter table [HOADON] add  foreign key([MaKH]) references [KHACHHANG] ([MaKH])  on update no action on delete no action 
go
Alter table [CHITIETHOADON] add  foreign key([SoHD]) references [HOADON] ([SoHD])  on update no action on delete no action 
go
Alter table [CHITIETHOADON] add  foreign key([MaHang]) references [HANG] ([MaHang])  on update no action on delete no action 
go


Set quoted_identifier on
go


Set quoted_identifier off
go


