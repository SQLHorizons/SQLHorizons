Function Get-Assembly
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$SearchString
    )

    foreach($assembly in [AppDomain]::CurrentDomain.GetAssemblies())
    {
        if($assembly.FullName.Contains($SearchString))
        {
            Return $assembly.FullName
        }
    }
}

Get-Assembly -SearchString "ConnectionInfoExtended"

Add-Type -AssemblyName $(Get-Assembly -SearchString "ConnectionInfoExtended") -IgnoreWarnings
Add-Type -AssemblyName $(Get-Assembly -SearchString "ConnectionInfo") -IgnoreWarnings
