USE Northwind
--1.Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klienta jednostek. MIAŁY BYĆ KATEGORIE
SELECT Products.ProductName, Customers.CompanyName, SUM([Order Details].Quantity)
FROM Products
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
  INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName, Products.ProductName

--2.Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek oraz nazwę klienta. OK

SELECT  Customers.CompanyName,[Order Details].OrderID, Sum([Order Details].Quantity)
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY  Customers.CompanyName, [Order Details].OrderID
ORDER BY CompanyName

--3.Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których łączna liczba jednostek jest większa niż 250.

SELECT  Customers.CompanyName,[Order Details].OrderID, Sum([Order Details].Quantity)
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY  Customers.CompanyName, [Order Details].OrderID
  HAVING Sum([Order Details].Quantity) > 250
ORDER BY CompanyName

--4.Dla każdego klienta (nazwa) podaj nazwy towarów, które zamówił
SELECT Customers.CompanyName, Products.ProductName
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
GROUP BY ProductName, CompanyName
ORDER BY CompanyName

--5.Dla każdego klienta (nazwa) podaj  wartość poszczególnych zamówień.
-- Gdy klient nic nie zamówił też powinna pojawić się informacja.

SELECT Customers.CompanyName, Orders.OrderID,
 SUM( (([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount)) ) as "wartsc zamowien"
FROM Customers
LEFT OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
LEFT OUTER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID, CompanyName

--6.Podaj czytelników (imię, nazwisko), którzy nigdy nie pożyczyli żadnej książki.
USE library

SELECT  member.firstname, member.lastname, member.member_no
FROM member
LEFT OUTER JOIN loanhist On loanhist.member_no = member.member_no
where loanhist.member_no is NULL
Intersect
SELECT member.firstname, member.lastname, member.member_no
FROM member
LEFT OUTER JOIN loan On loan.member_no = member.member_no
where loan.member_no is NULL

SELECT COUNT (member_no)
FROM member





--Cwiczenie 1--

--1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek
--oraz nazwę klienta.
USE Northwind

SELECT  Customers.CompanyName,[Order Details].OrderID, Sum([Order Details].Quantity)
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY  Customers.CompanyName, [Order Details].OrderID
ORDER BY CompanyName

--2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia,
--dla których łączna liczbę zamówionych jednostek jest większa niż 250.

SELECT  Customers.CompanyName,[Order Details].OrderID, Sum([Order Details].Quantity)
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY  Customers.CompanyName, [Order Details].OrderID
  HAVING Sum([Order Details].Quantity) > 250

--3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta.
USE Northwind

SELECT Orders.OrderID, Customers.CompanyName, SUM(([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount))
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID, CompanyName

--4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia,
--dla których łączna liczba jednostek jest większa niż 250.

SELECT Orders.OrderID, Customers.CompanyName, SUM(([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount)),
  SUM([Order Details].Quantity)
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID, CompanyName
HAVING SUM([Order Details].Quantity) > 250

--5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i
--nazwisko pracownika obsługującego zamówienie

SELECT Orders.OrderID, Customers.CompanyName, SUM(([Order Details].UnitPrice*[Order Details].Quantity)*(1-[Order Details].Discount)),
  SUM([Order Details].Quantity), Employees.LastName, Employees.FirstName
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.OrderID, CompanyName, Employees.FirstName, Employees.LastName
HAVING SUM([Order Details].Quantity) > 250

--Cwiczenie 2--

--1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę
--zamówionych przez klientów jednostek towarów.
USE Northwind

SELECT Categories.CategoryName,SUM([Order Details].Quantity)
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName

--2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówień
use northwind
SELECT Categories.CategoryName,SUM( ([Order Details].Quantity*[Order Details].UnitPrice)*(1-[Order Details].Discount))
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
LEFT JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName

--3. Posortuj wyniki w zapytaniu z punktu 2 wg:
--a) łącznej wartości zamówień
SELECT Categories.CategoryName,SUM( ([Order Details].Quantity*[Order Details].UnitPrice)*(1-[Order Details].Discount))
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName
ORDER BY SUM( ([Order Details].Quantity*[Order Details].UnitPrice)*(1-[Order Details].Discount))

--b) łącznej liczby zamówionych przez klientów jednostek towarów.

SELECT Categories.CategoryName,SUM( ([Order Details].Quantity*[Order Details].UnitPrice)*(1-[Order Details].Discount)), SUM([Order Details].Quantity)
FROM [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName
ORDER BY SUM([Order Details].Quantity)

--Cwiczenie 3--

--1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które
--przewieźli w 1997r
SELECT Shippers.CompanyName, COUNT(Orders.ShippedDate)
FROM Shippers
INNER JOIN Orders ON Shippers.ShipperID = Orders.ShipVia and YEAR(Orders.ShippedDate) = 1997
GROUP BY Shippers.CompanyName

--2. Który z przewoźników był najaktywniejszy (przewiózł największą
--liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika

SELECT TOP 1 Shippers.CompanyName, COUNT(Orders.ShippedDate) as "liczba zamowien"
FROM Shippers
INNER JOIN Orders ON Shippers.ShipperID = Orders.ShipVia and YEAR(Orders.ShippedDate) = 1997
GROUP BY Shippers.CompanyName
ORDER BY COUNT(Orders.ShippedDate) DESC

--3. Który z pracowników obsłużył największą liczbę zamówień w 1997r,
--podaj imię i nazwisko takiego pracownika

SELECT TOP 1 Employees.FirstName, Employees.LastName, COUNT(Orders.OrderDate)
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID and YEAR(Orders.OrderDate) = 1997
GROUP BY Employees.FirstName, Employees.LastName
ORDER BY COUNT(Orders.OrderDate) DESC

--Cwiczenie 4--

--1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
--zamówień obsłużonych przez tego pracownika
USE Northwind

SELECT Employees.FirstName, Employees.LastName,
  SUM((1-[Order Details].Discount)*([Order Details].UnitPrice*[Order Details].Quantity)) as "wartosc zamowienia"
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details]ON Orders.OrderID = [Order Details].OrderID
GROUP BY Employees.FirstName, Employees.LastName
ORDER BY LastName

--2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia
--o największej wartości) w 1997r, podaj imię i nazwisko takiego
--pracownika
SELECT Top 1 Employees.FirstName, Employees.LastName, [Order Details].OrderID,
  SUM((1-[Order Details].Discount)*([Order Details].UnitPrice*[Order Details].Quantity)) as "wartosc zamowienia"
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID and YEAR(OrderDate) = 1997
INNER JOIN [Order Details]ON Orders.OrderID = [Order Details].OrderID
GROUP BY Employees.FirstName, Employees.LastName, [Order Details].OrderID
ORDER BY SUM((1-[Order Details].Discount)*([Order Details].UnitPrice*[Order Details].Quantity)) DESC

--3. Ogranicz wynik z pkt 1 tylko do pracowników
--a) którzy mają podwładnych
--wazne jest to dalsze grupowanie !!!!

SELECT DISTINCT Employees.FirstName, Employees.LastName,
  SUM((1-[Order Details].Discount)*([Order Details].UnitPrice*[Order Details].Quantity)) as "wartosc zamowienia"
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details]ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Employees as A ON A.ReportsTo=Orders.EmployeeID
GROUP BY Employees.FirstName, Employees.LastName, A.FirstName, A.LastName
ORDER BY LastName


--b) którzy nie mają podwładnych tutaj COS ZE SREDNIA
SELECT Employees.FirstName, Employees.LastName, [Order Details].OrderID,
  SUM((1-[Order Details].Discount)*([Order Details].UnitPrice*[Order Details].Quantity)) as "wartosc zamowienia"
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details]ON Orders.OrderID = [Order Details].OrderID
LEFT JOIN Employees as A ON A.ReportsTo=Employees.EmployeeID
  WHERE A.ReportsTo is NULL
GROUP BY Employees.FirstName, Employees.LastName, [Order Details].OrderID
ORDER BY LastName

--przemyslec jeszcze raz jak to dziala



