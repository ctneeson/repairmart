DECLARE @RC int
DECLARE @inp_emailAddress nvarchar(500)
DECLARE @inp_userPassword nvarchar(100)
DECLARE @ERR_MESSAGE nvarchar(500)
DECLARE @ERR_IND BIT

PRINT 'Executing sp_authenticateUser';
EXECUTE @RC = [dbo].[sp_authenticateUser] 
   'hstennersw@blogger.com', --emailAddress
   'jE3@q|dEqV', --userPassword
   @ERR_MESSAGE OUTPUT,
   @ERR_IND OUTPUT
GO
