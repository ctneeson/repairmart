USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'listingStatus' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[listingStatus];
GO

CREATE TABLE dbo.listingStatus (
	listingStatusId int IDENTITY(1,1) PRIMARY KEY,
	listingStatusName nvarchar(50) NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO listingStatus (listingStatusName) VALUES ('Open');
INSERT INTO listingStatus (listingStatusName) VALUES ('Closed-Expired');
INSERT INTO listingStatus (listingStatusName) VALUES ('Closed-Retracted');
INSERT INTO listingStatus (listingStatusName) VALUES ('Closed-Order Created');