USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'email' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails];
GO

CREATE TABLE dbo.emails (
	emailId int IDENTITY(1,1) NOT NULL, --PRIMARY KEY
	emailFromId int NOT NULL, -- FOREIGN KEY
	listingId int, -- FOREIGN KEY
	quoteId int, -- FOREIGN KEY
	orderId int, -- FOREIGN KEY
	emailSubject varchar(255),
	emailTimeStamp datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	emailContent varchar(max),
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
