USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('quotes_deliveryMethod'))
BEGIN
    ALTER TABLE quotes_deliveryMethod DROP CONSTRAINT IF EXISTS FK_QuoteDeliveryMethod_QuoteID;
    ALTER TABLE quotes_deliveryMethod DROP CONSTRAINT IF EXISTS FK_QuoteDeliveryMethod_DeliveryMethodID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'quotes_deliveryMethod' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[quotes_deliveryMethod];
GO

CREATE TABLE dbo.quotes_deliveryMethod (
	quote_deliveryMethodId int IDENTITY(1,1) PRIMARY KEY,
	quoteId int NOT NULL, -- FOREIGN KEY
	deliveryMethodId int NOT NULL, -- FOREIGN KEY
	deliveryAmount DECIMAL(10,2),
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--INSERT INTO quotes_deliveryMethod (quoteId, deliveryMethodId) VALUES (,);
