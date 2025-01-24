DECLARE @RC int
DECLARE @inp_businessName varchar(255)
DECLARE @inp_firstName varchar(255)
DECLARE @inp_lastName varchar(255)
DECLARE @inp_emailAddress varchar(500)
DECLARE @inp_userPassword varchar(100)
DECLARE @inp_addressLine1 varchar(500)
DECLARE @inp_addressLine2 varchar(500)
DECLARE @inp_countryId int
DECLARE @inp_postCode varchar(255)
DECLARE @inp_accountTypeId int
DECLARE @ins_rows int
DECLARE @ERR_MESSAGE varchar(500)
DECLARE @ERR_IND bit
DECLARE @out_runId bit
DECLARE @out_userId int

PRINT 'Executing sp_postNewUser';
EXECUTE @RC = [dbo].[sp_postNewUser] 
   'Abatz', --businessName
   NULL, --firstName
   NULL, --lastName
   'hstennersw@blogger.com', --emailAddress
   'jE3@q|dEqV', --userPassword
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
