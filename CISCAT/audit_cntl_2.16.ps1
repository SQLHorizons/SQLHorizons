##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

######################  apply:  audit_cntl_2.16 trigger  ######################

$trigger = $step = "audit_cntl_2.16"
$SQLsrv.Refresh()

if(!($SQLsrv.Triggers.Item($trigger))){
    $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
    $trg.Parent = $SQLsrv
    $trg.Name = $trigger
    $trg.IsEnabled = $false

    $trg.TextHeader = "
    CREATE TRIGGER [$trigger]
    ON ALL SERVER
    FOR ALTER_DATABASE
    AS"

    $trg.TextBody = "

    IF EXISTS (
    SELECT 1
      WHERE
      EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')
      like '% AUTO_CLOSE ON %'
      )
      BEGIN
        ROLLBACK
        PRINT 'The transaction ended in the trigger $trigger. The batch has been aborted.'
      END;
    "

    $trg.Create()
    Write-Host "Deployed control: $step"
    Clear-Variable trg, step
}
