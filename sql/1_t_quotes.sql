USE [RepairMart]
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
	overrideAddressLine1 nvarchar(500),
	overrideAddressLine2 nvarchar(500),
	overrideCountryId int, --FOREIGN KEY
	overridePostCode nvarchar(50),
	runId int NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--INSERT INTO quotes (userId, listingId, quoteStatusId, quoteCurrencyId, ) VALUES ('Test Listing 1', 1);
