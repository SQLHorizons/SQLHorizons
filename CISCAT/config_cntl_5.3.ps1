Import-Module SQLPS -DisableNameChecking
 
$SQLServer     = New-Object -TypeName  Microsoft.SqlServer.Management.SMO.Server($env:COMPUTERNAME)
 
##  apply config_cntl_5.3
if($SQLServer.AuditLevel -ne "All"){
    $SQLServer.AuditLevel = "All"
    $SQLServer.Alter()
}
