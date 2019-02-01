USE Northwind


---Cwiczenie 1---
--punkt 1
SELECT OrderID, (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy"  from [Order Details] ORDER BY [wartosc sprzedazy] DESC
--punkt 2
SELECT TOP 10 (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy" , OrderID  from [Order Details] ORDER BY [wartosc sprzedazy] DESC
--punkt 3  jak wybrac pierwszych 10 wartosci?
SELECT (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy" , OrderID  from [Order Details] ORDER BY [wartosc sprzedazy] DESC
SELECT  DISTINCT TOP 10 (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy" from [Order Details] ORDER BY [wartosc sprzedazy] DESC
--jak wybiore 10(ostatni) rekord to bede znac ograniczenie (wybralem 10 wartosc ktora musze wypisac)
SELECT MIN(a.[wartosc sprzedazy]) FROM (SELECT  DISTINCT TOP 10 (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy" from [Order Details] ORDER BY [wartosc sprzedazy] DESC)a
--jak juz pobralismy ostatnia zadana wartosc to musimy znalezc mniejsze od niej
SELECT (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy" , OrderID
from [Order Details]
WHERE (UnitPrice * Quantity) * (1 - Discount) >= (SELECT MIN(a.[wartosc sprzedazy])FROM (SELECT  DISTINCT TOP 10 (UnitPrice * Quantity) * (1 - Discount) as "wartosc sprzedazy" from [Order Details] ORDER BY [wartosc sprzedazy] DESC)a)
ORDER BY [wartosc sprzedazy] DESC
--i to dziala ale jest troche chore xDDDDDD


---Cwiczenie 2---
--punkt 1
SELECT  * FROM [Order Details]
SELECT sum(Quantity) from [Order Details] WHERE ProductID < 3
--punkt 2
SELECT sum(Quantity) from [Order Details]
SELECT sum(Quantity)/2 from [Order Details]
--punkt 3
SELECT  * from [Order Details]
SELECT OrderID,sum(Quantity) as "suma_zamawianych" from [Order Details] GROUP BY OrderID --nie moge tu uzyc where
SELECT OrderID,sum(Quantity) as "suma_zamawianych" from [Order Details] GROUP BY OrderID having sum(Quantity) > 250

---Cwiczenie 3---
--punkt 1
SELECT * FROM [Order Details]
SELECT ProductID,OrderID, sum(Quantity) as "suma zamowionego produktu" FROM [Order Details] GROUP BY ProductID, OrderID WITH ROLLUP
--punkt 2
SELECT ProductID,OrderID, sum(Quantity) as "suma zamowionego produktu" FROM [Order Details] WHERE ProductID=50 GROUP BY ProductID, OrderID WITH ROLLUP
--punkt 3
--pola te nie biora udzialu w grupowaniu po nich mozna zlokalizowac gdzie dokonywane sa sumowania
--punkt 4
SELECT ProductID, GROUPING(productid) AS grupowanie_produktu, OrderID, GROUPING(orderid) AS grupowanie_zamowienia,SUM(Quantity) AS suma FROM [Order Details] GROUP BY ProductID, OrderID WITH CUBE
--punkt 5
--podsumowaniem sa wiersze z wartosciamix
--



