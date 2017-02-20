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
            $assembly.FullName
        }
    }
}

Get-Assembly -SearchString "ConnectionInfoExtended"
