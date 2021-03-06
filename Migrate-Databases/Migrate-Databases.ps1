 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

$library = "\\library\PoSh\MigrateDatabases"
Push-Location -Path $library

Push-Location -Path "$library\Modules"
foreach($module in Get-ChildItem)
{
    Import-Module ".\$module"
}
Pop-Location
    
    Get-SQLPSModule

    $srcSrv         = 'DB-OC13'
    $tgtSrv         = 'DB-OC60'      
    $dbNames        = 'SQLInfo'
    
    foreach($dbName in $dbNames)
    {
    Copy-Database -Source $srcSrv -Destination $tgtSrv -Database $dbName -Verbose
    Copy-DBUsers -Source $srcSrv -Destination $tgtSrv -Database $dbName
    }

　
　
　
　
　
　
　
<#
    M
    ALTER DATABASE [CCMData] SET PARTNER = N'TCP://db-oc56.norfolk.police.uk:5022'
    P
    ALTER DATABASE [CCMData] SET PARTNER = N'TCP://db-de56.norfolk.police.uk:5022'
    ALTER DATABASE [CCMData] SET SAFETY FULL
#>

<#
    M
    ALTER DATABASE [AbnormalLoads] SET PARTNER = N'TCP://db-occ14.norfolk.police.uk:5022'
    P
    ALTER DATABASE [AbnormalLoads] SET PARTNER = N'TCP://db-oc35.norfolk.police.uk:5022'
    ALTER DATABASE [AbnormalLoads] SET SAFETY FULL
#> 
