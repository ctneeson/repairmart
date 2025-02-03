USE RepairMart;
GO

IF OBJECT_ID('sp_getRunId', 'P') IS NOT NULL
    DROP PROCEDURE sp_getRunId;
GO

CREATE PROCEDURE sp_getRunId
    @processName NVARCHAR(255),
    @inp_userId bigint,
    @out_runId bigint OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO runIds(processName, UPDATED_BY)
    VALUES (@processName, @inp_userId);

    SET @out_runId = (SELECT MAX(runId) FROM runIds WHERE processName = @processName AND UPDATED_BY = @inp_userId);
END;
GO
