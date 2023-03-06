CREATE PROCEDURE sp_GetEmployeeTotalEarningsInPeriodForService
@employeeID INT,
@startDate SMALLDATETIME,
@endDate SMALLDATETIME
AS
BEGIN
    DECLARE @earnings SMALLMONEY = 0
    DECLARE @serviceCount INT = 0

    IF NOT EXISTS (SELECT * FROM Employee WHERE EmployeeID = @employeeID)
    BEGIN
        RAISERROR('Employee not found.', 16, 1)
        RETURN
    END

    SELECT @earnings = SUM(ServiceFee)
    FROM Service
    WHERE ServiceEmployeeID = @employeeID AND ServiceDate BETWEEN @startDate AND @endDate

    SELECT @serviceCount = COUNT(*)
    FROM Service
    WHERE ServiceEmployeeID = @employeeID AND ServiceDate BETWEEN @startDate AND @endDate

    IF @serviceCount = 0
    BEGIN
        RAISERROR('Employee has no service.', 16, 1)
        RETURN
    END

    DECLARE @fullName NVARCHAR(60)
    SELECT @fullName = p.FullName
    FROM Employee e, PERSON p
    WHERE e.EmployeeID = @employeeID AND p.TRIdentifyNo = e.TRIdentifyNo

    SELECT @fullName AS FullName, @earnings AS Earnings, @serviceCount AS ServiceCount
END

--EXEC sp_GetEmployeeTotalEarningsInPeriodForService 3, '2018-01-01', '2022-12-31'