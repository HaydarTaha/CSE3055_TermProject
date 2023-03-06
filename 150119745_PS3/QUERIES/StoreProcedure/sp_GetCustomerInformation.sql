CREATE PROCEDURE sp_GetCustomerInformation
    @CustomerID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CustomerID = @CustomerID)
    BEGIN
        RAISERROR('Customer not found.', 16, 1)
        RETURN
    END
    SELECT p.FullName, c.TRIdentifyNo, c.Region, c.Description, p.Address, p.Email, pn.PhoneNumber
    FROM CUSTOMER c, PERSON p, PHONENUMBER pn
    WHERE c.CustomerID = @CustomerID AND c.TRIdentifyNo = p.TRIdentifyNo AND c.CustomerID = pn.CustomerID
END

--EXEC sp_GetCustomerInformation 15