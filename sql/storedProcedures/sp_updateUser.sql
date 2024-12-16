USE RepairMart
GO

IF OBJECT_ID('sp_updateUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_updateUser;
GO

CREATE PROCEDURE sp_updateUser
   @inp_userId int,
   @inp_firstName VARCHAR(255),
   @inp_lastName VARCHAR(255),
   @inp_emailAddress VARCHAR(500),
   @inp_userPassword VARCHAR(100),
   @inp_addressLine1 VARCHAR(500),
   @inp_addressLine2 VARCHAR(500),
   @inp_countryId INT,
   @inp_postCode VARCHAR(255),
   @inp_accountTypeId INT,
   @upd_rows INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_userId IS NULL
	    OR @inp_firstName IS NULL
	    OR @inp_lastName IS NULL
		OR @inp_emailAddress IS NULL
		OR @inp_userPassword IS NULL
		OR @inp_accountTypeId IS NULL
	)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: firstName, lastName, emailAddress, userPassword and accountTypeId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_userId NOT IN (SELECT userId FROM users))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid User ID provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_accountTypeId NOT IN (SELECT accountTypeId FROM accountType))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid account type provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (LEN(@inp_userPassword) < 3 OR LEN(@inp_userPassword) > 100)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid password length.';
		SET @ERR_IND = 1;
	END
	/* Validate other input lengths */
--	ELSE IF
--	BEGIN
--	END
	ELSE IF NOT (@inp_emailAddress LIKE '%_@__%.__%')
	BEGIN
		SET @ERR_MESSAGE = 'Invalid email address provided. Email syntax is not correct.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_emailAddress = (SELECT emailAddress FROM users WHERE userId = @inp_userId)
         AND @inp_firstName = (SELECT firstName FROM users WHERE userId = @inp_userId)
         AND @inp_lastName = (SELECT lastName FROM users WHERE userId = @inp_userId)
         AND ENCRYPTBYPASSPHRASE((SELECT aes_key FROM userAuth WHERE userId = @inp_userId),
		                         @inp_emailAddress, @inp_userPassword, (SELECT salt FROM userAuth WHERE userId = @inp_userId))
			                  = (SELECT userPassword FROM users WHERE userId = @inp_userId)
         AND @inp_accountTypeId = (SELECT ut.accountTypeId
		                 FROM accountType ut
						 JOIN users u
						 ON ut.accountTypeId = u.accountTypeId
						 AND u.userId = @inp_userId)
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
		UPDATE users
		SET
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