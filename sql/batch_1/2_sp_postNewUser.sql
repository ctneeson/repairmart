USE RepairMart
GO

IF OBJECT_ID('sp_postNewUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_postNewUser;
GO

CREATE PROCEDURE sp_postNewUser
--   @inp_businessName nvarchar(255),
--   @inp_firstName nvarchar(255),
--   @inp_lastName nvarchar(255),
   @inp_name nvarchar(255),
   @inp_email nvarchar(255),
   @inp_password nvarchar(100),
   @inp_addressLine1 nvarchar(500),
   @inp_addressLine2 nvarchar(500),
   @inp_countryId bigint,
   @inp_postCode nvarchar(255),
   @inp_accountTypeId bigint,
   @ins_rows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId bigint OUTPUT,
   @out_userId bigint OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_email IS NULL
        OR @inp_name IS NULL
		OR @inp_password IS NULL
		OR @inp_accountTypeId IS NULL
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). email, name, password and accountTypeId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_email IS NOT NULL
	         AND EXISTS (SELECT 1 FROM users WHERE email = @inp_email AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid email address. A user account with the same address already exists.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_accountTypeId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM accountType WHERE accountTypeId = @inp_accountTypeId))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid account type provided';
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
--	ELSE IF (@inp_accountTypeId IN (SELECT accountTypeId FROM accountType WHERE accountTypeName = 'Business' AND ACTIVE = 1)
--	         AND LEN(REPLACE(REPLACE(@inp_businessName,' ', ''),'	','')) = 0)
--	BEGIN
--		SET @ERR_MESSAGE = 'Invalid input provided: businessName must be populated for Business users.';
--		SET @ERR_IND = 1;
--	END
--	ELSE IF (@inp_accountTypeId IN (SELECT accountTypeId FROM accountType WHERE accountTypeName = 'Personal' AND ACTIVE = 1)
--	         AND (LEN(REPLACE(REPLACE(@inp_firstName,' ', ''),'	','')) = 0
--			      OR LEN(REPLACE(REPLACE(@inp_lastName,' ', ''),'	','')) = 0))
--	BEGIN
--		SET @ERR_MESSAGE = 'Invalid input provided: firstName and lastName must be populated for Personal users.';
--		SET @ERR_IND = 1;
--	END
	ELSE IF NOT (@inp_email LIKE '%_@__%.__%')
	BEGIN
		SET @ERR_MESSAGE = 'Invalid email address provided. Email syntax is not correct.';
		SET @ERR_IND = 1;
	END
	ELSE IF (LEN(@inp_password) < 3 OR LEN(@inp_password) > 100)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid password length.';
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
		VALUES ('sp_postNewUser', 1); -- User 1 is RepairMart admin account
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_postNewUser' AND UPDATED_BY = 1);

		-- Create temp table
		IF OBJECT_ID('tempdb..#temp_userenc') IS NOT NULL
			DROP TABLE #temp_userenc;

		CREATE TABLE #temp_userenc (
			email NVARCHAR(500),
			salt NVARCHAR(8),
			aes_key NVARCHAR(50)
		);

		INSERT INTO #temp_userenc (email, salt, aes_key)
		VALUES (@inp_email, LEFT(NEWID(), 8), LEFT(NEWID(), 50));
	
		INSERT INTO users(--businessName, firstName, lastName,
                          [name], [password], email,
						  addressLine1, addressLine2, countryId, postCode, accountTypeId, runId)
		SELECT --@inp_businessName,
		    --@inp_firstName,
			--@inp_lastName,
			@inp_name,
			ENCRYPTBYPASSPHRASE(ue.aes_key, @inp_email + @inp_password + ue.salt),
			@inp_email,
			@inp_addressLine1,
			@inp_addressLine2,
			@inp_countryId,
			@inp_postCode,
			@inp_accountTypeId,
			@out_runId
		FROM #temp_userenc ue;

		SET @out_userId = (SELECT MAX(id) FROM users WHERE runId = @out_runId);
		SET @ins_rows = @@ROWCOUNT;

		-- Create salt for new user and update password to encrypt it
		INSERT INTO userAuth(userId, salt, aes_key)
		SELECT u.id, ue.salt, ue.aes_key
		FROM users u
		JOIN #temp_userenc ue
		 ON u.email = ue.email
		WHERE u.id = @out_userId
		AND u.email = @inp_email;

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
