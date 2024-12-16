USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('listings'))
BEGIN
    ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_UserID;
    ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_ListingStatusID;
    ALTER TABLE listings DROP CONSTRAINT IF EXISTS FK_Listings_OverrideCountryID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'listings' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[listings];
GO

CREATE TABLE dbo.listings (
	listingId int IDENTITY(1,1) PRIMARY KEY,
	userId int NOT NULL, -- FOREIGN KEY
	listingStatusId int NOT NULL, -- FOREIGN KEY
	listingTitle varchar(500) NOT NULL,
	listingBudget decimal(10,2),
	useDefaultLocation bit NOT NULL DEFAULT 1,
	overrideAddressLine1 varchar(500),
	overrideAddressLine2 varchar(500),
	overrideCountryId int, --FOREIGN KEY
	overridePostCode varchar(50),
	listingExpiry int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--INSERT INTO listings (listingTitle, userId) VALUES ('Test Listing 1', 1);
