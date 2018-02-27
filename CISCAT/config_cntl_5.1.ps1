
Import-Module SQLPS -DisableNameChecking
 
$SQLServer     = New-Object -TypeName  Microsoft.SqlServer.Management.SMO.Server($env:COMPUTERNAME)
 
##  apply config_cntl_5.1
if($SQLServer.NumberOfLogFiles -ne 12){
    $SQLServer.NumberOfLogFiles = 12
    $SQLServer.Alter()
}
