-- Set up System Admin user
DECLARE @sysSalt NVARCHAR(8) = LEFT(NEWID(), 8);
DECLARE @sysAESKey NVARCHAR(50) = LEFT(NEWID(), 50);
DECLARE @sysemail nvarchar(500) = 'system@repairmart.com';
DECLARE @sysPassword nvarchar(100) = 'password';

INSERT INTO users(--businessName, firstName, lastName,
                  [name], email, email_verified_at, [password], remember_token, addressLine1, addressLine2, countryId, postCode, accountTypeId, runId)
VALUES (--'RepairMart', --businessName
        --NULL, --firstName
		--NULL, --lastName
		'RepairMart', --name
		'system@repairmart.com', --email
		NULL, --email_verified_at
		ENCRYPTBYPASSPHRASE(@sysAESKey, @sysemail + @sysPassword + @sysSalt), --password
		NULL, --remember_token
		NULL, --addressLine1
		NULL, --addressLine2
		NULL, --countryId
		NULL, --postCode
		3, --accountTypeId
		0); --runId
INSERT INTO userAuth(userId, salt, aes_key)
SELECT MAX(id), @sysSalt, @sysAESKey FROM users WHERE runId = 0;


DECLARE @RC int
--DECLARE @inp_businessName nvarchar(255)
--DECLARE @inp_firstName nvarchar(255)
--DECLARE @inp_lastName nvarchar(255)
DECLARE @inp_name nvarchar(255)
DECLARE @inp_email nvarchar(255)
DECLARE @inp_password nvarchar(100)
DECLARE @inp_addressLine1 nvarchar(500)
DECLARE @inp_addressLine2 nvarchar(500)
DECLARE @inp_countryId bigint
DECLARE @inp_postCode nvarchar(255)
DECLARE @inp_accountTypeId bigint
DECLARE @ins_rows int
DECLARE @ERR_MESSAGE nvarchar(500)
DECLARE @ERR_IND bit
DECLARE @out_runId bit
DECLARE @out_userId bigint

PRINT 'Executing sp_postNewUser';
EXECUTE @RC = [dbo].[sp_postNewUser] 
--   'Abatz', --businessName
--   NULL, --firstName
--   NULL, --lastName
   'Abatz', --name
   'hstennersw@blogger.com', --email
   'jE3@q|dEqV', --password
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
