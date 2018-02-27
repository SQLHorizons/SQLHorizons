
##  apply config_cntl_8.1

$SQLBrowser = Get-WMIObject win32_service |
    Where-Object {$_.PathName -like "*sqlbrowser.exe*"}

Set-Service -Name $SQLBrowser.Name -StartupType Disabled
