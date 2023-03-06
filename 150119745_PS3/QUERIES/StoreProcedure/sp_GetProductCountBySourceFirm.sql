CREATE PROCEDURE sp_GetProductCountBySourceFirm
    @sourceFirmID INT
AS
BEGIN
    DECLARE @firmName NVARCHAR(50)
    SELECT @firmName = FirmName FROM SourceFirm WHERE FirmID = @sourceFirmID
    IF @firmName IS NULL
    BEGIN
        RAISERROR('Source firm with ID %d does not exist', 16, 1, @sourceFirmID)
        RETURN
    END

    SELECT @firmName AS 'Firm Name', COUNT(*) AS 'Number of Products'
    FROM PRODUCTS p
    WHERE p.ProductSourceFirmID = @sourceFirmID
END

--EXEC sp_GetProductCountBySourceFirm 2