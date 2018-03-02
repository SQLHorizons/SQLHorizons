##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#####################  apply:  config_cntl_2.13 settings  #####################

$SQLsrv.Refresh()
$sysadmin = $SQLsrv.Logins.ItemById(1)

if(!($sysadmin.IsDisabled)){
    $sysadmin.Disable()
}
