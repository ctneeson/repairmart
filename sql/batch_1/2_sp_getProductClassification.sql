USE RepairMart
GO

IF OBJECT_ID('sp_getProductClassification', 'P') IS NOT NULL
    DROP PROCEDURE sp_getProductClassification;
GO

CREATE PROCEDURE sp_getProductClassification
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	BEGIN TRY;

	SELECT
	 productClassificationId,
	 category,
	 subcategory,
	 subcategoryOrder
    FROM productClassification
    WHERE ACTIVE = 1;

	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @ERR_MESSAGE = ERROR_MESSAGE();
		SET @ERR_IND = 1;
		RAISERROR (@ERR_MESSAGE, 16, 1);
	END CATCH;
END;
GO
