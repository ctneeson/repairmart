USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails_attachments];
GO

CREATE TABLE dbo.emails_attachments (
	email_attachmentId int IDENTITY(1,1) PRIMARY KEY,
	emailId int NOT NULL, -- FOREIGN KEY
	attachmentId int NOT NULL, -- FOREIGN KEY
	runId int NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
