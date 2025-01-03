USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[users];
GO

CREATE TABLE dbo.users (
	userId int IDENTITY(1,1) PRIMARY KEY,
	businessName varchar(255),
	firstName varchar(255),
	lastName varchar(255),
	emailAddress varchar(500) NOT NULL,
	userPassword varchar(100) NOT NULL,
	addressLine1 varchar(500),
	addressLine2 varchar(500),
	countryId int, -- FOREIGN KEY
	postCode varchar(255),
	accountTypeId int NOT NULL, --FOREIGN KEY
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--EXEC sp_postNewUser(@inp_businessName, @inp_firstName, @inp_lastName, @inp_emailAddress, @inp_userPassword, @inp_addressLine1,
--                    @inp_addressLine2, @inp_countryId, @inp_postCode, @inp_accountTypeId)
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

EXECUTE @RC = [dbo].[sp_postNewUser] 
   'Abatz', NULL, NULL, 'hstennersw@blogger.com', 'jE3@q|dEqV', '58 Blackbird Avenue', 'PO Box 40080', 50, '374 01', 2, @ins_rows OUTPUT, @ERR_MESSAGE OUTPUT, @ERR_IND OUTPUT
GO
