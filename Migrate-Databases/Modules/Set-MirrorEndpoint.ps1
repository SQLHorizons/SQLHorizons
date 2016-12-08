Function Set-MirrorEndpoint
{
	[CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
	Param (
            [parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [object]$Source,
            [object]$Destination
          )
    # End of Parameters
    $ePntname     = 'Hadr_endpoint'; $HadrPort = 5022

    foreach ($sqlSrv in $Source, $Destination)
    {   $srvobj   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($sqlSrv)
        $Endpoint = $srvobj.Endpoints |
        Where-Object {$_.EndpointType -eq [Microsoft.SqlServer.Management.Smo.EndpointType]::DatabaseMirroring} 

        if(!$Endpoint)
        {   $Endpoint = New-Object -TypeName  Microsoft.SqlServer.Management.Smo.Endpoint($srvobj, $ePntname)
            $Endpoint.EndpointType = [Microsoft.SqlServer.Management.Smo.EndpointType]::DatabaseMirroring
            $Endpoint.ProtocolType = [Microsoft.SqlServer.Management.Smo.ProtocolType]::Tcp
            $Endpoint.Protocol.Tcp.ListenerPort = $HadrPort
            $Endpoint.Payload.DatabaseMirroring.ServerMirroringRole = [Microsoft.SqlServer.Management.Smo.ServerMirroringRole]::All
            $Endpoint.Payload.DatabaseMirroring.EndpointEncryption = [Microsoft.SqlServer.Management.Smo.EndpointEncryption]::Required
            $Endpoint.Payload.DatabaseMirroring.EndpointEncryptionAlgorithm = [Microsoft.SqlServer.Management.Smo.EndpointEncryptionAlgorithm]::Aes
            $Endpoint.Create()
            $Endpoint.Start()
        }
    }
}
