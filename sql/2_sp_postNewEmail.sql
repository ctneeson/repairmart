USE RepairMart
GO

IF OBJECT_ID('sp_postNewEmail', 'P') IS NOT NULL
    DROP PROCEDURE sp_postNewEmail;
GO

CREATE PROCEDURE sp_postNewEmail
   @inp_emailFromId int,
   @inp_listingId int,
   @inp_quoteId int,
   @inp_orderId int,
   @inp_emailRecipients nvarchar(100),
   @inp_emailSubject nvarchar(255),
   @inp_emailContent nvarchar(max),
   @inp_attachmentUrlList nvarchar(4000),
   @inp_attachmentHashList nvarchar(4000),
   @ins_rows INT OUTPUT,
   @ins_rows_recipients INT OUTPUT,
   @ins_rows_attachments INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId INT OUTPUT,
   @out_emailId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_emailFromId IS NULL
		OR @inp_emailContent IS NULL
		OR LEN(REPLACE(REPLACE(@inp_emailContent,' ',''),'	','')) = 0
		OR LEN(REPLACE(REPLACE(REPLACE(@inp_emailRecipients,' ',''),'	',''),';','')) = 0
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s): emailFromId, emailContent and emailRecipients must not be null. emailContent and emailRecipients must not contain only empty spaces.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_emailFromId IS NOT NULL
	         AND (SELECT COUNT(*) FROM users WHERE id = @inp_emailFromId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: emailFromId. No active user could be found for the emailFromId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingId IS NOT NULL
	         AND (SELECT COUNT(*) FROM listings WHERE listingId = @inp_listingId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: listingId. No active listing could be found for the listingId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quoteId IS NOT NULL
	         AND (SELECT COUNT(*) FROM quotes WHERE quoteId = @inp_quoteId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: quoteId. No active quote could be found for the quoteId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_orderId IS NOT NULL
	         AND (SELECT COUNT(*) FROM orders WHERE orderId = @inp_orderId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: orderId. No active order could be found for the orderId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_emailSubject) > 255
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: emailSubject. Length must not be greater than 255 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_emailRecipients) > 100
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: emailRecipients. Length must not be greater than 100 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_emailRecipients) <= 100
	BEGIN
		-- Validate email recipients in ;-delimited list
		DECLARE @recipientIterator INT;
		SET @recipientIterator = 1;
		IF OBJECT_ID('tempdb..#temp_emailRecipients') IS NOT NULL
		DROP TABLE #temp_emailRecipients;
		
		CREATE TABLE #temp_emailRecipients (
			emailRecipient nvarchar(20),
			rowNum INT
		);

		INSERT INTO #temp_emailRecipients (emailRecipient, rowNum)
		SELECT value, ordinal FROM STRING_SPLIT(@inp_emailRecipients,';',1);

		WHILE (@recipientIterator <= (SELECT MAX(rowNum) FROM #temp_emailRecipients))
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM #temp_emailRecipients
			               WHERE rowNum = @recipientIterator
						   AND emailRecipient LIKE '%[^0-9]%')
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: emailRecipients. Recipient IDs must be positive integers.';
				SET @ERR_IND = 1;
				BREAK;
			END
			ELSE IF NOT EXISTS (SELECT 1 FROM users
			                    WHERE ACTIVE = 1
								AND id = (SELECT CAST(emailRecipient AS INT)
								          FROM #temp_emailRecipients
			                              WHERE rowNum = @recipientIterator))
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: emailRecipients. A Recipient ID could not be found in list of active users.';
				SET @ERR_IND = 1;
				BREAK;
			END
		SET @recipientIterator = @recipientIterator + 1;
		END
	END
	ELSE IF LEN(@inp_attachmentUrlList) > 5000
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: emailAttachmentList. Length must not be greater than 5000 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_attachmentHashList) > 5000
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: attachmentHashList. Length must not be greater than 5000 characters.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_attachmentUrlList) <= 5000 AND LEN(@inp_attachmentHashList) <= 5000
	BEGIN
		-- Validate email attachments in ;-delimited list
		DECLARE @attachmentIterator INT;
		SET @attachmentIterator = 1;
		IF OBJECT_ID('tempdb..#temp_emailAttachments') IS NOT NULL
		DROP TABLE #temp_emailAttachments;
		
		CREATE TABLE #temp_emailAttachments (
			attachmentUrl nvarchar(1000),
			hashValue nvarchar(1000),
			rowNum INT
		);
		INSERT INTO #temp_emailAttachments (attachmentUrl, hashValue, rowNum)
		SELECT u.value, h.value, u.ordinal
		FROM STRING_SPLIT(@inp_attachmentUrlList,';',1) u
		JOIN STRING_SPLIT(@inp_attachmentHashList,';',1) h
		ON u.ordinal = h.ordinal;

		WHILE (@attachmentIterator <= (SELECT MAX(rowNum) FROM #temp_emailAttachments))
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM #temp_emailAttachments
			               WHERE rowNum = @attachmentIterator
						   AND LEN(REPLACE(REPLACE(attachmentUrl,' ',''),'	',''))>0)
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: attachmentUrlList. Attachment URLs must not be empty.';
				SET @ERR_IND = 1;
				BREAK;
			END
			ELSE IF NOT EXISTS (SELECT 1 FROM #temp_emailAttachments
			                    WHERE rowNum = @attachmentIterator
						        AND LEN(REPLACE(REPLACE(hashValue,' ',''),'	',''))>0)
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: attachmentHashList. Attachment hash values must not be empty.';
				SET @ERR_IND = 1;
				BREAK;
			END
		SET @attachmentIterator = @attachmentIterator + 1;
		END
	END

	IF @ERR_IND = 1
	BEGIN
		RAISERROR (@ERR_MESSAGE, 16, 1);
		RETURN;
	END

	BEGIN TRANSACTION;

	BEGIN TRY;
		INSERT INTO runIds(processName, UPDATED_BY)
		VALUES ('sp_postNewEmail', @inp_emailFromId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_postNewEmail' AND UPDATED_BY = @inp_emailFromId);

		INSERT INTO emails(emailFromId, listingId, quoteId, orderId, emailSubject, emailContent, runId)
		VALUES (@inp_emailFromId,
		        @inp_listingId,
				@inp_quoteId,
				@inp_orderId,
				@inp_emailSubject,
				@inp_emailContent,
				@out_runId);
	
		SET @ins_rows = @@ROWCOUNT;
		SET @out_emailId = (SELECT MAX(emailId) from emails WHERE runId = @out_runId);

		SET @recipientIterator = 1;
		WHILE (@recipientIterator <= (SELECT MAX(rowNum) FROM #temp_emailRecipients))
		BEGIN
			INSERT INTO emails_recipients(emailId, recipientUserId, runId)
			SELECT @out_emailId, CAST(emailRecipient AS int), @out_runId
			FROM #temp_emailRecipients WHERE rowNum = @recipientIterator;

			SET @recipientIterator = @recipientIterator + 1;
		END
		SET @ins_rows_recipients = (SELECT COUNT(*) FROM emails_recipients
		                             WHERE emailId = @out_emailId
									 AND runId = @out_runId);

		SET @attachmentIterator = 1;
		WHILE (@attachmentIterator <= (SELECT MAX(rowNum) FROM #temp_emailAttachments))
		BEGIN
			DECLARE @out_attachmentId int;

			INSERT INTO attachments(attachmentUrl, hashValue, runId)
			SELECT attachmentUrl, hashValue, @out_runId
			FROM #temp_emailAttachments WHERE rowNum = @attachmentIterator;

			SET @out_attachmentId = (SELECT MAX(attachmentId) FROM attachments
			                         WHERE runId = @out_runId);

			INSERT INTO emails_attachments(emailId, attachmentId, runId)
			VALUES(@out_emailId, @out_attachmentId, @out_runId);

			SET @attachmentIterator = @attachmentIterator + 1;
		END
		SET @ins_rows_attachments = (SELECT COUNT(*) FROM attachments
		                             WHERE runId = @out_runId);

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