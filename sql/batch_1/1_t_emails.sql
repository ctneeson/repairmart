USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'emails' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[emails];
GO

CREATE TABLE dbo.emails (
	emailId bigint IDENTITY(1,1) PRIMARY KEY,
	emailFromId bigint NOT NULL, -- FOREIGN KEY
	listingId bigint, -- FOREIGN KEY
	quoteId bigint, -- FOREIGN KEY
	orderId bigint, -- FOREIGN KEY
	emailSubject nvarchar(255),
	emailContent nvarchar(max),
	runId bigint NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
