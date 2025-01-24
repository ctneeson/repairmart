USE RepairMart;
GO

IF OBJECT_ID('sp_getRunId', 'P') IS NOT NULL
    DROP PROCEDURE sp_getRunId;
GO

CREATE PROCEDURE sp_getRunId
    @processName NVARCHAR(255),
    @UPDATED_BY INT,
    @out_runId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO runIds(processName, UPDATED_BY)
    VALUES (@processName, @UPDATED_BY);

    SET @out_runId = (SELECT MAX(runId) FROM runIds WHERE processName = @processName AND UPDATED_BY = @UPDATED_BY);
END;
GO
