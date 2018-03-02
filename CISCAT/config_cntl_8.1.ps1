##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

######################  apply: config_cntl_8.1 settings  ######################

$step = "config_cntl_8.1"

$SQLBrowser = Get-WMIObject win32_service -ComputerName $server |
    Where-Object {$_.PathName -like "*sqlbrowser.exe*"}

if(!($SQLBrowser.StartMode -eq "Disabled")){
    Set-Service -Name $SQLBrowser.Name -StartupType Disabled
    Write-Host "Configured control: $step."
}

Clear-Variable step
