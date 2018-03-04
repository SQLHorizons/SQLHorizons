##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#######################  apply  audit_cntl_3.2 trigger  #######################

$trigger = $step = "audit_cntl_3.2"
$SQLsrv.Refresh()

if(!($SQLsrv.Triggers.Item($trigger))){
    $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
    $trg.Parent = $SQLsrv
    $trg.Name = $trigger
    $trg.IsEnabled = $false

    $trg.TextHeader = "
    CREATE TRIGGER [$trigger]
    ON ALL SERVER
    FOR GRANT_DATABASE
    AS"

    $trg.TextBody = "

    IF EXISTS (
    SELECT 1
      WHERE
      EVENTDATA().value('(/EVENT_INSTANCE/Grantees/Grantee)[1]','NVARCHAR(MAX)')
      = 'guest'
      AND
      EVENTDATA().value('(/EVENT_INSTANCE/Permissions/Permission)[1]','NVARCHAR(MAX)')
      = 'connect'
      )
      BEGIN
        ROLLBACK
        PRINT 'The transaction ended in the trigger $trigger. The batch has been aborted.'
      END;
    "

    $trg.Create()
    Write-Host "Deployed control: $step."
    Clear-Variable trg, step
}
