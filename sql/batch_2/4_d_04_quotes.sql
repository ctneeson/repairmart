DECLARE @RC int
DECLARE @inp_userId bigint
DECLARE @inp_listingId bigint
DECLARE @inp_quoteStatusId bigint
DECLARE @inp_quoteCurrencyId bigint
DECLARE @inp_quoteAmount DECIMAL(10,2)
DECLARE @inp_estimatedTurnaround INT
DECLARE @inp_useDefaultLocation bit
DECLARE @inp_overrideAddressLine1 varchar(500)
DECLARE @inp_overrideAddressLine2 varchar(500)
DECLARE @inp_overrideCountryId bigint
DECLARE @inp_overridePostCode varchar(50)
DECLARE @inp_deliveryMethodIdList nvarchar(50)
DECLARE @inp_deliveryAmountList nvarchar(100)
DECLARE @ins_rows INT
DECLARE @ins_rows_deliveryMethod INT
DECLARE @ERR_MESSAGE VARCHAR(500)
DECLARE @ERR_IND BIT
DECLARE @out_runId bigint
DECLARE @out_quoteId bigint

PRINT 'Executing sp_postNewQuote';
EXECUTE @RC = [dbo].[sp_postNewQuote]
   1, --userId
   1, --listingId
   1, --quoteStatusId (Open)
   45, --quoteCurrencyId (GBP)
   62.50, --quoteAmount
   5, --estimatedTurnaround
   1, --useDefaultLocation
   NULL, --overrideAddressLine1
   NULL, --overrideAddressLine2
   NULL, --overrideCountryId
   NULL, --overridePostCode
   '1;2', --deliveryMethodIdList
   '0;5.99', --deliveryMethodAmountList
   @ins_rows OUTPUT,
   @ins_rows_deliveryMethod OUTPUT,
   @ERR_MESSAGE OUTPUT,
   @ERR_IND OUTPUT,
   @out_runId OUTPUT,
   @out_quoteId OUTPUT
GO
