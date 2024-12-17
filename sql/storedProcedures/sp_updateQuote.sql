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
   @inp_overrideAddressLine1 varchar(500),
   @inp_overrideAddressLine2 varchar(500),
   @inp_overrideCountryId int,
   @inp_overridePostCode varchar(50),
   @upd_rows INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT
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
	)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: quoteId, userId, listingId, quoteStatusId, quoteCurrencyId, quoteAmount, estimatedTurnaround and useDefaultLocation must not be null.';
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
	ELSE IF (@inp_listingId IS NOT NULL
	         AND (SELECT COUNT(*) FROM listings WHERE listingId = @inp_listingId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingId. No active listing could be found for the listingId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteStatusId IS NOT NULL
	         AND (SELECT COUNT(*) FROM quoteStatus WHERE quoteStatusId = @inp_quoteStatusId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quoteStatusId. No active status could be found for the quoteStatusId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteCurrencyId IS NOT NULL
	         AND (SELECT COUNT(*) FROM currency WHERE currencyId = @inp_quoteCurrencyId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quoteCurrencyId. No active currency could be found for the quoteCurrencyId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_overrideCountryId IS NOT NULL
	         AND (SELECT COUNT(*) FROM country WHERE countryId = @inp_overrideCountryId AND ACTIVE = 1) = 0)
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
		UPDATE quotes
		SET
		userId = @inp_userId,
		listingId = @inp_listingId,
		quoteStatusId = @inp_quoteStatusId
        quoteCurrencyId = @inp_quoteCurrencyId = (SELECT quoteCurrencyId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_quoteAmount = (SELECT quoteAmount from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_estimatedTurnaround = (SELECT estimatedTurnaround from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_useDefaultLocation = (SELECT useDefaultLocation from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overrideAddressLine1 = (SELECT overrideAddressLine1 from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overrideAddressLine2 = (SELECT overrideAddressLine2 from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overrideCountryId = (SELECT overrideCountryId from quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1)
             AND @inp_overridePostCode
		emailAddress = @inp_emailAddress,
		firstname = @inp_firstName,
		lastname = @inp_lastName,
		userPassword = ENCRYPTBYPASSPHRASE((SELECT aes_key FROM userAuth WHERE userId = @inp_userId),
		                         @inp_emailAddress + @inp_userPassword + (SELECT salt FROM userAuth WHERE userId = @inp_userId)),
		accountTypeId = @inp_accountTypeId,
		addressLine1 = @inp_addressLine1,
		addressLine2 = @inp_addressLine2,
		postCode = @inp_postCode,
		countryId = @inp_countryId
	WHERE userId = @inp_userId;
	
	SET @upd_rows = @@ROWCOUNT;

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