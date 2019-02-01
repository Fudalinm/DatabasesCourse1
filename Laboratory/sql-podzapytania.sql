--- cwiczenie 1

--- zad 1

use northwind
select C.CompanyName, C.Phone
from Customers C
where C.CustomerID in
		(select distinct CustomerID
		 from Orders
		 where ShipVia = (select ShipperID from Shippers where CompanyName = 'United Package')
		)
		
--- zad 2

use northwind
select distinct C.CompanyName, C.Phone
from Customers C
	 join Orders O on C.CustomerID = O.CustomerID
	 join [Order Details] OD on OD.OrderID = O.OrderID
	 join Products P on P.ProductID = P.ProductID

where P.CategoryID = (select CategoryID from Categories where CategoryName = 'Confections')

-- zad 3

use northwind
select distinct C.CompanyName, C.Phone
from Customers C
where C.CustomerID not in

( select O.CustomerID
	from Orders O
		 join [Order Details] OD on OD.OrderID = O.OrderID
	     join Products P on P.ProductID = P.ProductID
	     join Categories CAT on CAT.CategoryID = P.CategoryID
	where CAT.CategoryName = 'Confections')
	
--- �wiczenie nr 2

-- zad 1

use northwind
select 
(select max(Quantity) from [Order Details] OD
 where OD.ProductID = P.ProductID) as maxQuantity, *
from Products P

-- zad 2

use northwind
select  * from Products
where UnitPrice < (select avg(UnitPrice) from Products)

--- zad 3

use northwind
select * from Products P
where UnitPrice < 
	(select avg(UnitPrice) from Products
	 where CategoryID = P.CategoryID)


--- zad 4 (1)

use northwind
select ProductName, UnitPrice,
(select avg(UnitPrice) as 'avg all' from Products),
abs((select avg(UnitPrice) from Products) - UnitPrice)
from Products

--- zad 5 (2)

use northwind
select CategoryName, ProductName, UnitPrice,
(select avg(UnitPrice) from Products
   where CategoryID = P.CategoryID),
   abs((select avg(UnitPrice) from Products
   where CategoryID = P.CategoryID) - UnitPrice)
from Products P
	join Categories C on P.CategoryID = C.CategoryID


--- �wiczenie nr 3

-- zad 1
use northwind
select 
(
	select sum(UnitPrice * Quantity * (1 - Discount)) 
	from [Order Details] 
	where OrderID = 10251
) + (
	select Freight
	from Orders
	where OrderID = 10251
)

-- zad 2

use northwind
select 
(
	select isnull(sum(UnitPrice * Quantity * (1 - Discount)), 0) 
	from [Order Details] 
	where OrderID = O.OrderID
) + Freight as total, *

from Orders O

--- zad 3

select * from Customers C
where not exists 
(select OrderID from Orders 
 where CustomerID = C.CustomerID and YEAR(OrderDate) = '1997')
 
 --- zad 4
 
 select distinct P.ProductID
 from Products P
 join [Order Details] OD on OD.ProductID = P.ProductID
 join Orders O on OD.OrderID = O.OrderID
 where exists
 (select ProductID
 from [Order Details] OD
 join Orders O2 on OD.OrderID = O2.OrderID
 where ProductID = P.ProductID and O2.CustomerID <> O.CustomerID) 
 
 
 -- �wiczenie nr 4
 
 -- zad 1
 
 select FirstName, LastName, 
	((
		select sum(UnitPrice * Quantity * (1-Discount))
		from Orders O
			join [Order Details] OD on O.OrderID = OD.OrderID
		where O.EmployeeID = E.EmployeeID
			
	)	
	+
	(select sum(Freight) from Orders
		where EmployeeID = E.EmployeeID
	) )			
   as total
 from Employees E
 

 -- zad 1
 
 select top 1 FirstName, LastName, 
	((
		select sum(UnitPrice * Quantity * (1-Discount))
		from Orders O
			join [Order Details] OD on O.OrderID = OD.OrderID
		where O.EmployeeID = E.EmployeeID
				and YEAR(OrderDate) = '1997'
	)	
	+
	(select sum(Freight) from Orders
		where EmployeeID = E.EmployeeID
			and YEAR(OrderDate) = '1997'
	) )			
   as total
 from Employees E
 order by 3 desc

--- zad 3

 select FirstName, LastName, 
	((
		select sum(UnitPrice * Quantity * (1-Discount))
		from Orders O
			join [Order Details] OD on O.OrderID = OD.OrderID
		where O.EmployeeID = E.EmployeeID
			
	)	
	+
	(select sum(Freight) from Orders
		where EmployeeID = E.EmployeeID
	) )			
   as total
 from Employees E
 
 where EmployeeID in
 
 (select EmployeeID from Employees EE where exists
      (select EmployeeID from Employees where ReportsTo = EE.EmployeeID))
      
 --- b) zmieni� exists na not exists
 
 --- zad 4
 
  select FirstName, LastName, 
	((
		select sum(UnitPrice * Quantity * (1-Discount))
		from Orders O
			join [Order Details] OD on O.OrderID = OD.OrderID
		where O.EmployeeID = E.EmployeeID
			
	)	
	+
	(select sum(Freight) from Orders
		where EmployeeID = E.EmployeeID
	) )			
   as total,
   
   (select top 1 ShippedDate from Orders
		where EmployeeID = E.EmployeeID
		order by 1 desc
   ) as last
   
 from Employees E
 
 where EmployeeID in
 
 (select EmployeeID from Employees EE where exists
      (select EmployeeID from Employees where ReportsTo = EE.EmployeeID))
      