CREATE TRIGGER tr_InsertServiceInstallment
ON Service
AFTER INSERT
AS
BEGIN
    DECLARE @counter INT = 1
    DECLARE @max_installments INT
    DECLARE @CustomerID INT
    SELECT @max_installments = NumberOfInstallment FROM inserted
    SELECT @CustomerID = ServiceCustomerID FROM inserted
    
    WHILE @counter <= @max_installments
    BEGIN
        INSERT INTO SERVICEINSTALLMENT (InstallmentNumber, InstallmentExpiryDate, InstallmentPrice, TotalInstallment, InstallmentServiceID, InstallmentCustomerID)
        SELECT
            @counter,
            DATEADD(month, @counter, i.ServiceDate),
            i.ServiceFee / i.NumberOfInstallment,
            i.NumberOfInstallment,
            i.ServiceID,
            i.ServiceCustomerID
        FROM inserted i
        SET @counter = @counter + 1
    END
END