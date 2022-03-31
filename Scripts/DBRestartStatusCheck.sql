USE
master;
SET
NOCOUNT ON
--Change this to the correct DBID
DECLARE @DBName VARCHAR(64) = 'et7088'


DECLARE
@crdate DATETIME, @hr VARCHAR(50), @min VARCHAR(5)

SELECT
@crdate=crdate FROM sysdatabases (nolock) WHERE NAME='tempdb'
SELECT
@hr=(DATEDIFF ( mi, @crdate,GETDATE()))/60

IF
((DATEDIFF ( mi, @crdate,GETDATE()))/60)=0
SELECT
@min=(DATEDIFF ( mi, @crdate,GETDATE()))

ELSE
SELECT
@min=(DATEDIFF ( mi, @crdate,GETDATE()))-((DATEDIFF( mi, @crdate,GETDATE()))/60)*60

PRINT
'SQL Server "' + CONVERT(VARCHAR(20),SERVERPROPERTY('SERVERNAME'))+'" has been online for the past '+@hr+' hours & '+@min+' minutes'
IF
NOT EXISTS (SELECT 1 FROM master.dbo.sysprocesses (nolock) WHERE program_name = N'SQLAgent - Generic Refresher')

BEGIN
PRINT
'SQL Server is running but SQL Server Agent <> running'
PRINT
'This instance is currently on "' + CONVERT(VARCHAR(20),SERVERPROPERTY('SERVERNAME'))+'"'
END

ELSE
BEGIN
PRINT
'SQL Server and SQL Server Agent both are running'
PRINT
'This instance is currently on "' + CONVERT(VARCHAR(20),SERVERPROPERTY('ComputerNamePhysicalNetBIOS'))+'"'
END

DECLARE @ErrorLog AS TABLE([LogDate] CHAR(24), [ProcessInfo] VARCHAR(64), [TEXT] VARCHAR(MAX))

INSERT INTO @ErrorLog
EXEC master..sp_readerrorlog 0, 1, 'Recovery of database', @DBName

INSERT INTO @ErrorLog
EXEC master..sp_readerrorlog 0, 1, 'Recovery completed', @DBName

SELECT TOP 1
    @DBName AS [DBName]
   ,[LogDate]
   ,CASE
      WHEN SUBSTRING([TEXT],10,1) = 'c'
      THEN '100%'
      ELSE SUBSTRING([TEXT], CHARINDEX(') is ', [TEXT]) + 4,CHARINDEX(' complete (', [TEXT]) - CHARINDEX(') is ', [TEXT]) - 4)
      END AS PercentComplete
   ,CASE
      WHEN SUBSTRING([TEXT],10,1) = 'c'
      THEN 0
      ELSE CAST(SUBSTRING([TEXT], CHARINDEX('approximately', [TEXT]) + 13,CHARINDEX(' seconds remain', [TEXT]) - CHARINDEX('approximately', [TEXT]) - 13) AS FLOAT)/60.0
      END AS MinutesRemaining
   ,CASE
      WHEN SUBSTRING([TEXT],10,1) = 'c'
      THEN 0
      ELSE CAST(SUBSTRING([TEXT], CHARINDEX('approximately', [TEXT]) + 13,CHARINDEX(' seconds remain', [TEXT]) - CHARINDEX('approximately', [TEXT]) - 13) AS FLOAT)/60.0/60.0
      END AS HoursRemaining
   ,[TEXT]
FROM @ErrorLog ORDER BY CAST([LogDate] as datetime) DESC, [MinutesRemaining]
