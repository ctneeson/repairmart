USE RepairMart
GO

IF OBJECT_ID('sp_deleteListing', 'P') IS NOT NULL
    DROP PROCEDURE sp_deleteListing;
GO

CREATE PROCEDURE sp_deleteListing
   @inp_userId bigint,
   @inp_listingId bigint,
   @del_Rows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId bigint OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_listingId IS NULL OR @inp_userId IS NULL)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: listingId and userId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_userId NOT IN (SELECT id FROM users WHERE ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: no active record could be found for the userId provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingId NOT IN (SELECT listingId FROM listings WHERE ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: no active record could be found for the listingId provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (SELECT ACTIVE FROM listings WHERE listingId = @inp_listingId) = 0
	BEGIN
		SET @ERR_MESSAGE = 'Listing ID has already been deactivated.';
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
		VALUES ('sp_deleteListing', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_deleteListing' AND UPDATED_BY = @inp_userId);

		UPDATE listings
		SET ACTIVE = 0 WHERE listingId = @inp_listingId;
		
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