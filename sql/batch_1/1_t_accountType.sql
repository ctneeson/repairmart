USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'accountType' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[accountType];
GO

CREATE TABLE dbo.accountType (
	accountTypeId bigint IDENTITY(1,1) PRIMARY KEY,
	accountTypeName nvarchar(50) NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO accountType (accountTypeName) VALUES ('Personal');
INSERT INTO accountType (accountTypeName) VALUES ('Business');
INSERT INTO accountType (accountTypeName) VALUES ('Administrator');