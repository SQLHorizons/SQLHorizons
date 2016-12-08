Function Backup-DatabaseNLog
{
	[CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
	Param (
            [parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [object]$Source,
            [object]$BackupPath,
            [object]$Database
          )
    # End of Parameters   
   
    foreach ($backup in 'Database','LOG')
    {
        $BackupFile = "$BackupPath$($Database)_MrrorSetup_$backup."+@(if($backup -eq 'Database'){'bak'}else{'trn'})
        Backup-SqlDatabase -ServerInstance $Source -Database $Database -BackupFile $BackupFile -BackupAction $backup -CompressionOption On
    }
}
