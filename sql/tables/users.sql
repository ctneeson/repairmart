USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('users'))
BEGIN
    ALTER TABLE users DROP CONSTRAINT IF EXISTS FK_Users_CountryID;
    ALTER TABLE users DROP CONSTRAINT IF EXISTS FK_Users_AccountTypeID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[users];
GO

CREATE TABLE dbo.users (
	userId int IDENTITY(1,1) PRIMARY KEY,
	firstName varchar(255) NOT NULL,
	lastName varchar(255) NOT NULL,
	userPassword varchar(100) NOT NULL,
	emailAddress varchar(500) NOT NULL,
	addressLine1 varchar(500),
	addressLine2 varchar(500),
	countryId int, -- FOREIGN KEY
	postCode varchar(255),
	accountTypeId int NOT NULL, --FOREIGN KEY
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--EXEC sp_postNewUser(@inp_firstName, @inp_lastName, @inp_emailAddress, @inp_userPassword, @inp_addressLine1,
--                    @inp_addressLine2, @inp_countryId, @inp_postCode, @inp_accountTypeId)