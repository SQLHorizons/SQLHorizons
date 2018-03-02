##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#######################  apply  audit_cntl_7.2 trigger  #######################

$trigger = $step = "audit_cntl_7.2"
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

    DECLARE @CommandText NVARCHAR(MAX)
    SELECT  @CommandText = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')

    IF EXISTS (
    SELECT 1
      WHERE
      SUBSTRING(@CommandText, PATINDEX('%ALGORITHM = %', @CommandText) +12, 8)
      IN ('RSA_1024','RSA_512')
      )
      ROLLBACK;
    "

    $trg.Create()
    Write-Host "Deployed control: $step."
    Clear-Variable trg, step
}
