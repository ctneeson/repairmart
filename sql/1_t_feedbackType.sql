USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'feedbackType' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[feedbackType];
GO

CREATE TABLE dbo.feedbackType (
	feedbackTypeId int IDENTITY(1,1) PRIMARY KEY,
	feedbackTypeName nvarchar(50) NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO feedbackType (feedbackTypeName) VALUES ('Positive');
INSERT INTO feedbackType (feedbackTypeName) VALUES ('Neutral');
INSERT INTO feedbackType (feedbackTypeName) VALUES ('Negative');
