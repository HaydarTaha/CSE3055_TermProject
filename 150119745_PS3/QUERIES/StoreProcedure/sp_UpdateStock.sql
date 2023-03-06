CREATE PROCEDURE sp_UpdateStock
    @ProductID INT,
    @NewStockCount INT
AS
BEGIN
    DECLARE @CurrentStockCount INT
    
    SELECT @CurrentStockCount = StockCount
    FROM STOCK
    WHERE StockProductID = @ProductID

    UPDATE STOCK
    SET StockCount = @NewStockCount
    WHERE StockProductID = @ProductID
END

--EXEC sp_UpdateStock 1 50