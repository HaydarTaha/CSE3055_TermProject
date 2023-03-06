CREATE VIEW vw_ProductSalesCount AS
SELECT p.ProductName, p.ProductType, SUM(sp.COUNT) AS TotalQuantity, SUM(sp.COUNT * p.ProductPrice) AS TotalIncome
FROM Sales s
INNER JOIN SalesProduct sp ON sp.SaleContractNumber = s.ContractNumber
INNER JOIN Products p ON p.ProductID = sp.ProductID
GROUP BY p.ProductName, p.ProductType
HAVING SUM(sp.COUNT) > 5

--SELECT * FROM vw_ProductSalesCount ORDER BY TotalIncome DESC