CREATE VIEW vw_DetailedSales AS
SELECT s.SaleDate, p1.FullName AS CustomerName, p2.FullName AS EmployeeName, s.SaleType, p.ProductName, sp.COUNT, sp.ProductID, p.ProductPrice, s.ContractNumber, 
s.SalePrice, s.NumberOfInstallment, s.SaleDescription, f.FirmName
FROM Sales s
INNER JOIN SalesProduct sp ON s.ContractNumber = sp.SaleContractNumber
INNER JOIN Customer c ON s.SaleCustomerID = c.CustomerID
INNER JOIN Employee e ON s.SaleEmployeeID = e.EmployeeID
INNER JOIN Products p ON sp.ProductID = p.ProductID
INNER JOIN SourceFirm f ON p.ProductSourceFirmID = f.FirmID
INNER JOIN PERSON p1 ON p1.TRIdentifyNo = c.TRIdentifyNo
INNER JOIN PERSON p2 ON p2.TRIdentifyNo = e.TRIdentifyNo

--SELECT * FROM vw_DetailedSales ORDER BY SaleDate, CustomerName, EmployeeName, SaleType, ProductName, COUNT, ProductID, ProductPrice, ContractNumber, SalePrice, NumberOfInstallment, SaleDescription, FirmName