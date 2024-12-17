USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('quotes'))
BEGIN
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_UserID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_ListingID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_QuoteStatusID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_QuoteCurrencyID;
    ALTER TABLE quotes DROP CONSTRAINT IF EXISTS FK_Quotes_OverrideCountryID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'quotes' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[quotes];
GO

CREATE TABLE dbo.quotes (
	quoteId int IDENTITY(1,1) PRIMARY KEY,
	userId int NOT NULL, -- FOREIGN KEY
	listingId int NOT NULL, -- FOREIGN KEY
	quoteStatusId int NOT NULL, -- FOREIGN KEY
	quoteCurrencyId int NOT NULL, -- FOREIGN KEY
	quoteAmount DECIMAL(10,2),
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

--INSERT INTO quotes (userId, listingId, quoteStatusId, quoteCurrencyId, ) VALUES ('Test Listing 1', 1);
