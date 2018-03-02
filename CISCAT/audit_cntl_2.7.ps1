##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#######################  apply: audit_cntl_2.7 trigger  #######################

$trigger = $step = "audit_cntl_2.7"
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
      EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
      = 'remote admin connections'
      AND
      EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
      = 1
      )
      ROLLBACK;
    "

    $trg.Create()
    Write-Host "Deployed control: $step"
    Clear-Variable trg, step
}
