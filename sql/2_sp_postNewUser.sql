USE RepairMart
GO

IF OBJECT_ID('sp_postNewUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_postNewUser;
GO

CREATE PROCEDURE sp_postNewUser
   @inp_businessName nvarchar(255),
   @inp_firstName nvarchar(255),
   @inp_lastName nvarchar(255),
   @inp_emailAddress nvarchar(500),
   @inp_userPassword nvarchar(100),
   @inp_addressLine1 nvarchar(500),
   @inp_addressLine2 nvarchar(500),
   @inp_countryId INT,
   @inp_postCode nvarchar(255),
   @inp_accountTypeId INT,
   @ins_rows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId int OUTPUT,
   @out_userId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_emailAddress IS NULL
		OR @inp_userPassword IS NULL
		OR @inp_accountTypeId IS NULL
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). emailAddress, userPassword and accountTypeId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_emailAddress IS NOT NULL
	         AND EXISTS (SELECT 1 FROM users WHERE emailAddress = @inp_emailAddress AND ACTIVE = 1))
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
	ELSE IF (@inp_accountTypeId IN (SELECT accountTypeId FROM accountType WHERE accountTypeName = 'Business' AND ACTIVE = 1)
	         AND LEN(REPLACE(REPLACE(@inp_businessName,' ', ''),'	','')) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: businessName must be populated for Business users.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_accountTypeId IN (SELECT accountTypeId FROM accountType WHERE accountTypeName = 'Personal' AND ACTIVE = 1)
	         AND (LEN(REPLACE(REPLACE(@inp_firstName,' ', ''),'	','')) = 0
			      OR LEN(REPLACE(REPLACE(@inp_lastName,' ', ''),'	','')) = 0))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: firstName and lastName must be populated for Personal users.';
		SET @ERR_IND = 1;
	END
	ELSE IF NOT (@inp_emailAddress LIKE '%_@__%.__%')
	BEGIN
		SET @ERR_MESSAGE = 'Invalid email address provided. Email syntax is not correct.';
		SET @ERR_IND = 1;
	END
	ELSE IF (LEN(@inp_userPassword) < 3 OR LEN(@inp_userPassword) > 100)
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
			emailAddress NVARCHAR(500),
			salt NVARCHAR(8),
			aes_key NVARCHAR(50)
		);

		INSERT INTO #temp_userenc (emailAddress, salt, aes_key)
		VALUES (@inp_emailAddress, LEFT(NEWID(), 8), LEFT(NEWID(), 50));
	
		INSERT INTO users(businessName, firstName, lastName, userPassword, emailAddress,
						  addressLine1, addressLine2, countryId, postCode, accountTypeId, runId)
		SELECT @inp_businessName,
		    @inp_firstName,
			@inp_lastName,
			ENCRYPTBYPASSPHRASE(ue.aes_key, @inp_emailAddress + @inp_userPassword + ue.salt),
			@inp_emailAddress,
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
		 ON u.emailAddress = ue.emailAddress
		WHERE u.id = @out_userId
		AND u.emailAddress = @inp_emailAddress;

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