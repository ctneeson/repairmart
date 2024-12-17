USE RepairMart
GO

IF OBJECT_ID('sp_deleteQuote', 'P') IS NOT NULL
    DROP PROCEDURE sp_deleteQuote;
GO

CREATE PROCEDURE sp_deleteQuote
   @inp_quoteId int,
   @del_Rows INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF @inp_quoteId IS NULL
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: quoteId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteId NOT IN (SELECT quoteId FROM quotes WHERE ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid Quote ID provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (SELECT ACTIVE FROM quotes WHERE quoteId = @inp_quoteId) = 0
	BEGIN
		SET @ERR_MESSAGE = 'Quote ID has already been deactivated.';
		SET @ERR_IND = 1;
	END
	
	IF @ERR_IND = 1
	BEGIN
		RAISERROR (@ERR_MESSAGE, 16, 1);
		RETURN;
	END
	
	BEGIN TRANSACTION;
		
	BEGIN TRY;
		UPDATE quotes
		SET ACTIVE = 0 WHERE quoteId = @inp_quoteId;
		
		SET @del_Rows = @@ROWCOUNT;

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @ERR_MESSAGE = ERROR_MESSAGE();
		SET @ERR_IND = 1;
		RAISERROR (@ERR_MESSAGE, 16, 1);
	END CATCH;
END;
GO