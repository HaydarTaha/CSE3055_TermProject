CREATE PROCEDURE sp_GetProductAvailability
@ProductID INT
AS
BEGIN
    DECLARE @ProductAvailability INT
    SELECT @ProductAvailability = StockCount
    FROM STOCK
    WHERE StockProductID = @ProductID

    SELECT @ProductAvailability AS ProductAvailability, p.ProductName
    FROM PRODUCTS p
    WHERE p.ProductID = @ProductID
END

--EXECUTE sp_GetProductAvailability 2