USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'deliveryMethod' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[deliveryMethod];
GO

CREATE TABLE dbo.deliveryMethod (
	deliveryMethodId bigint IDENTITY(1,1) PRIMARY KEY,
	deliveryMethodName nvarchar(50) NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Drop-off at Customer address');
INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Pick-up at Business address');
INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Postage (tracked)');
INSERT INTO deliveryMethod (deliveryMethodName) VALUES ('Postage (untracked)');
