
##  apply config_cntl_8.1

$WmiObject = @{
    Namespace = "root\Microsoft\SqlServer\ComputerManagement14"
    Class     = "ServerSettingsGeneralFlag"
}
$ServerSettingsGeneralFlag = Get-WmiObject @WmiObject

foreach($setting in $ServerSettingsGeneralFlag){
    $setting.SetValue($true) | Out-Null
}

if((Get-Service -Name MSSQLSERVER).Status -eq "Running"){
    Restart-Service -Name MSSQLSERVER
}
