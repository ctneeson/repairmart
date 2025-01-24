USE [RepairMart]
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_Users_UserAuth_AfterDrop')
BEGIN
    DROP TRIGGER tr_Users_UserAuth_AfterDrop ON DATABASE;
END

CREATE TRIGGER tr_Users_UserAuth_AfterDrop
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML
    SET @EventData = EVENTDATA()

    DECLARE @TableName NVARCHAR(128)
    SET @TableName = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)')

    IF @TableName = 'users'
    BEGIN
        EXEC sp_executesql N'TRUNCATE TABLE dbo.userAuth'
    END
END