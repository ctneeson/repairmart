USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[messages];
GO

CREATE TABLE dbo.messages (
	messageId int IDENTITY(1,1) NOT NULL, --PRIMARY KEY
	messageFromId int NOT NULL, -- FOREIGN KEY
	messageSubject varchar(255),
	--PWord ????
	messageTimeStamp datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	messageContent varchar(max),
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO users (firstName, lastName, email, addressLine1, addressLine2, countryId, postCode, accountTypeId)
VALUES ('Elwood', 'Blues', 'elwood@blues.com', NULL, NULL, NULL, NULL, 1);

