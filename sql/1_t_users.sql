USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[users];
GO

CREATE TABLE dbo.users (
	userId int IDENTITY(1,1) PRIMARY KEY,
	businessName nvarchar(255),
	firstName nvarchar(255),
	lastName nvarchar(255),
	emailAddress nvarchar(500) NOT NULL,
	userPassword varbinary(8000) NOT NULL,
	addressLine1 nvarchar(500),
	addressLine2 nvarchar(500),
	countryId int, -- FOREIGN KEY
	postCode nvarchar(255),
	accountTypeId int NOT NULL, --FOREIGN KEY
	runId int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

-- Set up System Admin user
DECLARE @sysSalt NVARCHAR(8) = LEFT(NEWID(), 8);
DECLARE @sysAESKey NVARCHAR(50) = LEFT(NEWID(), 50);
DECLARE @sysEmailAddress nvarchar(500) = 'system@repairmart.com';
DECLARE @sysPassword nvarchar(100) = 'password';

INSERT INTO users(businessName, firstName, lastName, userPassword, emailAddress, addressLine1, addressLine2, countryId, postCode, accountTypeId, runId)
VALUES ('RepairMart', --businessName
        NULL, --firstName
		NULL, --lastName
		ENCRYPTBYPASSPHRASE(@sysAESKey, @sysEmailAddress + @sysPassword + @sysSalt), --userPassword
		'system@repairmart.com', --emailAddress
		NULL, --addressLine1
		NULL, --addressLine2
		NULL, --countryId
		NULL, --postCode
		3, --accountTypeId
		0); --runId
INSERT INTO userAuth(userId, salt, aes_key)
SELECT MAX(userId), @sysSalt, @sysAESKey FROM users WHERE runId = 0;

