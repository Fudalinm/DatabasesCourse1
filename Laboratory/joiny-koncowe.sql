-- æwiczenie nr 1

-- zad 1

use northwind

SELECT  Customers.CompanyName, sum([Order Details].Quantity)
FROM         Customers INNER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
             [Order Details] ON Orders.OrderID = [Order Details].OrderID
group by Customers.CustomerID, Customers.CompanyName             
             
-- zad 2

use northwind

SELECT  Customers.CompanyName, sum([Order Details].Quantity)
FROM         Customers INNER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
             [Order Details] ON Orders.OrderID = [Order Details].OrderID
group by Customers.CustomerID, Customers.CompanyName             
having sum([Order Details].Quantity) > 250

-- zad 3

SELECT     Orders.OrderID, Customers.CompanyName, sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) as total
FROM         Customers INNER JOIN
                      Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                      [Order Details] OD ON Orders.OrderID = OD.OrderID
                      
group by Orders.OrderID, Customers.CompanyName
order by 1

-- zad 4

SELECT     Orders.OrderID, Customers.CompanyName, sum(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) as total
FROM         Customers INNER JOIN
                      Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                      [Order Details] OD ON Orders.OrderID = OD.OrderID
                      
group by Orders.OrderID, Customers.CompanyName
having sum(OD.Quantity) > 150
order by 1

-- zad 5

SELECT     O.OrderID, C.CompanyName, SUM((OD.Quantity * OD.UnitPrice) * (1 - OD.Discount)) AS total, E.LastName, E.FirstName
FROM         Customers AS C INNER JOIN
                      Orders AS O ON C.CustomerID = O.CustomerID INNER JOIN
                      [Order Details] AS OD ON O.OrderID = OD.OrderID INNER JOIN
                      Employees AS E ON O.EmployeeID = E.EmployeeID
GROUP BY O.OrderID, C.CompanyName, E.LastName, E.FirstName
HAVING      (SUM(OD.Quantity) > 150)
ORDER BY O.OrderID

--- æwiczenie nr 2

-- zad 1

SELECT     C.CategoryName, SUM(OD.Quantity) AS Expr1
FROM         Categories AS C INNER JOIN
                      Products AS P ON C.CategoryID = P.CategoryID INNER JOIN
                      [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryID, C.CategoryName
ORDER BY C.CategoryName

-- zad 2

SELECT     C.CategoryName, SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS Expr1
FROM         Categories AS C INNER JOIN
                      Products AS P ON C.CategoryID = P.CategoryID INNER JOIN
                      [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryID, C.CategoryName
ORDER BY C.CategoryName

-- zad 3
-- a)

SELECT     C.CategoryName, SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS Expr1
FROM         Categories AS C INNER JOIN
                      Products AS P ON C.CategoryID = P.CategoryID INNER JOIN
                      [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryID, C.CategoryName
ORDER BY 2 DESC

-- b)

SELECT     C.CategoryName, SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) AS Expr1
FROM         Categories AS C INNER JOIN
                      Products AS P ON C.CategoryID = P.CategoryID INNER JOIN
                      [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryID, C.CategoryName
ORDER BY SUM(OD.Quantity) DESC

-- æwiczenie nr 3

-- zad 1

SELECT     Shippers.CompanyName, COUNT(Orders.OrderID) AS 'zamowienia'
FROM         Orders INNER JOIN
                      Shippers ON Orders.ShipVia = Shippers.ShipperID
GROUP BY Shippers.CompanyName, Shippers.ShipperID
ORDER BY Shippers.CompanyName

-- zad 2

SELECT TOP 1 Shippers.CompanyName, COUNT(Orders.OrderID) AS 'zamowienia'
FROM         Orders INNER JOIN
                      Shippers ON Orders.ShipVia = Shippers.ShipperID
							   AND YEAR(Orders.ShippedDate) = 1997
GROUP BY Shippers.CompanyName, Shippers.ShipperID
ORDER BY 2 DESC

-- zad 3

SELECT TOP 1 Employees.LastName, Employees.FirstName, COUNT(Orders.OrderID) AS total
FROM         Employees INNER JOIN
                      Orders ON Employees.EmployeeID = Orders.EmployeeID
						AND YEAR(Orders.ShippedDate) = 1997
GROUP BY Employees.LastName, Employees.FirstName
ORDER BY total DESC



-- æwiczenie nr 4
-- zad 1

SELECT     E.LastName, E.FirstName, SUM(D.UnitPrice * D.Quantity * (1-D.Discount)) AS total
FROM         Employees AS E INNER JOIN
                      Orders AS O ON E.EmployeeID = O.EmployeeID INNER JOIN
                      [Order Details] AS D ON O.OrderID = D.OrderID
GROUP BY E.LastName, E.FirstName, E.EmployeeID

-- zad 2


SELECT TOP 1 E.LastName, E.FirstName, SUM(D.UnitPrice * D.Quantity * (1-D.Discount)) AS total
FROM         Employees AS E INNER JOIN
                      Orders AS O ON E.EmployeeID = O.EmployeeID 
                      AND YEAR(O.OrderDate) = 1997
										INNER JOIN
                      [Order Details] AS D ON O.OrderID = D.OrderID
GROUP BY E.LastName, E.FirstName, E.EmployeeID
ORDER BY 3 DESC

-- zad 3
-- a)
SELECT     E.LastName, E.FirstName, SUM((D.UnitPrice * D.Quantity) * (1 - D.Discount)) AS total
FROM         Employees AS E INNER JOIN
                      Orders AS O ON E.EmployeeID = O.EmployeeID INNER JOIN
                      [Order Details] AS D ON O.OrderID = D.OrderID INNER JOIN
                      Employees AS ES ON ES.ReportsTo = E.EmployeeID
GROUP BY E.LastName, E.FirstName, E.EmployeeID

-- b)
SELECT     E.LastName, E.FirstName, E.EmployeeID, SUM((D.UnitPrice * D.Quantity) * (1 - D.Discount)) AS total
FROM         Employees AS E LEFT OUTER JOIN
                      Employees AS ES ON ES.ReportsTo = E.EmployeeID INNER JOIN
                      Orders AS O ON E.EmployeeID = O.EmployeeID INNER JOIN
                      [Order Details] AS D ON O.OrderID = D.OrderID 

WHERE ES.EmployeeID IS NULL                      
GROUP BY E.LastName, E.FirstName, E.EmployeeID

