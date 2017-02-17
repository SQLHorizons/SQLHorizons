#Function to return Restore Script for Backup Source

Function Get-SQLRestoreScript
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$SQLServer,
        [parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Get-Module -name 'SQLPS')
    {
        $SQLobj   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($SQLServer)

        $BackupDevice = New-Object -TypeName  Microsoft.SqlServer.Management.Smo.BackupDeviceItem ($Path, 'File')
        $Restore = New-Object -TypeName  Microsoft.SqlServer.Management.Smo.Restore

        $Restore.Devices.Add($BackupDevice)
        foreach($file in $Restore.ReadFileList($SQLobj))
        {
            $rsfile = New-Object -TypeName  'Microsoft.SqlServer.Management.Smo.RelocateFile, Microsoft.SqlServer.SmoExtended, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91'
            $rsfile.LogicalFileName = $file.LogicalName
            switch ($file.FileId) 
            {   1       {$rsfile.PhysicalFileName = $SQLobj.Settings.DefaultFile + $Database + '_FileId' + $file.FileId + '_Data.mdf'}
                2       {$rsfile.PhysicalFileName = $SQLobj.Settings.DefaultLog  + $Database + '_FileId' + $file.FileId + '_Log.ldf'}
                default {$rsfile.PhysicalFileName = $SQLobj.Settings.DefaultFile + $Database + '_FileId' + $file.FileId + '_Data.ndf'}
            }
            $Restore.RelocateFiles.Add($rsfile)
        }

        Return $Restore

    }
    else
    {
        Throw "Import Module Name 'SQLPS'"
    }
}

$Arguments = @{
    list    = "list"
    file    = "C$\Windows\pfm.ini"
    pattern = "geoset=*"
    }

Get-StringInFile @Arguments
