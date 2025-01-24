USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'listings_productClassification' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[listings_productClassification];
GO

CREATE TABLE dbo.listings_productClassification (
	listing_productClassificationId int IDENTITY(1,1) PRIMARY KEY,
	listingId int NOT NULL, -- FOREIGN KEY
	productClassificationId int NOT NULL, -- FOREIGN KEY
	runId int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
