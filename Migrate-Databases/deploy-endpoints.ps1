#Requires -Modules SQLServer
#Requires -Version 5.0

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Object]
    $endPointParams
)

Try {
    ##  starting script.
    $start = Get-Date
    Write-Host "VERBOSE: Executing Script: $($MyInvocation.MyCommand.Name)." -ForegroundColor Magenta

    ##  set execution attributes.
    foreach ($a in $attributes) {
        Set-Variable $($a.Name) -Value $($a.Value)

        ##  write verbose output.
        if ($VerbosePreference -eq "Continue") {
            Write-Verbose "Set execution attribute $($a.Name) to: $($a.Value)."
        }
    }

    ##  get global smo server object.
    Set-Variable -Name SQLServer -Value $global:SQLServer -ErrorAction Stop -Force

    ##  create tempdb object.    
    if (!$SQLServer.Endpoints.Where{$_.EndpointType -eq [Microsoft.SqlServer.Management.Smo.EndpointType]::DatabaseMirroring}) {
    
        $endPoint = [Microsoft.SqlServer.Management.Smo.Endpoint]::New()
        $endPoint.Parent = $SQLServer
        $endPoint.Name = $endPointParams.Name
        $endPoint.EndpointType = [Microsoft.SqlServer.Management.Smo.EndpointType]::DatabaseMirroring
        $endPoint.ProtocolType = [Microsoft.SqlServer.Management.Smo.ProtocolType]::Tcp
        $endPoint.Protocol.Tcp.ListenerPort = $endPointParams.Port
        $endPoint.Payload.DatabaseMirroring.ServerMirroringRole = [Microsoft.SqlServer.Management.Smo.ServerMirroringRole]::All
        $endPoint.Payload.DatabaseMirroring.EndpointEncryption = [Microsoft.SqlServer.Management.Smo.EndpointEncryption]::Required
        $endPoint.Payload.DatabaseMirroring.EndpointEncryptionAlgorithm = [Microsoft.SqlServer.Management.Smo.EndpointEncryptionAlgorithm]::Aes

        Write-Verbose "Creating end point: $($endPoint.Name) of type $($endPoint.EndpointType) on port $($endPointParams.Port)."
        $endPoint.Create()
        $endPoint.Start()
    }

    ##  ALL DONE
    ##  resetting execution attributes.
    $VerbosePreference = "SilentlyContinue"
    $DebugPreference = "SilentlyContinue"
    
    ##  Write-Log -status $status -message "Script complete"
    $runtime = [Math]::Round(((Get-Date) - $start).TotalMinutes, 2)
    $response = "Script: $($MyInvocation.MyCommand.Name) complete, total runtime: $("{0:N2}" -f $runtime) minutes."
    Write-Host "##vso[task.logIssue type=warning;] $response" -ForegroundColor Green

    $status = 0

    ##  return success status $status.
    Return $status
    
}
Catch [System.Exception] {
    $message = $_.Exception.GetBaseException().Message
    Throw $message
}
