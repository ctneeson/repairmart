USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'listings' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[listings];
GO

CREATE TABLE dbo.listings (
	listingId int IDENTITY(1,1) PRIMARY KEY,
	userId int NOT NULL, -- FOREIGN KEY
	listingStatusId int NOT NULL, -- FOREIGN KEY
	manufacturerId int NOT NULL, -- FOREIGN KEY
	listingTitle nvarchar(500) NOT NULL,
	listingDetail nvarchar(4000) NOT NULL,
	listingBudgetCurrencyId int, -- FOREIGN KEY
	listingBudget decimal(10,2),
	useDefaultLocation bit NOT NULL DEFAULT 1,
	overrideAddressLine1 nvarchar(500),
	overrideAddressLine2 nvarchar(500),
	overrideCountryId int, --FOREIGN KEY
	overridePostCode nvarchar(50),
	listingExpiry int NOT NULL,
	runId int NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
