Function Get-SQLPSModule
{
    if (-not (Get-Module -name 'SQLPS'))
    {
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq 'SQLPS' })
        {
            Push-Location
            Import-Module -Name 'SQLPS' -DisableNameChecking
            Pop-Location
        }
    }
}
