USE [RepairMart]
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'userAuth' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[userAuth];
GO

CREATE TABLE dbo.userAuth (
  userId bigint PRIMARY KEY,
  salt nvarchar(100),
  aes_key nvarchar(255)
);