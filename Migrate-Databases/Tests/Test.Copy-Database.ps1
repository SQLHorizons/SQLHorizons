Get-SQLPSModule

$srcSrv         = 'DB-OC01'
$tgtSrv         = 'DB-OC02'
$dbName         = 'SQLInfo'

Copy-Database -Source $srcSrv -Destination $tgtSrv -Database $dbName -Verbose 
