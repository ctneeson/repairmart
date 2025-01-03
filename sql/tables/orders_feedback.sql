USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orders_feedback' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[orders_feedback];
GO

CREATE TABLE dbo.orders_feedback (
	orderFeedbackId int IDENTITY(1,1) PRIMARY KEY,
	orderId int NOT NULL, -- FOREIGN KEY
	userId int NOT NULL, -- FOREIGN KEY
	feedbackTypeId int NOT NULL, -- FOREIGN KEY
	feedbackComments varchar(400) DEFAULT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

--INSERT INTO orders_feedback (orderId) VALUES ();
