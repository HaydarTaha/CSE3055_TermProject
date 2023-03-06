CREATE PROCEDURE sp_GetCustomerServiceRequestCount
    @customerID INT,
    @startDate SMALLDATETIME,
    @endDate SMALLDATETIME
AS
BEGIN

    IF NOT EXISTS(Select * FROM CUSTOMER WHERE CustomerID = @customerID)
    BEGIN
        RAISERROR('Invalid customer ID', 16, 1);
        ROLLBACK TRANSACTION;
    END

    DECLARE @customerName NVARCHAR(60)
    SELECT @customerName = FullName
    FROM PERSON P, CUSTOMER C
    WHERE c.CustomerID = @customerID AND C.TRIdentifyNo = P.TRIdentifyNo

    SELECT @customerName AS 'Customer Name', COUNT(*) AS 'Total Service Request'
    FROM ServiceRequest sr, CUSTOMER c
    WHERE c.CustomerID = @customerID AND sr.ServiceRequestCustomerID = c.CustomerID AND sr.RequestDate BETWEEN @startDate AND @endDate
END

--EXEC sp_GetCustomerServiceRequestCount 8, '2022-01-01', '2022-12-31'