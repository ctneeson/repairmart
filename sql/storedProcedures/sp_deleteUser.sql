USE RepairMart
GO

IF OBJECT_ID('sp_deleteUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_deleteUser;
GO

CREATE PROCEDURE sp_deleteUser
   @inp_userId int,
   @inp_emailAddress VARCHAR(500),
   @u_updRows INT OUTPUT,
   @ERR_MESSAGE VARCHAR(500) OUTPUT,
   @ERR_IND BIT OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_userId IS NULL OR @inp_emailAddress IS NULL)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: userId and emailAddress must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_userId NOT IN (SELECT userId FROM users WHERE ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid User ID provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (SELECT ACTIVE FROM users WHERE userId = @inp_userId) = 0
	BEGIN
		SET @ERR_MESSAGE = 'User ID has already been deactivated.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_emailAddress <> (SELECT emailAddress FROM users WHERE userId = @inp_userId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid emailAddress provided';
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
		SET ACTIVE = 0 WHERE userId = @inp_userId AND emailAddress = @inp_emailAddress;
		
		SET @u_updRows = @@ROWCOUNT;

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