##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

########################  apply: audit_cntl_5.4 audit  ########################

$Audit = $step = "audit_cntl_5.4"
$SQLsrv.Refresh()

if(!($SQLsrv.Audits.Item($Audit))){
    $adt = New-Object Microsoft.SqlServer.Management.Smo.Audit
    $adt.Parent = $SQLsrv
    $adt.Name = $Audit

    $adt.DestinationType = [Microsoft.SqlServer.Management.Smo.AuditDestinationType]::File
    $adt.FilePath = $SQLsrv.ErrorLogPath
    $adt.MaximumRolloverFiles = 1
    $adt.MaximumFileSize = 500
    $adt.ReserveDiskSpace = $true

    $adt.Create()

    ## Set audit specification properties.
    $spc = New-Object Microsoft.SqlServer.Management.Smo.ServerAuditSpecification
    $spc.Parent = $SQLsrv
    $spc.Name = $Audit.Replace('cntl', 'specification')
    $spc.AuditName = $adt.Name

    ## Set audit events.
    $events  = "AuditChangeGroup","FailedLoginGroup","SuccessfulLoginGroup"
    $events += "FailedDatabaseAuthenticationGroup","SuccessfulDatabaseAuthenticationGroup"
    $events += "DatabaseLogoutGroup"

    foreach($asd in $events){
        $act = New-Object Microsoft.SqlServer.Management.Smo.AuditSpecificationDetail($asd)
        $spc.AddAuditSpecificationDetail($act)
    }

    ## Create and enable audit specification.
    $spc.Create()
    $spc.Enable()
    $adt.Enable()

    Write-Host "Configured and deployed control: $step."
    Clear-Variable adt, step
}
