USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders_attachments' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[orders_attachments];
GO

CREATE TABLE dbo.orders_attachments (
	order_attachmentId bigint IDENTITY(1,1) PRIMARY KEY,
	orderId bigint NOT NULL, -- FOREIGN KEY
	attachmentId bigint NOT NULL, -- FOREIGN KEY
	runId bigint NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
