USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[orders_attachments];
GO

CREATE TABLE dbo.orders_attachments (
	order_attachmentId int IDENTITY(1,1) PRIMARY KEY,
	orderId int NOT NULL, -- FOREIGN KEY
	attachmentId int NOT NULL, -- FOREIGN KEY
	runId int NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
