##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

######################  apply:  config_cntl_8.2 setting  ######################

$step = "config_cntl_8.2"
$WmiObject = @{
    ComputerName = $server
    Namespace    = "root\Microsoft\SqlServer\ComputerManagement14"
    Class        = "ServerSettingsGeneralFlag"
}
$ServerSettingsGeneralFlag = Get-WmiObject @WmiObject |
    Where-Object {$_.FlagName -eq "ForceEncryption"}

if($ServerSettingsGeneralFlag.FlagValue -eq $false){
    $ServerSettingsGeneralFlag.SetValue($true) | Out-Null

    if((Get-Service -Name MSSQLSERVER).Status -eq "Running"){
        Restart-Service -Name MSSQLSERVER
    }
}
