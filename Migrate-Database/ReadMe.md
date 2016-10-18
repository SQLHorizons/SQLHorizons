Migrate-Database

A set of functions to help migrate databases from source SQL server to destination SQL server and prepare it for mirroring.

Functions:
Copy-Database: governing function that implements the process .
Backup-DatabaseNLog: backup of database & transaction log.
Restore-DatabaseNLog: uses SMO to restore correct database file format & transaction log.
Copy-DBUsers: function based on 
Set-MirrorEndpoint: creates mirror endpoints on both servers if one doesn't already exist.

Example:
    $srcSrv         = "ServerA"
    $tgtSrv         = "ServerB"       
    $dbNames        = "DatabaseA", "DatabaseB", "DatabaseC"
    
    foreach($dbName in $dbNames)
    {
    Copy-Database -Source $srcSrv -Destination $tgtSrv -Database $dbName 
    Copy-DBUsers -Source $srcSrv -Destination $tgtSrv -Database $dbName
    }
