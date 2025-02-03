USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[orders];
GO

CREATE TABLE dbo.orders (
	orderId bigint IDENTITY(1,1) PRIMARY KEY,
	listingId bigint NOT NULL, -- FOREIGN KEY
	quote_deliveryMethodId bigint NOT NULL, -- FOREIGN KEY
	orderStatusId bigint NOT NULL, -- FOREIGN KEY
	overrideQuoteAmount DECIMAL(10,2),
	overrideQuote bit NOT NULL DEFAULT 0,
	runId bigint NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
