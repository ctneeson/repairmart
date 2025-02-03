USE RepairMart
GO

IF OBJECT_ID('sp_postNewOrder', 'P') IS NOT NULL
    DROP PROCEDURE sp_postNewOrder;
GO

CREATE PROCEDURE sp_postNewOrder
   @inp_userId bigint,
   @inp_listingId bigint,
   @inp_quote_deliveryMethodId bigint,
   @inp_orderStatusId bigint,
   @inp_overrideQuoteAmount decimal(10,2),
   @inp_overrideQuote bit,
   @ins_rows INT OUTPUT,
   @ERR_MESSAGE nvarchar(500) OUTPUT,
   @ERR_IND BIT OUTPUT,
   @out_runId bigint OUTPUT,
   @out_orderId bigint OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ERR_IND = 0;

	IF (@inp_listingId IS NULL
	    OR @inp_userId IS NULL
	    OR @inp_quote_deliveryMethodId IS NULL
		OR @inp_orderStatusId IS NULL
		OR @inp_overrideQuote IS NULL
		)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). listingId, userId, quote_deliveryMethodId, orderStatusId and overrideQuote must not be null.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_overrideQuote = 1
	         AND @inp_overrideQuoteAmount IS NULL)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid input(s). When overrideQuote is true, overrideQuoteAmount must be populated.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_overrideQuote = 1
	         AND (SELECT TRY_CAST(@inp_overrideQuoteAmount AS DECIMAL(10,2) ) ) IS NULL)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid overrideQuoteAmount. If overrideQuote is true, overrideQuoteAmount must be in DECIMAL(10,2) format.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_overrideQuote = 1 AND @inp_overrideQuoteAmount < 0)
	BEGIN
		SET @ERR_MESSAGE = 'Invalid overrideQuoteAmount. If overrideQuote is true, overrideQuoteAmount must not be negative.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_listingId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM listings WHERE listingId = @inp_listingId AND ACTIVE = 1)
			 )
	BEGIN
		SET @ERR_MESSAGE = 'Invalid listingId. No active listing could be found for the listingId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_quote_deliveryMethodId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM quotes_deliveryMethod WHERE quote_deliveryMethodId = @inp_quote_deliveryMethodId))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid quote_deliveryMethodId. No active quote could be found with the quote_deliveryMethodId provided.';
		SET @ERR_IND = 1;
	END
	ELSE IF (@inp_orderStatusId IS NOT NULL
	         AND NOT EXISTS (SELECT 1 FROM orderStatus WHERE orderStatusId = @inp_orderStatusId AND ACTIVE = 1))
	BEGIN
		SET @ERR_MESSAGE = 'Invalid orderStatusId. No active orderStatus could be found with the orderStatusId provided.';
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
		VALUES ('sp_postNewOrder', @inp_userId);
		SET @out_runId = (SELECT MAX(runId) from runIds WHERE processName = 'sp_postNewOrder' AND UPDATED_BY = @inp_userId);

		-- insert order
		INSERT INTO orders(listingId, quote_deliveryMethodId, orderStatusId, overrideQuoteAmount, overrideQuote, runId)
		VALUES (@inp_listingId, @inp_quote_deliveryMethodId, @inp_orderStatusId, @inp_overrideQuoteAmount,
		        @inp_overrideQuote, @out_runId);
	
		SET @ins_rows = @@ROWCOUNT;
		SET @out_orderId = (SELECT MAX(orderId) from orders WHERE runId = @out_runId);

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