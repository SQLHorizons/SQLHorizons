USE [master]
-- =============================================
-- Description:	Setup SplunkUser
-- =============================================
IF NOT EXISTS(SELECT 1 FROM sys.server_principals WHERE name = 'SplunkUser')
BEGIN
	CREATE LOGIN [SplunkUser] WITH PASSWORD=N''
	, DEFAULT_DATABASE=[master]
	, DEFAULT_LANGUAGE=[us_english]
	, CHECK_EXPIRATION=OFF
	, CHECK_POLICY=ON
	, SID=0x62FB699E8B6C9247A04995D2F00D66E1
END;

USE [SQLOPs]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Paul Maxfield
-- Create date: 13/12/2017
-- Description:	Procedure to reture dtabase
-- status, either as a 1 up, or 0 down.
-- =============================================

IF DATABASE_PRINCIPAL_ID('SplunkMonitor') IS NULL
BEGIN
	PRINT 'CREATE ROLE'
	CREATE ROLE [SplunkMonitor];
END

IF DATABASE_PRINCIPAL_ID('SplunkUser') IS NULL
BEGIN
	PRINT 'CREATE USER'
	CREATE USER [SplunkUser] FOR LOGIN [SplunkUser];
	ALTER ROLE [SplunkMonitor] ADD MEMBER [SplunkUser];
END

IF Object_ID('usp_GetDatabaseState') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[usp_GetDatabaseState]
END

GO

CREATE PROCEDURE usp_GetDatabaseState
	@DatabaseName AS NVARCHAR(256) = 'master'
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(1) AS [Status]
	FROM sys.databases
	WHERE state_desc = 'ONLINE'
		AND name = @DatabaseName
END;

GO
GRANT EXECUTE ON [dbo].[usp_GetDatabaseState] TO [SplunkMonitor];

