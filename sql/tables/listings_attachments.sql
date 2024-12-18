USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'listings_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[listings_attachments];
GO

CREATE TABLE dbo.listings_attachments (
	listing_attachmentId int IDENTITY(1,1) PRIMARY KEY,
	listingId int NOT NULL, -- FOREIGN KEY
	attachmentId int NOT NULL, -- FOREIGN KEY
	attachmentIsPrimary bit NOT NULL DEFAULT 0,
	attachmentOrder int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--INSERT INTO listings_attachments (listingId, attachmentId, attachmentIsPrimary, attachmentOrder) VALUES (,,,);
