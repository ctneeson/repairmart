USE RepairMart
GO

IF OBJECT_ID('sp_postNewListing', 'P') IS NOT NULL
    DROP PROCEDURE sp_postNewListing;
GO

CREATE PROCEDURE sp_postNewListing
   @inp_userId int,
   @inp_listingStatusId int,
   @inp_listingTitle varchar(500),
   @inp_listingBudgetCurrencyId int,
   @inp_listingBudget decimal(10,2),
   @inp_useDefaultLocation bit,
   @inp_overrideAddressLine1 varchar(500),
   @inp_overrideAddressLine2 varchar(500),
   @inp_overrideCountryId int,
   @inp_overridePostCode varchar(50),
   @inp_listingExpiry int,
   @inp_listingAttachmentList varchar(5000),
   @ins_rows INT OUTPUT,
   @ins_rows_attachments INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId int OUTPUT,
   @out_listingId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_userId IS NULL
	    OR @inp_listingStatusId IS NULL
		OR @inp_listingTitle IS NULL
		OR @inp_useDefaultLocation IS NULL
		OR @inp_listingExpiry IS NULL
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). userId, listingStatusId, listingTitle, useDefaultLocation and listingExpiry must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF ((@inp_useDefaultLocation = 0 AND COALESCE(@inp_overrideAddressLine1, @inp_overrideAddressLine2) IS NULL)
		     OR (@inp_useDefaultLocation = 0 AND @inp_overrideCountryId IS NULL)
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). When useDefaultLocation is false, override address fields must be populated.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_userId IS NOT NULL
	         AND (SELECT COUNT(*) FROM users WHERE userId = @inp_userId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid userId. No active user could be found for the userId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingStatusId IS NOT NULL
	         AND (SELECT COUNT(*) FROM listingStatus WHERE listingStatusId = @inp_listingStatusId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingStatusId. No active status could be found for the listingStatusId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingBudgetCurrencyId IS NOT NULL
	         AND (SELECT COUNT(*) FROM currency WHERE currencyId = @inp_listingBudgetCurrencyId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingBudgetCurrencyId. No active currency could be found for the listingBudgetCurrencyId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_overrideCountryId IS NOT NULL
	         AND (SELECT COUNT(*) FROM country WHERE countryId = @inp_overrideCountryId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid overrideCountryId. No active country could be found for the overrideCountryId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF @inp_listingBudget < 0
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingBudget provided. Must not be negative.';
		SET @ERR_IND = 1;
	END
	ELSE IF @inp_listingExpiry < 0
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingExpiry provided. Must not be negative.';
		SET @ERR_IND = 1;
	END
	ELSE IF (LEN(@inp_overrideAddressLine1) > 500 OR LEN(@inp_overrideAddressLine2) > 500)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid address length. overrideAddressLine1 and inp_overrideAddressLine2 cannot be longer than 500 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_overridePostCode) > 50
	BEGIN
		SET @ERR_MESSAGE = 'Invalid postcode length. overridePostCode cannot be longer than 50 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_listingAttachmentList) > 5000
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: listingAttachmentList. Length must not be greater than 5000 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_listingAttachmentList) <= 5000
	BEGIN
		-- Validate email attachments in ;-delimited list
		DECLARE @attachmentIterator INT;
		SET @attachmentIterator = 1;
		IF OBJECT_ID('tempdb..#temp_listingAttachments') IS NOT NULL
		DROP TABLE #temp_listingAttachments;
		
		CREATE TABLE #temp_listingAttachments (
			attachmentUrl VARCHAR(1000),
			rowNum INT
		);
		INSERT INTO #temp_listingAttachments (attachmentUrl, rowNum)
		SELECT value, ordinal FROM STRING_SPLIT(@inp_listingAttachmentList,';',1);

		WHILE (@attachmentIterator <= (SELECT MAX(rowNum) FROM #temp_listingAttachments))
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM #temp_listingAttachments
			               WHERE rowNum = @attachmentIterator
						   AND LEN(REPLACE(REPLACE(attachmentUrl,' ',''),'	',''))>0)
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: listingAttachments. Attachment URLs must not be empty.';
				SET @ERR_IND = 1;
				BREAK;
			END
		SET @attachmentIterator = @attachmentIterator + 1;
		END
	END

	IF @ERR_IND = 1
	BEGIN
		RAISERROR (@ERR_MESSAGE, 16, 1);
		RETURN;
	END

	BEGIN TRANSACTION;

	BEGIN TRY;
		-- Get runID
		INSERT INTO runIds(processName)
		VALUES ('sp_postNewListing');
		SET @out_runId = (SELECT MAX(runId) from runIds);

		-- insert listing
		INSERT INTO listings(userId, listingStatusId, listingTitle, listingBudgetCurrencyId, listingBudget,
		                     useDefaultLocation, overrideAddressLine1, overrideAddressLine2, overrideCountryId,
							 overridePostCode, listingExpiry, runId)
		VALUES (@inp_userId, @inp_listingStatusId, @inp_listingTitle, @inp_listingBudgetCurrencyId, @inp_listingBudget,
                @inp_useDefaultLocation, @inp_overrideAddressLine1, @inp_overrideAddressLine2, @inp_overrideCountryId,
                @inp_overridePostCode, @inp_listingExpiry, @out_runId);
	
		SET @ins_rows = @@ROWCOUNT;
		SET @out_listingId = (SELECT MAX(listingId) from listings WHERE runId = @out_runId);

		-- insert attachments
		SET @attachmentIterator = 1;
		WHILE (@attachmentIterator <= (SELECT MAX(rowNum) FROM #temp_listingAttachments))
		BEGIN
			DECLARE @out_attachmentId int;

			INSERT INTO attachments(attachmentUrl, runId)
			SELECT attachmentUrl, @out_runId
			FROM #temp_listingAttachments WHERE rowNum = @attachmentIterator;

			SET @out_attachmentId = (SELECT MAX(attachmentId) FROM attachments
			                         WHERE runId = @out_runId);

			INSERT INTO listings_attachments(listingId, attachmentId, runId)
			VALUES(@out_listingId, @out_attachmentId, @out_runId);

			SET @attachmentIterator = @attachmentIterator + 1;
		END
		SET @ins_rows_attachments = (SELECT COUNT(*) FROM attachments
		                             WHERE runId = @out_runId);

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