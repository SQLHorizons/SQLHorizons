Function Restore-DatabaseNLog
{
	[CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
	Param (
            [parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [object]$BackupPath,
            [object]$Destination,
            [object]$Database
          )  
   
    $tsrobj   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($Destination)
    foreach ($restore in 'Database','LOG')
    {
        $BUpfile   = New-Object -TypeName  Microsoft.SqlServer.Management.Smo.BackupDeviceItem (("$BackupPath$($Database)_MrrorSetup_$restore."+@(if($restore -eq 'Database'){'bak'}else{'trn'})), 'File')
        $DbRestore = New-Object -TypeName  Microsoft.SqlServer.Management.Smo.Restore
        $DbRestore.Database = $Database
        $DbRestore.Devices.Add($BUpfile)

        foreach($fil in $DbRestore.ReadFileList($tsrobj))
        {
            $rsfile = New-Object -TypeName  'Microsoft.SqlServer.Management.Smo.RelocateFile, Microsoft.SqlServer.SmoExtended, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91'
            $rsfile.LogicalFileName = $fil.LogicalName
            switch ($fil.FileId) 
            {   1       {$rsfile.PhysicalFileName = $tsrobj.Settings.DefaultFile + $Database + '_FileId' + $fil.FileId + '_Data.mdf'}
                2       {$rsfile.PhysicalFileName = $tsrobj.Settings.DefaultLog  + $Database + '_FileId' + $fil.FileId + '_Log.ldf'}
                default {$rsfile.PhysicalFileName = $tsrobj.Settings.DefaultFile + $Database + '_FileId' + $fil.FileId + '_Data.ndf'}
            }
            $DbRestore.RelocateFiles.Add($rsfile)|Out-Null
        }
    Restore-SqlDatabase -ServerInstance $Destination -Database $Database -BackupFile $BUpfile.Name -RelocateFile @($DbRestore.RelocateFiles) -RestoreAction $restore -NoRecovery #-script
    }
}
