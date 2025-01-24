USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'accountType' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[accountType];
GO

CREATE TABLE dbo.accountType (
	accountTypeId int IDENTITY(1,1) PRIMARY KEY,
	accountTypeName nvarchar(50) NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO accountType (accountTypeName) VALUES ('Personal');
INSERT INTO accountType (accountTypeName) VALUES ('Business');
INSERT INTO accountType (accountTypeName) VALUES ('Administrator');