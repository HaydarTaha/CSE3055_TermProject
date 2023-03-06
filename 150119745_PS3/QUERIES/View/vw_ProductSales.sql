CREATE VIEW vw_ProductSales AS
SELECT p.ProductName, s.SaleDate, p1.FullName AS CustomerName, p2.FullName AS EmployeeName, sp.COUNT, s.SalePrice, f.FirmName
FROM Sales s
INNER JOIN SalesProduct sp ON sp.SaleContractNumber = s.ContractNumber
INNER JOIN Customer c ON c.CustomerID = s.SaleCustomerID
INNER JOIN Employee e ON e.EmployeeID = s.SaleEmployeeID
INNER JOIN Products p ON p.ProductID = sp.ProductID
INNER JOIN SourceFirm f ON f.FirmID = p.ProductSourceFirmID
INNER JOIN PERSON p1 ON p1.TRIdentifyNo = c.TRIdentifyNo
INNER JOIN PERSON p2 ON p2.TRIdentifyNo = e.TRIdentifyNo
WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY p.ProductName, s.SaleDate, p1.FullName, p2.FullName, sp.COUNT, s.SalePrice, f.FirmName

--SELECT * FROM vw_ProductSales ORDER BY SaleDate, ProductName, CustomerName, EmployeeName, COUNT, SalePrice, FirmName