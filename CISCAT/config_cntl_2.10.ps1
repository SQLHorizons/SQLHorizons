Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

Import-Module -Name 'SQLPS' -DisableNameChecking

$SQLServer = $env:COMPUTERNAME 
$srvobj = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Wmi.ManagedComputer($SQLServer)

foreach($ClientProtocol in $srvobj.ClientProtocols){
    $protocol = $srvobj.GetSmoObject($ClientProtocol.Urn.Value.Replace("/Client","/ServerInstance[@Name='MSSQLSERVER']/Server"))

    if($protocol.Name -iin ("sm","tcp")){
        $protocol.IsEnabled = $true
    }
    else{
        $protocol.IsEnabled = $false
    }
    $protocol.Alter()
}
