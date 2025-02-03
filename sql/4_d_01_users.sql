DECLARE @RC int
--DECLARE @inp_businessName nvarchar(255)
--DECLARE @inp_firstName nvarchar(255)
--DECLARE @inp_lastName nvarchar(255)
DECLARE @inp_name nvarchar(255)
DECLARE @inp_email nvarchar(255)
DECLARE @inp_password nvarchar(100)
DECLARE @inp_addressLine1 nvarchar(500)
DECLARE @inp_addressLine2 nvarchar(500)
DECLARE @inp_countryId int
DECLARE @inp_postCode nvarchar(255)
DECLARE @inp_accountTypeId int
DECLARE @ins_rows int
DECLARE @ERR_MESSAGE nvarchar(500)
DECLARE @ERR_IND bit
DECLARE @out_runId bit
DECLARE @out_userId int

PRINT 'Executing sp_postNewUser';
EXECUTE @RC = [dbo].[sp_postNewUser] 
--   'Abatz', --businessName
--   NULL, --firstName
--   NULL, --lastName
   'Abatz', --name
   'hstennersw@blogger.com', --email
   NULL, --email_verified_at
   'jE3@q|dEqV', --password
   NULL, --remember_token
   '58 Blackbird Avenue', --addressLine1
   'PO Box 40080', --addressLine2
   50, --countryId
   '374 01', --postCode
   2, --accountTypeId (Customer)
   @ins_rows OUTPUT,
   @ERR_MESSAGE OUTPUT,
   @ERR_IND OUTPUT,
   @out_runId OUTPUT,
   @out_userId OUTPUT
GO
