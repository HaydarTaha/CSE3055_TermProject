/*
CREATE TYPE ProductType AS TABLE (
    ProductID INT,
    ProductCount INT
)
*/

CREATE PROCEDURE sp_AddSaleAndSaleProduct
    @salePrice SMALLMONEY,
    @numberOfInstallment INT,
    @saleDate SMALLDATETIME,
    @saleDescription NVARCHAR(50),
    @saleType NVARCHAR(20),
    @saleCustomerID INT,
    @saleEmployeeID INT,
    @products ProductType READONLY
AS
BEGIN
    INSERT INTO Sales (SalePrice, NumberOfInstallment, SaleDate, SaleDescription, SaleType, SaleCustomerID, SaleEmployeeID)
    VALUES (@salePrice, @numberOfInstallment, @saleDate, @saleDescription, @saleType, @saleCustomerID, @saleEmployeeID)

    DECLARE @contractNumber INT
    SELECT @contractNumber = ContractNumber FROM Sales WHERE SaleCustomerID = @saleCustomerID AND SaleEmployeeID = @saleEmployeeID AND SaleDate = @saleDate

    INSERT INTO SalesProduct (SaleContractNumber, ProductID, Count)
    SELECT @contractNumber, ProductID, ProductCount FROM @products
END


/*DECLARE @products ProductType;

INSERT INTO @products (ProductID, ProductCount)
VALUES (1, 2), (2, 1), (3, 3);

EXEC sp_AddSaleAndSaleProduct
    @salePrice = 1000,
    @numberOfInstallment = 3,
    @saleDate = '2022-12-29',
    @saleDescription = 'The customer will install the product.',
    @saleType = 'Cash',
    @saleCustomerID = 1,
    @saleEmployeeID = 2,
    @products = @products;*/