##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

######################  apply: config_cntl_5.1 settings  ######################

$step = "config_cntl_5.1"
$SQLsrv.Refresh()

if($SQLsrv.NumberOfLogFiles -ne 12){
    $SQLsrv.NumberOfLogFiles = 12
    $SQLsrv.Alter()
    Write-Host "Configured control: $step."
}

Clear-Variable step
