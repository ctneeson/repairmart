USE RepairMart
GO

IF OBJECT_ID('sp_updateUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_updateUser;
GO

CREATE PROCEDURE sp_updateUser
   @inp_userId bigint,
   --@inp_businessName nvarchar(255),
   --@inp_firstName nvarchar(255),
   --@inp_lastName nvarchar(255),
   @inp_name nvarchar(255),
   @inp_email nvarchar(255),
   @inp_password nvarchar(100),
   @inp_addressLine1 nvarchar(500),
   @inp_addressLine2 nvarchar(500),
   @inp_countryId bigint,
   @inp_postCode nvarchar(255),
   @inp_accountTypeId bigint,
   @upd_rows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId bigint OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_userId IS NULL
        OR @inp_name IS NULL
		OR @inp_email IS NULL
		OR @inp_password IS NULL
		OR @inp_accountTypeId IS NULL
	)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: email, password and accountTypeId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(REPLACE(REPLACE(@inp_name,' ', ''),'	','')) = 0
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: name must not be empty and cannot contain only spaces.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(REPLACE(REPLACE(@inp_name,' ', ''),'	','')) > 255
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: name length must not exceed 255 characters.';
		SET @ERR_IND = 1;
	END
--	ELSE IF EXISTS (SELECT 1 FROM accountType WHERE accountTypeId = @inp_accountTypeId AND accountTypeName = 'Business' AND ACTIVE = 1)
--	         AND LEN(REPLACE(REPLACE(@inp_businessName,' ', ''),'	','')) = 0)
--	BEGIN
--		SET @ERR_MESSAGE = 'Invalid input provided: businessName must be populated for Business users.';
--		SET @ERR_IND = 1;
--	END
--	ELSE IF EXISTS (SELECT 1 FROM accountType WHERE accountTypeId = @inp_accountTypeId AND accountTypeName = 'Personal' AND ACTIVE = 1)
--	         AND (LEN(REPLACE(REPLACE(@inp_firstName,' ', ''),'	','')) = 0
--			      OR LEN(REPLACE(REPLACE(@inp_lastName,' ', ''),'	','')) = 0))
--	BEGIN
--		SET @ERR_MESSAGE = 'Invalid input provided: firstName and lastName must be populated for Personal users.';
--		SET @ERR_IND = 1;
--	END
	ELSE IF NOT EXISTS (SELECT 1 FROM users WHERE id = @inp_userId AND ACTIVE = 1)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid User ID provided';
		SET @ERR_IND = 1;
	END
	ELSE IF NOT EXISTS (SELECT 1 FROM accountType WHERE accountTypeId = @inp_accountTypeId AND ACTIVE = 1)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid account type provided';
		SET @ERR_IND = 1;
	END
	ELSE IF NOT EXISTS (SELECT 1 FROM country WHERE countryId = @inp_countryId AND ACTIVE = 1)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid country provided';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_password) < 3 OR LEN(@inp_password) > 100
	BEGIN
		SET @ERR_MESSAGE = 'Invalid password length. Pasword must be between 3 and 100 characters';
		SET @ERR_IND = 1;
	END
--	ELSE IF LEN(@inp_firstName) > 255 OR LEN(@inp_lastName) > 255
--	BEGIN
--		SET @ERR_MESSAGE = 'Invalid name length. firstName and lastName must not exceed 255 characters/';
--		SET @ERR_IND = 1;
--	END
	ELSE IF LEN(@inp_email) > 500
	BEGIN
		SET @ERR_MESSAGE = 'Invalid email length. emailAddrss must not exceed 500 characters/';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_addressLine1) > 500 OR LEN(@inp_addressLine2) > 500
	BEGIN
		SET @ERR_MESSAGE = 'Invalid address length. addressLine1 and addressLine2 must not exceed 500 characters/';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_postCode) > 255
	BEGIN
		SET @ERR_MESSAGE = 'Invalid postCode length. postCode must not exceed 255 characters/';
		SET @ERR_IND = 1;
	END
	ELSE IF NOT (@inp_email LIKE '%_@__%.__%')
	BEGIN
		SET @ERR_MESSAGE = 'Invalid email address provided. Email syntax is not correct.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_email = (SELECT email FROM users WHERE id = @inp_userId AND ACTIVE = 1)
--			AND @inp_firstName = (SELECT firstName FROM users WHERE id = @inp_userId AND ACTIVE = 1)
--			AND @inp_lastName = (SELECT lastName FROM users WHERE id = @inp_userId AND ACTIVE = 1)
			AND @inp_name = (SELECT [name] FROM users WHERE id = @inp_userId AND ACTIVE = 1)
			AND ENCRYPTBYPASSPHRASE((SELECT aes_key FROM userAuth WHERE userId = @inp_userId),
			                           @inp_email
									 + @inp_password
									 + (SELECT salt FROM userAuth WHERE userId = @inp_userId)
									)
				                  = (SELECT password FROM users WHERE id = @inp_userId AND ACTIVE = 1)
			AND @inp_accountTypeId = (SELECT ut.accountTypeId FROM accountType ut
									  JOIN users u ON ut.accountTypeId = u.accountTypeId
									  AND u.id = @inp_userId)
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
		VALUES ('sp_updateUser', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_updateUser' AND UPDATED_BY = @inp_userId);

		UPDATE users
		SET
		 email = @inp_email,
--		 firstname = @inp_firstName,    
--		 lastname = @inp_lastName,    
		 [name] = @inp_name,    
		 password = ENCRYPTBYPASSPHRASE((SELECT aes_key FROM userAuth WHERE userId = @inp_userId),    
		                                   @inp_email    
		 						         + @inp_password    
		 						         + (SELECT salt FROM userAuth WHERE userId = @inp_userId) ),
		 accountTypeId = @inp_accountTypeId,    
		 addressLine1 = @inp_addressLine1,    
		 addressLine2 = @inp_addressLine2,    
		 postCode = @inp_postCode,    
		 countryId = @inp_countryId,    
		 runId = @out_runId
	    WHERE id = @inp_userId;
	
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
