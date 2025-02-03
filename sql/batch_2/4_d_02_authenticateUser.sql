DECLARE @RC int
DECLARE @inp_email nvarchar(500)
DECLARE @inp_password nvarchar(100)
DECLARE @ERR_MESSAGE nvarchar(500)
DECLARE @ERR_IND BIT

PRINT 'Executing sp_authenticateUser';
EXECUTE @RC = [dbo].[sp_authenticateUser] 
   'hstennersw@blogger.com', --email
   'jE3@q|dEqV', --password
   @ERR_MESSAGE OUTPUT,
   @ERR_IND OUTPUT
GO
