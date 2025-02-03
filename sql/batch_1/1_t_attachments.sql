USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[attachments];
GO

/* Create a table. */
CREATE TABLE dbo.attachments (
    attachmentId bigint IDENTITY(1,1) PRIMARY KEY,
    attachmentUrl nvarchar(1000) UNIQUE,
    hashValue nvarchar(1000),
	runId bigint,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
)
