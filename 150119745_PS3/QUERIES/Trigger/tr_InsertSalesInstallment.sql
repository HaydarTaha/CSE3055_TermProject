CREATE TRIGGER tr_InsertSalesInstallment
ON SALES
AFTER INSERT
AS
BEGIN
    DECLARE @counter INT = 1
    DECLARE @max_installments INT
    DECLARE @CustomerID INT
    SELECT @max_installments = NumberOfInstallment FROM inserted
    SELECT @CustomerID = SaleCustomerID FROM inserted
    
    WHILE @counter <= @max_installments
    BEGIN
        INSERT INTO SALESINSTALLMENT (InstallmentNumber, InstallmentExpiryDate, InstallmentPrice, TotalInstallment, InstallmentContractNumber, InstallmentCustomerID)
        SELECT
            @counter,
            DATEADD(month, @counter, i.SaleDate),
            i.SalePrice / i.NumberOfInstallment,
            i.NumberOfInstallment,
            i.ContractNumber,
            i.SaleCustomerID
        FROM inserted i
        SET @counter = @counter + 1
    END
END