##  Input parameters?
param(
    [string]$source = $env:COMPUTERNAME,
    [string]$target = "MS-OC16",
    $dbs = @("DB-02", "DB-03", "DB-05")
)

##  Load dependent modules.
##  Import-Module SqlServer -DisableNameChecking -ErrorAction SilentlyContinue

$SRCsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($source)
$DSTsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($target)

#######################  execute: Copy-Nload procedure  #######################

##  loop through each database.
foreach($db in $SRCsrv.Databases[$dbs]){

    if($db){
        $start = Get-Date
        ##  get latest backup file.
        $name = $db.Name
        $query = "[SQLOps].[dbo].[usp_GetLastBackupFile] '$name'"
        $LastBackupFile = ($db.ExecuteWithResults($query)).Tables.Rows[0]
        $backupfile = $LastBackupFile.Replace($SRCsrv.BackupDirectory, "\\$source\Backup$")
    
        ##  restore database
        $restore = @{
            ServerInstance  = $target
            Database        = $name
            BackupFile      = $backupfile
            ReplaceDatabase = $true
            ##  Verbose switch for debugging.
            Verbose         = $false
        }
        
        ##  test for exclusive access.
        if(($DSTsrv.Databases[$name]).ActiveConnections -eq 0){
            Write-Host "Restoring database: $name"
            Restore-SqlDatabase @restore
            $time = [math]::Round(((Get-Date) - $start).TotalMinutes,2)
            Write-Host "Database: $name restored, total Runtime: $time minutes"
        }
    }
}

####################################  END  ####################################
