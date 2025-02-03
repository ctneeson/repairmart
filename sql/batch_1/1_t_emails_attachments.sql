USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails_attachments];
GO

CREATE TABLE dbo.emails_attachments (
	email_attachmentId bigint IDENTITY(1,1) PRIMARY KEY,
	emailId bigint NOT NULL, -- FOREIGN KEY
	attachmentId bigint NOT NULL, -- FOREIGN KEY
	runId bigint NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
