USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('emails_attachments'))
BEGIN
    ALTER TABLE emails_attachments DROP CONSTRAINT IF EXISTS FK_EmailsAttachments_EmailID;
    ALTER TABLE emails_attachments DROP CONSTRAINT IF EXISTS FK_EmailsAttachments_AttachmentID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails_attachments];
GO

CREATE TABLE dbo.emails_attachments (
	email_attachmentId int IDENTITY(1,1) PRIMARY KEY,
	emailId int NOT NULL, -- FOREIGN KEY
	attachmentId int NOT NULL, -- FOREIGN KEY
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--INSERT INTO emails_attachments (emailId, attachmentId) VALUES (,);
