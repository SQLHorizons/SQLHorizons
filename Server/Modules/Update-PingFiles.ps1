Function Update-PingFiles
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$Server,
        [parameter(Mandatory = $true)]
        [string]$Path
    )

    Push-Location $path
    $file = Get-ChildItem *.txt -recurse | Select-String -pattern "AS-OCC41" | group path | select name
    ii $file.Name
    Pop-Location
}
