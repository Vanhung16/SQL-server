use QLKHO

select*from Nhap
select*from Xuat
select*from Ton
/*Câu 2 (2đ): Hãy tạo View đưa ra thống kê tiền bán theo mã vật tư gồm MaVT, TênVT, TienBan (TienBan=SoLuongX*DonGiaX) 
(lưu ý: một mã vật tư có thể xuất nhiều lần).
*/
alter view thongke
as
select Ton.MaVT,Ton.TenVT,sum(xuat.SoLuongX*xuat.DonGiaX) as tienban
from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
group by Ton.MaVT,Ton.TenVT
select * from thongke