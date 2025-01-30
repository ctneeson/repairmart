USE RepairMart
GO

IF OBJECT_ID('sp_deleteQuote', 'P') IS NOT NULL
    DROP PROCEDURE sp_deleteQuote;
GO

CREATE PROCEDURE sp_deleteQuote
   @inp_userId int,
   @inp_quoteId int,
   @del_Rows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId INT OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_userId IS NULL OR @inp_quoteId IS NULL)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: userId and quoteId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF NOT EXISTS (SELECT 1 FROM users WHERE id = @inp_userId AND ACTIVE = 1)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: no active record could be found for the userId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF NOT EXISTS (SELECT 1 FROM quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: no active record could be found for the quoteId provided.';
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
		-- Get runID
		INSERT INTO runIds(processName, UPDATED_BY)
		VALUES ('sp_deleteQuote', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_deleteQuote' AND UPDATED_BY = @inp_userId);

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