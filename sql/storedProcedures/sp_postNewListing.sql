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
   @ins_rows INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT
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
	ELSE IF (@inp_quoteCurrencyId IS NOT NULL
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

	IF @ERR_IND = 1
	BEGIN
		RAISERROR (@ERR_MESSAGE, 16, 1);
		RETURN;
	END

	BEGIN TRANSACTION;

	BEGIN TRY;
		INSERT INTO quotes(userId, listingId, quoteStatusId, quoteCurrencyId, quoteAmount, estimatedTurnaround, useDefaultLocation,
		                   overrideAddressLine1, overrideAddressLine2, overrideCountryId, overridePostCode)
		VALUES (@inp_userId, @inp_listingId, @inp_quoteStatusId, @inp_quoteCurrencyId, @inp_quoteAmount, @inp_estimatedTurnaround,
                @inp_useDefaultLocation, @inp_overrideAddressLine1, @inp_overrideAddressLine2, @inp_overrideCountryId,
                @inp_overridePostCode);
	
		SET @ins_rows = @@ROWCOUNT;

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