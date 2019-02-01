
--------Cwiczenie 1-----

--1. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma United Package.
--Bez podzapytania
USE Northwind
Select DISTINCT Customers.CompanyName, Customers.Phone
from customers
inner join orders on Orders.CustomerID=Customers.CustomerID and year(OrderDate) =  1997
inner join Shippers on ShipVia=shippers.ShipperID
where Shippers.CompanyName like 'United Package'

--z podzapytaniem
SELECT DISTINCT CompanyName, Phone
FROM Customers
where exists( SELECT * FROM Orders WHERE Orders.CustomerID=Customers.CustomerID and year(OrderDate) =  1997 AND
        exists( SELECT * FROM Shippers WHERE Orders.ShipVia=Shippers.ShipperID and Shippers.CompanyName like 'United Package' )
)

--1. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma United Package.
--Z podzapytaniem

select CompanyName, phone
from Customers
where
  exists (select * from Orders where Orders.CustomerID=Customers.CustomerID AND year(OrderDate)=1997
                                     and
  exists(select * from Shippers where Shippers.ShipperID=Orders.ShipVia and  Shippers.CompanyName like 'United Package'))

--2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections..
--bez podzapytania

SELECT DISTINCT CompanyName, Phone
FROM Customers
INNER JOIN Orders on Orders.CustomerID = Customers.CustomerID --dlaczego dolozenie tego joina generuje dodatkowe wiersze
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID and CategoryName = 'Confections'

--2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections..
--z podzapytaniem

SELECT CompanyName, Phone
FROM Customers
where
  exists (
      SELECT * FROM Orders WHERE Orders.CustomerID = Customers.CustomerID  AND
         exists (
             SELECT * FROM [Order Details] WHERE Orders.OrderID = [Order Details].OrderID AND
               exists (
                   SELECT * FROM Products WHERE [Order Details].ProductID = Products.ProductID AND
                     exists (
                         SELECT * FROM Categories WHERE Products.CategoryID = Categories.CategoryID and CategoryName = 'Confections'))))



--3. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections..
--bey podyapztan TUTAJ COS NIE DZIALA
SELECT DISTINCT CompanyName, Phone
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products on [Order Details].ProductID = Products.ProductID
LEFT outer JOIN Categories on Products.CategoryID = Categories.CategoryID and CategoryName = 'Confections'
and Categories.CategoryID is NUll


--3. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections..
--z podzapytaniami

SELECT CompanyName, Phone
FROM Customers
WHERE
  NOT exists( SELECT * FROM Orders WHERE Customers.CustomerID= orders.CustomerID AND
    exists( SELECT * FROM [Order Details] WHERE Orders.OrderID = [Order Details].OrderID AND
      exists( SELECT * FROM Products WHERE [Order Details].ProductID = Products.ProductID AND
        exists( SELECT * FROM Categories WHERE Categories.CategoryID = Products.CategoryID and CategoryName = 'Confections'
        )
      )
    )
  )

--inny sposob po prostu nie jest z tego co wypisalismy wczoesniej
select * from Customers where customerID not in (
  SELECT DISTINCT CustomerID
  FROM orders
    INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
    INNER JOIN products ON [Order Details].ProductID = Products.ProductID
    LEFT OUTER JOIN Categories ON Products.CategoryID = Categories.CategoryID
  WHERE CategoryName LIKE 'Confections'
)

-------Ćwiczenie 2-------
--1. Dla każdego produktu podaj maksymalną liczbę zamówionych
--jednostek

--bez podzapytania
select ProductName, max(quantity) as 'max order'
from Products
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by ProductName


--z podzapytaniem

SELECT ProductName, max(jeb) as 'max order'
from (
  SELECT ProductName, [Order Details].quantity as jeb
  FROM Products
  INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
) as jab
GROUP BY jab.ProductName


--2. Podaj wszystkie produkty których cena jest mniejsza niż średnia
--cena produktu
--bez podzapytania

--HOW JUST HOW????

SELECT ProductName, Sum(UnitPrice), COUNT(ProductID)
FROM Products
GROUP BY ProductName WITH ROLLUP
having 

--z podzapytaniem
SELECT ProductName
FROM Products as AB
where AB.UnitPrice < (Select AVG(UnitPrice) FROM Products)


--3. Podaj wszystkie produkty których cena jest mniejsza niż średnia
--cena produktu danej kategorii

--jak bez podzapytania

--z podzapytaniem
SELECT ProductName
FROM Products as AB
  INNER JOIN Categories as JO ON AB.CategoryID = JO.CategoryID
where UnitPrice <
      ( SELECT AVG(UnitPrice)
        FROM Products as AC
        INNER JOIN Categories as AL ON AC.CategoryID = AL.CategoryID and JO.CategoryID = AC.CategoryID )


-----------Ćwiczenie 3
--1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę
--wszystkich produktów oraz różnicę między ceną produktu a średnią
--ceną wszystkich produktów

--jak bez podzapytania



--z podzapytaniem
SELECT ProductName,UnitPrice, (SELECT AVG(UnitPrice) FROM Products) as 'avg_price', (UnitPrice - (SELECT AVG(UnitPrice) FROM Products)) as różnica
FROM Products

--2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu,
--cenę, średnią cenę wszystkich produktów danej kategorii oraz
--różnicę między ceną produktu a średnią ceną wszystkich produktów
--danej kategorii

--bez podzapytania nie mam pojecia jak


--z podzapytaniem
SELECT ProductName, AC.CategoryName,
  (SELECT AVG(UnitPrice)
   FROM Products as BB
     INNER JOIN Categories as BC ON BB.CategoryID = BC.CategoryID and AC.CategoryID = BC.CategoryID) as srednia_cena,
  AB.UnitPrice - (SELECT AVG(UnitPrice)
   FROM Products as BB
     INNER JOIN Categories as BC ON BB.CategoryID = BC.CategoryID and AC.CategoryID = BC.CategoryID) as roznica
  FROM Products as AB
INNER JOIN Categories as AC ON AB.CategoryID = AC.CategoryID

-------------Ćwiczenie 4
--1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij
--cenę za przesyłkę)

--bez podzapytania
SELECT Sum((Quantity*UnitPrice)*(1-Discount)+Orders.Freight) as suma_zamowienia
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID and Orders.OrderID=10250

--z podzapytaniem nie mozna wnawiasowac selecta do funkcji agregujacej
SELECT Sum((Quantity*UnitPrice)*(1-Discount))+ (SELECT Freight FROM Orders as BB WHERE AB.OrderID=BB.OrderID) as suma_zamowienia
FROM [Order Details] as AB
WHERE AB.OrderID=10250
GROUP BY AB.OrderID

--2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij
--cenę za przesyłkę)

--bez podzapytania
SELECT Sum((Quantity*UnitPrice)*(1-Discount)+Orders.Freight) as suma_zamowienia
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
GROUP BY Orders.OrderID

--z podzapytaniem

SELECT Sum((Quantity*UnitPrice)*(1-Discount))+ (SELECT Freight FROM Orders as BB WHERE AB.OrderID=BB.OrderID) as suma_zamowienia
FROM [Order Details] as AB
GROUP BY AB.OrderID

--3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997
--roku, jeśli tak to pokaż ich dane adresowe

--bez podzapytania
SELECT Customers.Address
FROM Customers
left OUTER JOIN Orders on Customers.CustomerID = Orders.CustomerID and year(OrderDate) = 1997
WHERE OrderDate is NULL

--z podzapytaniem
SELECT Customers.Address
FROM Customers
WHERE Customers.Address not IN (
  SELECT Customers.Address
  FROM Customers
  INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID and year(OrderDate)=1997
)
--podzapytanie bez zadnego joina
SELECT Customers.Address
FROM Customers
WHERE Customers.CustomerID not IN (
  SELECT CustomerID
  FROM Orders
  WHERE year(OrderDate)=1997
)


--4. Podaj produkty kupowane przez więcej niż jednego klienta

--bez podzapytania
SELECT ProductName
FROM Products
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
GROUP BY ProductName
HAVING  COUNT(Orders.CustomerID) > 1

--z podzapytaniem


SELECT ProductName
FROM Products
WHERE ProductName IN (SELECT ProductName
                        FROM Products
                        INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
                        INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
                        GROUP BY ProductName
                        HAVING COUNT(Orders.CustomerID) >1
)



---------Ćwiczenie 5-----
--1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
--zamówień obsłużonych przez tego pracownika (przy obliczaniu
--wartości zamówień uwzględnij cenę za przesyłkę

--bez podzapytania
SELECT LastName, FirstName,
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY LastName, FirstName

--z podzapytaniem


SELECT LastName, Firstname,
  (SELECT sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight)
  FROM [Order Details]
    INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID AND A.EmployeeID=Orders.EmployeeID
    GROUP BY Orders.EmployeeID
  )
FROM Employees as A
ORDER BY LastName, FirstName

--2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia
--o największej wartości) w 1997r, podaj imię i nazwisko takiego
--pracownika

--bez podzapytania
SELECT top 1 LastName, FirstName
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID and year(OrderDate)=1997
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY LastName, FirstName
ORDER BY  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) DESC

--z podzapytaniem
SELECT top 1 LastName, Firstname
FROM Employees as A
ORDER BY (SELECT sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight)
  FROM [Order Details]
    INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID AND A.EmployeeID=Orders.EmployeeID and YEAR(OrderDate) = 1997
    GROUP BY Orders.EmployeeID
  ) DESC

--3. Ogranicz wynik z pkt 1 tylko do pracowników
--a) którzy mają podwładnych
--bez podzapytania

SELECT A.LastName, A.FirstName,
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees as A
INNER JOIN Orders ON A.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
  INNER JOIN Employees as B ON B.ReportsTo=A.EmployeeID
GROUP BY A.LastName, A.FirstName

--z podzapytaniami

SELECT LastName, Firstname,
  (SELECT sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight)
  FROM [Order Details]
    INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID AND A.EmployeeID=Orders.EmployeeID
    GROUP BY Orders.EmployeeID
  )
FROM Employees as A
  WHERE exists(SELECT * FROM Employees as B WHERE A.EmployeeID=B.ReportsTo)
ORDER BY LastName, FirstName



--b-) którzy nie mają podwładnych
--bez podzapytania

SELECT A.LastName, A.FirstName,
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees as A
INNER JOIN Orders ON A.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
  LEFT OUTER JOIN Employees as B ON B.ReportsTo=A.EmployeeID
  WHERE B.ReportsTo is NULL
GROUP BY A.LastName, A.FirstName

--z podzapytaniem

SELECT LastName, Firstname,
  (SELECT sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight)
  FROM [Order Details]
    INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID AND A.EmployeeID=Orders.EmployeeID
    GROUP BY Orders.EmployeeID
  )
FROM Employees as A
  WHERE A.EmployeeID IN
        (SELECT B.EmployeeID FROM Employees as B LEFT OUTER JOIN Employees as C on C.ReportsTo = B.EmployeeID where C.ReportsTo is NULL )
ORDER BY LastName, FirstName

--4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać
--jeszcze datę ostatnio obsłużonego zamówienia z podzapytaniem

--tu mamy z podzapytaniami
SELECT A.LastName, A.FirstName,(SELECT top 1 OrderDate FROM Orders as C where A.EmployeeID=C.EmployeeID ORDER BY OrderDate DESC ),
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees as A
INNER JOIN Orders ON A.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
  INNER JOIN Employees as B ON B.ReportsTo=A.EmployeeID
GROUP BY A.LastName, A.FirstName, A.EmployeeID


SELECT A.LastName, A.FirstName,(SELECT top 1 OrderDate FROM Orders as C where A.EmployeeID=C.EmployeeID ORDER BY OrderDate DESC ),
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees as A
INNER JOIN Orders ON A.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
  LEFT OUTER JOIN Employees as B ON B.ReportsTo=A.EmployeeID
  WHERE B.ReportsTo is NULL
GROUP BY A.LastName, A.FirstName, A.EmployeeID

--jak bez podzapytan

SELECT A.LastName, A.FirstName, max(OrderDate),
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees as A
INNER JOIN Orders ON A.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
  INNER JOIN Employees as B ON B.ReportsTo=A.EmployeeID
GROUP BY A.LastName, A.FirstName, A.EmployeeID

SELECT A.LastName, A.FirstName,max(OrderDate),
  sum ( ([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount) + Orders.Freight) as Obsłuzone_zamowienia
FROM Employees as A
INNER JOIN Orders ON A.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
  LEFT OUTER JOIN Employees as B ON B.ReportsTo=A.EmployeeID
  WHERE B.ReportsTo is NULL
GROUP BY A.LastName, A.FirstName, A.EmployeeID





