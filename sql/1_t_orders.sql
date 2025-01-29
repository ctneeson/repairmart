USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[orders];
GO

CREATE TABLE dbo.orders (
	orderId int IDENTITY(1,1) PRIMARY KEY,
	listingId int NOT NULL, -- FOREIGN KEY
	quote_deliveryMethodId int NOT NULL, -- FOREIGN KEY
	orderStatusId int NOT NULL, -- FOREIGN KEY
	overrideQuoteAmount DECIMAL(10,2),
	overrideQuote bit NOT NULL DEFAULT 0,
	runId int NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
