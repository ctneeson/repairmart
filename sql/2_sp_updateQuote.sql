USE RepairMart
GO

IF OBJECT_ID('sp_updateQuote', 'P') IS NOT NULL
    DROP PROCEDURE sp_updateQuote;
GO

CREATE PROCEDURE sp_updateQuote
   @inp_quoteId int,
   @inp_userId int,
   @inp_listingId int,
   @inp_quoteStatusId int,
   @inp_quoteCurrencyId int,
   @inp_quoteAmount DECIMAL(10,2),
   @inp_estimatedTurnaround INT,
   @inp_useDefaultLocation bit,
   @inp_overrideAddressLine1 nvarchar(500),
   @inp_overrideAddressLine2 nvarchar(500),
   @inp_overrideCountryId int,
   @inp_overridePostCode nvarchar(50),
   @inp_deliveryMethodIdList nvarchar(50),
   @inp_deliveryAmountList nvarchar(100),
   @upd_rows INT OUTPUT,
   @ins_rows_deliveryMethod INT OUTPUT,
   @del_rows_deliveryMethod INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId int OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_quoteId IS NULL
	    OR @inp_userId IS NULL
	    OR @inp_listingId IS NULL
	    OR @inp_quoteStatusId IS NULL
		OR @inp_quoteCurrencyId IS NULL
		OR @inp_quoteAmount IS NULL
		OR @inp_estimatedTurnaround IS NULL
		OR @inp_useDefaultLocation IS NULL
		OR @inp_deliveryMethodIdList IS NULL
		OR @inp_deliveryAmountList IS NULL
	)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: quoteId, userId, listingId, quoteStatusId, quoteCurrencyId, quoteAmount, estimatedTurnaround, useDefaultLocation, deliveryMethodIdList and deliveryAmountList must not be null.';
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
	         AND NOT EXISTS (SELECT 1 FROM users WHERE id = @inp_userId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid userId. No active user could be found for the userId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM listings WHERE listingId = @inp_listingId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingId. No active listing could be found for the listingId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteStatusId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM quoteStatus WHERE quoteStatusId = @inp_quoteStatusId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quoteStatusId. No active status could be found for the quoteStatusId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteCurrencyId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM currency WHERE currencyId = @inp_quoteCurrencyId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quoteCurrencyId. No active currency could be found for the quoteCurrencyId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_overrideCountryId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM country WHERE countryId = @inp_overrideCountryId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid overrideCountryId. No active country could be found for the overrideCountryId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF @inp_quoteAmount < 0
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quote amount provided. Must not be negative.';
		SET @ERR_IND = 1;
	END
	ELSE IF @inp_estimatedTurnaround < 0
	BEGIN
		SET @ERR_MESSAGE = 'Invalid estimated turnaround provided. Must not be negative.';
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
	ELSE IF LEN(@inp_deliveryMethodIdList) > 50
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input:  deliveryMethodIdList. Length must not exceed 50 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_deliveryAmountList) > 100
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input:  deliveryAmountList. Length must not exceed 100 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_deliveryMethodIdList) <= 50 AND LEN(@inp_deliveryAmountList) <= 100
	BEGIN
		-- Validate email attachments in ;-delimited list
		DECLARE @deliveryMethodIterator INT;
		SET @deliveryMethodIterator = 1;
		IF OBJECT_ID('tempdb..#temp_deliveryMethods') IS NOT NULL
		DROP TABLE #temp_deliveryMethods;
		
		CREATE TABLE #temp_deliveryMethods (
			deliveryMethodId int,
			deliveryAmount decimal(10,2),
			rowNum INT
		);
		INSERT INTO #temp_deliveryMethods (deliveryMethodId, deliveryAmount, rowNum)
		SELECT u.value, h.value, u.ordinal
		FROM STRING_SPLIT(@inp_deliveryMethodIdList,';',1) u
		JOIN STRING_SPLIT(@inp_deliveryAmountList,';',1) h
		ON u.ordinal = h.ordinal;

		WHILE (@deliveryMethodIterator <= (SELECT MAX(rowNum) FROM #temp_deliveryMethods))
		BEGIN
			DECLARE @it_deliveryAmount nvarchar(10) = (SELECT deliveryAmount FROM #temp_deliveryMethods WHERE rowNum = @deliveryMethodIterator);

			IF NOT EXISTS (SELECT 1 FROM deliveryMethod
			               WHERE ACTIVE = 1
						   AND deliveryMethodId = (SELECT TRY_CAST(deliveryMethodId AS int)
						                           FROM #temp_deliveryMethods
												   WHERE rowNum = @deliveryMethodIterator)
						  )
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: deliveryMethodIdList. No active delivery method could be found for Delivery Method Id:'
				                   + (SELECT deliveryMethodId FROM #temp_deliveryMethods WHERE rowNum = @deliveryMethodIterator);
				SET @ERR_IND = 1;
				BREAK;
			END
			ELSE IF (SELECT TRY_CAST(@it_deliveryAmount AS decimal(10,2))) IS NULL
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: deliveryAmountList. Invalid Delivery Amount:' + @it_deliveryAmount;
				SET @ERR_IND = 1;
				BREAK;
			END
		SET @deliveryMethodIterator = @deliveryMethodIterator + 1;
		END
	END
	ELSE IF (@inp_userId = (SELECT userId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_listingId = (SELECT listingId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_quoteStatusId = (SELECT quoteStatusId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_quoteCurrencyId = (SELECT quoteCurrencyId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_quoteAmount = (SELECT quoteAmount from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_estimatedTurnaround = (SELECT estimatedTurnaround from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_useDefaultLocation = (SELECT useDefaultLocation from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overrideAddressLine1 = (SELECT overrideAddressLine1 from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overrideAddressLine2 = (SELECT overrideAddressLine2 from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overrideCountryId = (SELECT overrideCountryId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overridePostCode = (SELECT overridePostCode from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
			 AND ( (SELECT CHECKSUM_AGG(CHECKSUM(CAST(dm.value AS int), CAST(da.value AS decimal(10,2))))
			        FROM STRING_SPLIT(@inp_deliveryMethodIdList, ';', 1) dm
					JOIN STRING_SPLIT(@inp_deliveryAmountList, ';', 1) da ON dm.ordinal = da.ordinal
				   )
	             = (SELECT CHECKSUM_AGG(CHECKSUM(deliveryMethodId, deliveryAmount)) FROM quotes_deliveryMethod WHERE quoteId = @inp_quoteId)
				 )
           )
	BEGIN
		SET @ERR_MESSAGE = 'Update rejected. No input details have changed.';
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
		VALUES ('sp_updateQuote', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_updateQuote' AND UPDATED_BY = @inp_userId);

		UPDATE quotes
		SET userId = @inp_userId,
		    listingId = @inp_listingId,
			quoteStatusId = @inp_quoteStatusId,
			quoteCurrencyId = @inp_quoteCurrencyId,
			quoteAmount = @inp_quoteAmount,
			estimatedTurnaround = @inp_estimatedTurnaround,
			useDefaultLocation = @inp_useDefaultLocation,
			overrideAddressLine1 = @inp_overrideAddressLine1,
			overrideAddressLine2 = @inp_overrideAddressLine2,
			overrideCountryId = @inp_overrideCountryId,
			overridePostCode = @inp_overridePostCode,
			runId = @out_runId
		WHERE quoteId = @inp_quoteId;
	
		SET @upd_rows = @@ROWCOUNT;

		-- Delete any existing delivery methods that no longer exist in the deliveryMethod table
		IF OBJECT_ID('tempdb..#temp_quotes_deliveryMethod_old') IS NOT NULL
        DROP TABLE #temp_quotes_deliveryMethod_old;

		CREATE TABLE #temp_quotes_deliveryMethod_old (deliveryMethodId int);

		INSERT INTO #temp_quotes_deliveryMethod_old(deliveryMethodId)
		SELECT DISTINCT deliveryMethodId FROM quotes_deliveryMethod
		WHERE quoteId = @inp_quoteId
		AND deliveryMethodId NOT IN (SELECT deliveryMethodId FROM deliveryMethod WHERE ACTIVE = 1);

		DELETE FROM quotes_deliveryMethod
		WHERE quoteId = @inp_quoteId
		AND deliveryMethodId IN (SELECT deliveryMethodId FROM #temp_quotes_deliveryMethod_old);
		SET @del_rows_deliveryMethod = @@ROWCOUNT;

		-- 3. Update product classifications for the selected listing
		IF OBJECT_ID('tempdb..#temp_quotes_deliveryMethod_new') IS NOT NULL
        DROP TABLE #temp_quotes_deliveryMethod_new;

		CREATE TABLE #temp_quotes_deliveryMethod_new (
			quoteId int,
			deliveryMethodId int,
			deliveryAmount decimal(10,2)
		);

		-- 3a. Delete any existing records that are not in @inp_productClassificationIdList
		INSERT INTO #temp_quotes_deliveryMethod_new (quoteId, deliveryMethodId, deliveryAmount)
		SELECT @inp_quoteId, CAST(dm.value AS int), CAST(da.value AS decimal(10,2))
		FROM STRING_SPLIT(@inp_deliveryMethodIdList,';',1) dm
		JOIN STRING_SPLIT(@inp_deliveryAmountList,';',1) da ON dm.ordinal = da.ordinal;

		SET @del_rows_deliveryMethod = @del_rows_deliveryMethod + (SELECT COUNT(*) FROM quotes_deliveryMethod
		                                                           WHERE quoteId = @inp_quoteId
											                       AND deliveryMethodId NOT IN (SELECT deliveryMethodId
		                                                                                        FROM #temp_quotes_deliveryMethod_new
																				                WHERE quoteId = @inp_quoteId));
		DELETE FROM quotes_deliveryMethod
		WHERE quoteId = @inp_quoteId
		AND deliveryMethodId NOT IN (SELECT deliveryMethodId
		                             FROM #temp_quotes_deliveryMethod_new
									 WHERE quoteId = @inp_quoteId);

		-- 3b. Insert any new classifications from @inp_productClassificationIdList
		INSERT INTO quotes_deliveryMethod(quoteId, deliveryMethodId, runId)
		SELECT quoteId, deliveryMethodId, @out_runId
		FROM #temp_quotes_deliveryMethod_new
		WHERE deliveryMethodId NOT IN (SELECT deliveryMethodId
		                               FROM quotes_deliveryMethod
									   WHERE quoteId = @inp_quoteId);
		SET @ins_rows_deliveryMethod = (SELECT COUNT(*) FROM quotes_deliveryMethod
		                                WHERE quoteId = @inp_quoteId
										AND runId = @out_runId);

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