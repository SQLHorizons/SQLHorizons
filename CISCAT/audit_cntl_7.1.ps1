##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#######################  apply  audit_cntl_7.1 trigger  #######################

$trigger = $step = "audit_cntl_7.1"
$SQLsrv.Refresh()

if(!($SQLsrv.Triggers.Item($trigger))){
    $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
    $trg.Parent = $SQLsrv
    $trg.Name = $trigger
    $trg.IsEnabled = $false

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
      SUBSTRING(@CommandText, PATINDEX('%ALGORITHM = %', @CommandText) +12, 7)
      IN ('DES','TRIPLE_DES','TRIPLE_DES_3KEY','RC2','RC4','RC4_128','DESX')
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
