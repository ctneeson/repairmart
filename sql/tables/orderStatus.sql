USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'orderStatus' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[orderStatus];
GO

CREATE TABLE dbo.orderStatus (
	orderStatusId int IDENTITY(1,1) PRIMARY KEY,
	orderStatusName varchar(50) NOT NULL,
	DATE_INSERTED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATE_UPDATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ACTIVE bit NOT NULL DEFAULT 1
);

INSERT INTO orderStatus (orderStatusName) VALUES ('Created');
INSERT INTO orderStatus (orderStatusName) VALUES ('Dispatched to Specialist');
INSERT INTO orderStatus (orderStatusName) VALUES ('Specialist Assessing');
INSERT INTO orderStatus (orderStatusName) VALUES ('Quote Adjustment Requested');
INSERT INTO orderStatus (orderStatusName) VALUES ('Quote Adjustment Approved');
INSERT INTO orderStatus (orderStatusName) VALUES ('Quote Adjustment Rejected');
INSERT INTO orderStatus (orderStatusName) VALUES ('Specialist Repairing');
INSERT INTO orderStatus (orderStatusName) VALUES ('Dispatched to Customer');
INSERT INTO orderStatus (orderStatusName) VALUES ('Closed-Repaired');
INSERT INTO orderStatus (orderStatusName) VALUES ('Closed-Cancelled');