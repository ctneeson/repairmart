USE RepairMart
GO

IF OBJECT_ID('sp_authenticateUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_authenticateUser;
GO

CREATE PROCEDURE sp_authenticateUser
    @inp_email nvarchar(500),
    @inp_password nvarchar(100),
    @ERR_MESSAGE nvarchar(500) OUTPUT,
    @ERR_IND BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

    IF (@inp_email IS NULL OR @inp_password IS NULL)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid input: username/password cannot be null.';
        SET @ERR_IND = 1;
    END
    ELSE IF (LEN(@inp_password) < 8 OR LEN(@inp_password) > 100)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid password length. Must be between 3 and 100 characters.';
        SET @ERR_IND = 1;
    END
	ELSE IF ( (NOT (@inp_email LIKE '%_@__%.__%'))
	           OR (LEN(REPLACE(REPLACE(@inp_email, ' ',''),'	','')) <> LEN(@inp_email)) )
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: Please provide a valid email address.';
		SET @ERR_IND = 1;
	END
    ELSE IF (LEN(@inp_password) < 8 OR LEN(@inp_password) > 100)
    BEGIN
        SET @ERR_MESSAGE = 'Invalid password length. Must be between 3 and 100 characters.';
        SET @ERR_IND = 1;
    END

    IF @ERR_IND = 1
    BEGIN
        RAISERROR (@ERR_MESSAGE, 16, 1);
        RETURN;
    END

    SELECT u.id, u.email, ut.accountTypeId
    FROM users u
    JOIN accountType ut ON u.accountTypeId = ut.accountTypeId
	JOIN userAuth ua ON u.id = ua.userId
    WHERE u.email = @inp_email
    AND CAST(DECRYPTBYPASSPHRASE(ua.aes_key, u.password) AS nvarchar(MAX))
	    = @inp_email + @inp_password + ua.salt;
END;
GO