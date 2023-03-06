CREATE VIEW vw_SalesSummary AS
SELECT s.ContractNumber, p1.FullName AS CustomerName, p2.FullName AS EmployeeName, p.ProductName, sp.COUNT, p.ProductPrice, s.SalePrice, s.NumberOfInstallment, s.SaleDate, s.SaleType,
(s.SalePrice - (p.ProductPrice * sp.COUNT)) AS Profit
FROM Sales s
INNER JOIN Customer c ON c.CustomerID = s.SaleCustomerID
INNER JOIN Employee e ON e.EmployeeID = s.SaleEmployeeID
INNER JOIN SalesProduct sp ON sp.SaleContractNumber = s.ContractNumber
INNER JOIN Products p ON p.ProductID = sp.ProductID
INNER JOIN PERSON p1 ON p1.TRIdentifyNo = c.TRIdentifyNo
INNER JOIN PERSON p2 ON p2.TRIdentifyNo = e.TRIdentifyNo

--SELECT * FROM vw_SalesSummary