USE RepairMart
GO

IF OBJECT_ID('sp_authenticateUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_authenticateUser;
GO

CREATE PROCEDURE sp_authenticateUser
    @inp_emailAddress nvarchar(500),
    @inp_userPassword nvarchar(100),
    @ERR_MESSAGE nvarchar(500) OUTPUT,
    @ERR_IND BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

    IF (@inp_emailAddress IS NULL OR @inp_userPassword IS NULL)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid input: username/password cannot be null.';
        SET @ERR_IND = 1;
    END
    ELSE IF (LEN(@inp_userPassword) < 8 OR LEN(@inp_userPassword) > 100)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid password length. Must be between 3 and 100 characters.';
        SET @ERR_IND = 1;
    END
	ELSE IF ( (NOT (@inp_emailAddress LIKE '%_@__%.__%'))
	           OR (LEN(REPLACE(REPLACE(@inp_emailAddress, ' ',''),'	','')) <> LEN(@inp_emailAddress)) )
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: Please provide a valid email address.';
		SET @ERR_IND = 1;
	END
    ELSE IF (LEN(@inp_userPassword) < 8 OR LEN(@inp_userPassword) > 100)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid password length. Must be between 3 and 100 characters.';
        SET @ERR_IND = 1;
    END

    IF @ERR_IND = 1
    BEGIN
        RAISERROR (@ERR_MESSAGE, 16, 1);
        RETURN;
    END

    SELECT u.id, u.emailAddress, ut.accountTypeId
    FROM users u
    JOIN accountType ut ON u.accountTypeId = ut.accountTypeId
	JOIN userAuth ua ON u.id = ua.userId
    WHERE u.emailAddress = @inp_emailAddress
    AND CAST(DECRYPTBYPASSPHRASE(ua.aes_key, u.userPassword) AS nvarchar(MAX))
	    = @inp_emailAddress + @inp_userPassword + ua.salt;
END;
GO