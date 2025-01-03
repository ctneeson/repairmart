USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'quoteStatus' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[quoteStatus];
GO

CREATE TABLE dbo.quoteStatus (
	quoteStatusId int IDENTITY(1,1) PRIMARY KEY,
	quoteStatusName varchar(50) NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO quoteStatus (quoteStatusName) VALUES ('Open');
INSERT INTO quoteStatus (quoteStatusName) VALUES ('Closed-Rejected');
INSERT INTO quoteStatus (quoteStatusName) VALUES ('Closed-Retracted');
INSERT INTO quoteStatus (quoteStatusName) VALUES ('Closed-Order Created');