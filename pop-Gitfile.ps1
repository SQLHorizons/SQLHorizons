$GitHub = "https://github.com"
$SQLHorizons = "SQLHorizons/Build/tree/dev/SQLServer"
 
$WebResponse = Invoke-WebRequest "$GitHub/$SQLHorizons"
$Scripts = $WebResponse.Links | Where-Object { $_.href -like "*.ps1" }

$Script = $Scripts | Select-Object title, href | Out-GridView -PassThru -Title "Select PowerShell Script"

$WebRsp = Invoke-WebRequest "$GitHub/$($Script.href)"
$rawfile = $WebRsp.Links | Where-Object { $_.href -like "*raw*" }

$pstext = (New-Object Net.WebClient).DownloadString("$GitHub/$($rawfile.href)")

$Editor = $($psISE.CurrentPowerShellTab.Files.Add()).Editor
$Editor.InsertText($pstext)
$Editor.EnsureVisible(1)
