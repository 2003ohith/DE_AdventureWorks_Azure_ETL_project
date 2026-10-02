USE GoldDB_AW
GO

CREATE OR ALTER PROC CreateSQLServerlessView_gold @ViewName NVARCHAR(100)
AS
BEGIN

    DECLARE @statement VARCHAR(MAX)

    SET @statement = N'CREATE OR ALTER VIEW ' + @ViewName + ' AS
        SELECT *
        FROM
            OPENROWSET(
                BULK ''https://stgactadventureworks.dfs.core.windows.net/gold/' + @ViewName + '/'',
                FORMAT = ''DELTA''
            ) AS [result]
    '

    EXEC (@statement)

END
GO