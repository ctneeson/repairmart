USE RepairMart
GO

IF OBJECT_ID('sp_updateOrder', 'P') IS NOT NULL
    DROP PROCEDURE sp_updateOrder;
GO

CREATE PROCEDURE sp_updateOrder
   @inp_userId int,
   @inp_orderId int,
   @inp_orderStatusId int,
   @inp_attachmentUrlList nvarchar(4000),
   @inp_attachmentHashList nvarchar(4000),
   @upd_rows INT OUTPUT,
   @ins_rows_attachments INT OUTPUT,
   @del_rows_attachments INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_orderId IS NULL
		OR @inp_orderStatusId IS NULL
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). orderId and orderStatusId must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_orderStatusId IS NOT NULL
	         AND (SELECT COUNT(*) FROM orderStatus WHERE orderStatusId = @inp_orderStatusId AND ACTIVE = 1) = 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid orderStatusId. No active orderStatus could be found with the orderStatusId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF LEN(@inp_attachmentUrlList) > 5000
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input: attachmentUrlList. Length must not be greater than 5000 characters.';
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
		IF OBJECT_ID('tempdb..#temp_orderAttachments') IS NOT NULL
		DROP TABLE #temp_orderAttachments;
		
		CREATE TABLE #temp_orderAttachments (
			attachmentUrl nvarchar(1000),
			hashValue nvarchar(1000),
			rowNum INT
		);
		INSERT INTO #temp_orderAttachments (attachmentUrl, hashValue, rowNum)
		SELECT u.value, h.value, u.ordinal
		FROM STRING_SPLIT(@inp_attachmentUrlList,';',1) u
		JOIN STRING_SPLIT(@inp_attachmentHashList,';',1) h
		ON u.ordinal = h.ordinal;

		WHILE (@attachmentIterator <= (SELECT MAX(rowNum) FROM #temp_orderAttachments))
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM #temp_orderAttachments
			               WHERE rowNum = @attachmentIterator
						   AND LEN(REPLACE(REPLACE(attachmentUrl,' ',''),'	',''))>0)
			BEGIN
				SET @ERR_MESSAGE = 'Invalid input: attachmentUrlList. Attachment URLs must not be empty.';
				SET @ERR_IND = 1;
				BREAK;
			END
			ELSE IF NOT EXISTS (SELECT 1 FROM #temp_orderAttachments
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
	ELSE IF (@inp_orderStatusId = (SELECT orderStatusId FROM orders WHERE orderId = @inp_orderId)
			 AND ( (SELECT CHECKSUM_AGG(CHECKSUM(CAST(value AS int))) FROM STRING_SPLIT(@inp_attachmentHashList, ';'))
			     = (SELECT CHECKSUM_AGG(CHECKSUM(a.hashValue)) FROM listings_attachments la
                                                               JOIN attachments a ON la.attachmentId = a.attachmentId) )
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
		VALUES ('sp_updateOrder', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_updateOrder' AND UPDATED_BY = @inp_userId);

		/*--- ORDERS ---*/
		-- Update order
		UPDATE orders
		SET orderStatusId = @inp_orderStatusId,
		    runId = @out_runId
		WHERE orderId = @inp_orderId
		AND orderStatusId <> @inp_orderStatusId;
	
		SET @upd_rows = @@ROWCOUNT;

		/*--- ATTACHMENTS ---*/
		-- Delete records from orders_attachments which are no longer associated with the order
		SET @del_rows_attachments = (SELECT COUNT(*) FROM orders_attachments WHERE orderId = @inp_orderId
		                              AND attachmentId NOT IN (SELECT attachmentId FROM attachments
		                                                       WHERE hashValue IN (SELECT hashValue FROM #temp_orderAttachments))
									 );

		DELETE FROM orders_attachments
		WHERE orderId = @inp_orderId
		AND attachmentId NOT IN (SELECT attachmentId FROM attachments
		                         WHERE hashValue IN (SELECT hashValue FROM #temp_orderAttachments)
								);

		-- Insert records into attachments if not already present
		INSERT INTO attachments (attachmentUrl, hashValue, runId)
		SELECT attachmentUrl, hashValue, @out_runId FROM #temp_orderAttachments
		WHERE hashValue NOT IN (SELECT hashValue FROM attachments);

		-- Insert records into listings_attachments if not already associated with the listing
		INSERT INTO orders_attachments(orderId, attachmentId, runId)
		SELECT @inp_orderId, a.attachmentId, @out_runId
		FROM attachments a
		JOIN #temp_orderAttachments t
		 ON a.hashValue = t.hashValue
		WHERE a.runId = @out_runId;

		SET @ins_rows_attachments = (SELECT COUNT(*) FROM orders_attachments WHERE orderId = @inp_orderId AND runId = @out_runId);

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