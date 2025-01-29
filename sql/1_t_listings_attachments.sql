USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'listings_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[listings_attachments];
GO

CREATE TABLE dbo.listings_attachments (
	listing_attachmentId int IDENTITY(1,1) PRIMARY KEY,
	listingId int NOT NULL, -- FOREIGN KEY
	attachmentId int NOT NULL, -- FOREIGN KEY
	attachmentOrder int NOT NULL,
	runId int NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
