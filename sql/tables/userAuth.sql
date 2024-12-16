USE [RepairMart]
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID('userAuth'))
BEGIN
    ALTER TABLE userAuth DROP CONSTRAINT IF EXISTS FK_UserAuth_UserID;
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'userAuth' AND TABLE_SCHEMA = 'dbo')
   DROP TABLE [dbo].[userAuth];
GO

CREATE TABLE dbo.userAuth (
  userId int PRIMARY KEY,
  salt varchar(100),
  aes_key varchar(255)
);