USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'quotes_deliveryMethod' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[quotes_deliveryMethod];
GO

CREATE TABLE dbo.quotes_deliveryMethod (
	quote_deliveryMethodId bigint IDENTITY(1,1) PRIMARY KEY,
	quoteId bigint NOT NULL, -- FOREIGN KEY
	deliveryMethodId bigint NOT NULL, -- FOREIGN KEY
	deliveryAmount DECIMAL(10,2),
	runId bigint NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);

