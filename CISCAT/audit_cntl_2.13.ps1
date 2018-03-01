##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#######################  apply: audit_cntl_2.13 trigger  #######################

$trigger = "audit_cntl_2.13"
$SQLsrv.Refresh()

if(!($SQLsrv.Triggers.Item($trigger))){
    $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
    $trg.Parent = $SQLsrv
    $trg.Name = $trigger

    $trg.TextHeader = "
    CREATE TRIGGER [$trigger]
    ON ALL SERVER
    FOR DDL_SERVER_LEVEL_EVENTS
    AS"

    $trg.TextBody = "

    IF EXISTS (
    SELECT 1
      WHERE
      EVENTDATA().value('(/EVENT_INSTANCE/SID)[1]','NVARCHAR(MAX)')
      = 'AQ=='
      AND
      EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(MAX)')
      = 'ALTER_LOGIN'
      AND
      EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')
      LIKE '%ENABLE%'
      )
      ROLLBACK;
    "

    $trg.Create()

    Clear-Variable trg
}
