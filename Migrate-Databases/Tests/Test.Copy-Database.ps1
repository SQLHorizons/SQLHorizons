Get-SQLPSModule

$srcSrv         = 'DB-OC34' #'DB-OCC04QC\C'  #'DB-OCC04QB\B'
$tgtSrv         = 'DB-OC46'       #'DB-OC46'
$dbName         = 'NdiCdr_SC' #'ThreatsToLife' #'Signpost_Audit', 'ThreatsToLife' #'COMPTrain' #'COMPACT'  #

Copy-Database -Source $srcSrv -Destination $tgtSrv -Database $dbName -Verbose 
