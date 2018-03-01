<############ Begin script Initialize-SQLConfiguration.ps1 ####################

    Author:         Paul Maxfield
    Create date:    28/03/2018

    Script:         Initialize-SQLConfiguration
    Description:    

    Assumptions:    

    Dependencies:   Requires PowerShell module(s) AWSPowerShell.

    Inputs:         

    Warning:        

##############################################################################>

Import-Module SQLPS -DisableNameChecking

$SQLServer     = New-Object -TypeName  Microsoft.SqlServer.Management.SMO.Server($env:COMPUTERNAME)

##  apply config_cntl_5.1
if($SQLServer.NumberOfLogFiles -ne 12){
    $SQLServer.NumberOfLogFiles = 12
    $SQLServer.Alter()
}

##  apply config_cntl_5.3
if($SQLServer.AuditLevel -ne "All"){
    $SQLServer.AuditLevel = "All"
    $SQLServer.Alter()
}

##  apply config_cntl_8.1
$SQLBrowser = Get-WMIObject win32_service |
    Where-Object {$_.PathName -like "*sqlbrowser.exe*"}

Set-Service -Name $SQLBrowser.Name -StartupType Disabled
