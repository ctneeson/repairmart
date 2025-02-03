USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'runIds' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[runIds];
GO

CREATE TABLE dbo.runIds (
	runId bigint IDENTITY(1,1) PRIMARY KEY,
	parentRunId bigint,
	processName nvarchar(255) NOT NULL,
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UPDATED_BY bigint NOT NULL -- FOREIGN KEY
);

