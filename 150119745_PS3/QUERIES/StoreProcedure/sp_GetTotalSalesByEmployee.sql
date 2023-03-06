CREATE PROCEDURE sp_GetTotalSalesByEmployee
    @EmployeeID INT,
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SELECT p.FullName AS EmployeeName, e.Authority AS Authority, SUM(s.SalePrice) AS TotalSales, COUNT(s.SalePrice) AS TotalSalesCount
    FROM EMPLOYEE e, PERSON p, SALES s
    WHERE e.EmployeeID = @EmployeeID AND e.TRIdentifyNo = p.TRIdentifyNo AND s.SaleEmployeeID = e.EmployeeID AND s.SaleDate BETWEEN @FromDate AND @ToDate
    GROUP BY p.FullName, e.Authority
END

--EXEC sp_GetTotalSalesByEmployee 3, '2021-01-01', '2022-01-01'