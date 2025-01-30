USE RepairMart
GO

IF OBJECT_ID('sp_deleteUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_deleteUser;
GO

CREATE PROCEDURE sp_deleteUser
   @inp_userId int,
   @inp_emailAddress nvarchar(500),
   @u_updRows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId int OUTPUT
AS
BEGIN

    SET NOCOUNT ON;
    SET @ERR_IND = 0;
	
	IF (@inp_userId IS NULL OR @inp_emailAddress IS NULL)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input provided: userId and emailAddress must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_userId NOT IN (SELECT id FROM users WHERE ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid User ID provided';
		SET @ERR_IND = 1;
	END
	ELSE IF (SELECT ACTIVE FROM users WHERE userId = @inp_userId) = 0
	BEGIN
		SET @ERR_MESSAGE = 'User ID has already been deactivated.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_emailAddress <> (SELECT emailAddress FROM users WHERE id = @inp_userId AND ACTIVE = 1))
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
		-- Get runID
		INSERT INTO runIds(processName, UPDATED_BY)
		VALUES ('sp_deleteUser', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_deleteUser' AND UPDATED_BY = @inp_userId);

		UPDATE users
		SET ACTIVE = 0 WHERE id = @inp_userId AND emailAddress = @inp_emailAddress;
		
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