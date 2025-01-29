DECLARE @RC int
DECLARE @inp_userId int
DECLARE @inp_listingStatusId int
DECLARE @inp_manufacturerId int
DECLARE @inp_listingTitle nvarchar(500)
DECLARE @inp_listingDetail nvarchar(4000)
DECLARE @inp_listingBudgetCurrencyId int
DECLARE @inp_listingBudget decimal(10,2)
DECLARE @inp_useDefaultLocation bit
DECLARE @inp_overrideAddressLine1 nvarchar(500)
DECLARE @inp_overrideAddressLine2 nvarchar(500)
DECLARE @inp_overrideCountryId int
DECLARE @inp_overridePostCode nvarchar(50)
DECLARE @inp_listingExpiry int
DECLARE @inp_attachmentUrlList nvarchar(4000)
DECLARE @inp_attachmentHashList nvarchar(4000)
DECLARE @inp_attachmentOrderList nvarchar(100)
DECLARE @inp_productClassificationIdList nvarchar(20)
DECLARE @ins_rows INT
DECLARE @ins_rows_attachments INT
DECLARE @ins_rows_classifications INT
DECLARE @ERR_MESSAGE nvarchar(500)
DECLARE @ERR_IND BIT
DECLARE @out_runId int
DECLARE @out_listingId INT

PRINT 'Executing sp_postNewListing';
EXECUTE @RC = [dbo].[sp_postNewListing]
   1, --userId
   1, --listingStatusId (Open)
   2, --manufacturerId (Acer)
   'Acer Chromebook 314 CB314-4H - screen broken', --listingTitle
   'Detail Detail Detail Detail Detail', --listingDetail
   45, --listingBudgetCurrencyId (GBP)
   75.00, --listingBudget
   1, --useDefaultLocation
   NULL, --overrideAddressLine1
   NULL, --overrideAddressLine2
   NULL, --overrideCountryId
   NULL, --overridePostCode
   30, --listingExpiry
   'TEST/TEST/TEST;CHECK/CHECK/CHECK', --attachmentUrlList
   '1010ABCDEF1010ABCDEF1010ABCDEF;123456789ABCDEF', --attachmentHashList
   '1;2', --attachmentOrderList
   '40;45', --productClassificationIdList (Computer Monitors, Laptop Computers)
   @ins_rows OUTPUT,
   @ins_rows_attachments OUTPUT,
   @ins_rows_classifications OUTPUT,
   @ERR_MESSAGE OUTPUT,
   @ERR_IND OUTPUT,
   @out_runId OUTPUT,
   @out_listingId OUTPUT
GO