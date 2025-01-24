USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails_recipients' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails_recipients];
GO

CREATE TABLE dbo.emails_recipients (
	email_RecipientId int IDENTITY(1,1) PRIMARY KEY,
	emailId int NOT NULL, -- FOREIGN KEY
	recipientUserId int NOT NULL, -- FOREIGN KEY
	runId int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);