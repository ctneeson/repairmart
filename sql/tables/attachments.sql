USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[attachments];
GO

/* Create a table. */
CREATE TABLE dbo.attachments (
    attachmentId INT IDENTITY(1,1) PRIMARY KEY,
    attachmentUrl VARCHAR(1000),
	runId int,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
)

/* Read the file image and insert it to the as a BLOB  */
--INSERT INTO attachments
--    (attachmentData)
--    SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Path_To\Your_Image.jpg', SINGLE_BLOB) AS attachmentData
 