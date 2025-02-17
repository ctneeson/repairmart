USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[users];
GO

CREATE TABLE dbo.users (
	id bigint IDENTITY(1,1) PRIMARY KEY,
	--businessName nvarchar(255),
	--firstName nvarchar(255),
	--lastName nvarchar(255),
	[name] nvarchar(255),
	email nvarchar(255) NOT NULL,
	[password] varbinary(8000) NOT NULL,
	addressLine1 nvarchar(500),
	addressLine2 nvarchar(500),
	countryId bigint, -- FOREIGN KEY
	postCode nvarchar(50),
	accountTypeId bigint NOT NULL, --FOREIGN KEY
	runId bigint NOT NULL DEFAULT 0,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);
