Function Install-DscResource
{
       [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
       Param
        (
            [parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [string]$Source,
            [string]$Destination = "C:\Program Files\WindowsPowerShell\DscService\Modules"
        )
   
    $Version        = (Get-ChildItem $Source).Name
    $ModuleName     = $Destination + '\' + (Get-ChildItem $Source).Parent.Name + '_' + $Version
    $DestinationZip = $ModuleName +'.zip' 
 
    Compress-Archive -Path "$Source\$Version\*" -DestinationPath $DestinationZip
    New-DscChecksum $DestinationZip
}