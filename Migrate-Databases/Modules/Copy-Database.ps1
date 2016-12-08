Function Copy-Database
{
	[CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
	Param (
            [parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [object]$Source,
            [object]$Destination,
            [object]$Database
          )

    $sourceserver   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($Source)
    $DBobj          = $sourceserver.Databases.Item($Database)
    $bupdir         = '\\DB-OCC04-Backup.norfolk.police.uk\SQLBackups'

    $bupPath        = "$bupdir\"+@($Source.Replace('\','$'))+"\$Database\"
    if(-not(Test-Path $bupPath)){New-Item $bupPath -type directory -Force|Out-Null}
    Get-ChildItem -Path $bupPath -Filter '*MrrorSetup*'|Remove-Item -Force -ErrorAction SilentlyContinue

    if($DBobj.RecoveryModel -ne 'Full'){$DBobj.RecoveryModel = 'Full';$DBobj.Alter()}

    Set-MirrorEndpoint  -Source $Source -Destination $Destination
    Backup-DatabaseNLog -Source $Source -BackupPath $bupPath -Database $Database
    Write-Verbose "Restore-DatabaseNLog -BackupPath $($bupPath) -Destination $($Destination) -Database $($Database)"
    Restore-DatabaseNLog -BackupPath $bupPath -Destination $Destination -Database $Database
}
