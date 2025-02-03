DECLARE @RC int
DECLARE @inp_userId bigint
DECLARE @inp_listingId bigint
DECLARE @inp_quote_deliveryMethodId bigint
DECLARE @inp_orderStatusId bigint
DECLARE @inp_overrideQuoteAmount decimal(10,2)
DECLARE @inp_overrideQuote bit
DECLARE @ins_rows INT
DECLARE @ERR_MESSAGE nvarchar(500)
DECLARE @ERR_IND BIT
DECLARE @out_runId bigint
DECLARE @out_orderId bigint

PRINT 'Executing sp_postNewOrder';
EXECUTE @RC = [dbo].[sp_postNewOrder]
   2, --userId
   1, --listingId
   1, --quote_deliveryMethodId
   1, --orderStatusId (Created)
   NULL, --overrideQuoteAmount
   0, --overrideQuote
   @ins_rows OUTPUT,
   @ERR_MESSAGE OUTPUT,
   @ERR_IND OUTPUT,
   @out_runId OUTPUT,
   @out_orderId OUTPUT
GO
