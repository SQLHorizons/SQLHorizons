Function Get-StringInFile
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [array]$list,
        [parameter(Mandatory = $true)]
        [string]$file,
        [parameter(Mandatory = $true)]
        [string]$pattern
    )

    foreach($item in $list)
    {
        if(Test-Connection $item -Count 1 -Quiet)
        {
            $unc = "\\$item\$file"
            if($pfm = Get-Content -Path $unc) 
            {
                foreach ($line in $pfm) {if ($line -like $pattern){Write-Host "$item, $line"}}
            }
        }
        else
        {
            Write-Host "$item - OffLine..."
        }
    }
}

$Arguments = @{
    list    = "list"
    file    = "C$\Windows\pfm.ini"
    pattern = "geoset=*"
    }

Get-StringInFile @Arguments
