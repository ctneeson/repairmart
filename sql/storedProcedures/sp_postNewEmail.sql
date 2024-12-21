USE RepairMart
GO

IF OBJECT_ID('sp_postNewEmail', 'P') IS NOT NULL
    DROP PROCEDURE sp_postNewEmail;
GO

CREATE PROCEDURE sp_postNewEmail
   @inp_emailFromId int,
   @inp_listingId int,
   @inp_quoteId int,
   @inp_orderId int,
   @inp_emailSubject varchar(255),
   @inp_emailContent varchar(max),
   @ins_rows INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId INT OUTPUT,
   @out_emailId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_emailFromId IS NULL
		OR @inp_emailContent IS NULL
		OR LEN(REPLACE(REPLACE(@inp_emailContent,' ',''),'	','')) = 0
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). emailFromId and emailContent must not be null. emailContent must nt contain only empty spaces.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_emailFromId IS NOT NULL
	         AND (SELECT COUNT(*) FROM users WHERE userId = @inp_emailFromId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid emailFromId. No active user could be found for the emailFromId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingId IS NOT NULL
	         AND (SELECT COUNT(*) FROM listings WHERE listingId = @inp_listingId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingId. No active listing could be found for the listingId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteId IS NOT NULL
	         AND (SELECT COUNT(*) FROM quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quoteId. No active quote could be found for the quoteId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_orderId IS NOT NULL
	         AND (SELECT COUNT(*) FROM orders WHERE orderId = @inp_orderId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid orderId. No active order could be found for the orderId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_emailSubject) > 255
	BEGIN
		SET @ERR_MESSAGE = 'Invalid emailSubject. Length must not be greater than 255 characters.';
		SET @ERR_IND = 1;
	END

	IF @ERR_IND = 1
	BEGIN
		RAISERROR (@ERR_MESSAGE, 16, 1);
		RETURN;
	END

	BEGIN TRANSACTION;

	BEGIN TRY;
		INSERT INTO runIds(processName)
		VALUES ('sp_postNewEmail');
		SET @out_runId = (SELECT MAX(runId) from runIds);

		INSERT INTO emails(emailFromId, listingId, quoteId, orderId, emailSubject, emailContent, runId)
		VALUES (@inp_emailFromId,
		        @inp_listingId,
				@inp_quoteId,
				@inp_orderId,
				@inp_emailSubject,
				@inp_emailContent,
				@out_runId);
	
		SET @ins_rows = @@ROWCOUNT;
		SET @out_emailId = (SELECT emailId from emails WHERE runId = @out_runId);

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