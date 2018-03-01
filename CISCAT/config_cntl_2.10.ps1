##  Input parameters?
param(
    [string]$server = "(local)"
)

##  Load dependent modules.
Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

#####################  apply:  config_cntl_2.10 settings  #####################

$WMI=New-Object Microsoft.SqlServer.Management.SMO.Wmi.ManagedComputer($server)

foreach($cp in $WMI.ClientProtocols){
    $ServerInstance = "/ServerInstance[@Name='MSSQLSERVER']/Server"
    $urn = $cp.Urn.Value.Replace("/Client",$ServerInstance)
    $protocol = $WMI.GetSmoObject($urn)

    if($protocol.Name -iin ("sm","tcp")){
        $protocol.IsEnabled = $true
    }
    else{
        $protocol.IsEnabled = $false
    }
    $protocol.Alter()
}
