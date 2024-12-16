USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('emails_recipients'))
BEGIN
    ALTER TABLE emails_recipients DROP CONSTRAINT IF EXISTS FK_EmailsRecipients_EmailID;
    ALTER TABLE emails_recipients DROP CONSTRAINT IF EXISTS FK_EmailsRecipients_RecipientUserID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails_recipients' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails_recipients];
GO

CREATE TABLE dbo.emails_recipients (
	email_RecipientId int IDENTITY(1,1) PRIMARY KEY,
	emailId int NOT NULL, -- FOREIGN KEY
	recipientUserId int NOT NULL, -- FOREIGN KEY
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);