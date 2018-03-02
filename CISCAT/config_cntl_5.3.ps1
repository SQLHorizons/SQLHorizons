##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

######################  apply: config_cntl_5.3 settings  ######################

$step = "config_cntl_5.3"
$SQLsrv.Refresh()

if($SQLsrv.AuditLevel -ne "None"){
    $SQLsrv.AuditLevel = "None"
    $SQLsrv.Alter()
    Write-Host "Configured control: $step."
}

Clear-Variable step
