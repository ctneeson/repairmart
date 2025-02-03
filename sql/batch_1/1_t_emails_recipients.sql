USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails_recipients' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails_recipients];
GO

CREATE TABLE dbo.emails_recipients (
	email_RecipientId bigint IDENTITY(1,1) PRIMARY KEY,
	emailId bigint NOT NULL, -- FOREIGN KEY
	recipientUserId bigint NOT NULL, -- FOREIGN KEY
	runId bigint NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);