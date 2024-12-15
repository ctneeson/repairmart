USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'quotes' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[quotes];
GO

CREATE TABLE dbo.listings (
	quoteId int IDENTITY(1,1) NOT NULL, --PRIMARY KEY
	userId int NOT NULL, -- FOREIGN KEY
	listingId int NOT NULL, -- FOREIGN KEY
	quoteStatusId int NOT NULL, -- FOREIGN KEY
	quoteCurrencyId int NOT NULL, -- FOREIGN KEY
	quoteAmount DECIMAL(10,2),
	deliveryMethodId int NOT NULL, -- FOREIGN KEY
	deliveryMethodAmount DECIMAL(10,2),
	quoteAmountTotal DECIMAL(10,2),
	estimatedTurnaround INT NOT NULL,
	useDefaultLocation bit NOT NULL DEFAULT 1,
	overrideAddressLine1 varchar(500),
	overrideAddressLine2 varchar(500),
	overrideCountryId int, --FOREIGN KEY
	overridePostCode varchar(50),
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO quotes (userId, listingId, quoteStatusId, quoteCurrencyId, ) VALUES ('Test Listing 1', 1);
