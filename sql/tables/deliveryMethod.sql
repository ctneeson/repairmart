USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'deliveryMethod' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[deliveryMethod];
GO

CREATE TABLE dbo.deliveryMethod (
	deliveryMethodId int IDENTITY(1,1) NOT NULL, --PRIMARY KEY
	deliveryMethodName varchar(50) NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Drop-off at Customer address');
INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Collection at specialist address');
INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Postage (tracked)');
INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Postage (untracked)');
