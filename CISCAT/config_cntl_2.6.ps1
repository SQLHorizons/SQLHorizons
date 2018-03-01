##  Input parameters?
param(
    [string]$server = "(local)"
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

######################  apply: config_cntl_2.6 settings  ######################

$cntl_value = $SQLsrv.Configuration.RemoteAccess

if($cntl_value.ConfigValue -eq 1){
    $cntl_value.ConfigValue = 0
    $SQLsrv.Alter()

    if((Get-Service -Name MSSQLSERVER).Status -eq "Running"){
        Restart-Service -Name MSSQLSERVER
    }
}

Clear-Variable cntl_value
