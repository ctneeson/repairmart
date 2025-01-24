USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails];
GO

CREATE TABLE dbo.emails (
	emailId int IDENTITY(1,1) PRIMARY KEY,
	emailFromId int NOT NULL, -- FOREIGN KEY
	listingId int, -- FOREIGN KEY
	quoteId int, -- FOREIGN KEY
	orderId int, -- FOREIGN KEY
	emailSubject nvarchar(255),
	emailContent nvarchar(max),
	runId int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
