function Get-SqlBrowserInstanceDac
{
<#
.SYNOPSIS
Gets the Dedicated Administrator Connection port number for the specified SQL Instance on the server.
.DESCRIPTION
Gets the Dedicated Administrator Connection port number for the specified SQL Instance on the server by querying the SQL Browser Service on port 1434.
.EXAMPLE
Get-SqlBrowserInstanceDac servername instancename
.EXAMPLE
Get-SqlBrowserInstanceDac servername.dnsdomain.tld instancename
.EXAMPLE
Get-SqlBrowserInstanceDac $env:COMPUTERNAME instancename
.PARAMETER $ServerName
The name or IP Address of the server.
.PARAMETER $InstanceName
The name of the SQL Instance.
#>
    [CmdletBinding(SupportsShouldProcess = $False)]
    param
    (
        [Parameter(Mandatory = $True, ValueFromPipeLine = $True)]
        [string]$ServerName,
        [Parameter(Mandatory = $True, ValueFromPipeLine = $False)]
        [string]$InstanceName
    )
    
    process
    {
        [System.UInt16]$dacPort = 0
        [System.Net.IPAddress]$ipAddress = $null
        
        $ipAddress = [System.Net.Dns]::GetHostAddresses($serverName) | Select -First 1
        
        if ($ipAddress -ne $null)
        {
            [System.Net.IPEndPoint]$ipEndPoint = New-Object System.Net.IPEndPoint($ipAddress, 1434)
            [System.Net.Sockets.UdpClient]$udpClient = New-Object System.Net.Sockets.UdpClient
            $udpClient.Client.ReceiveTimeout = 30000
            
            $instanceNameData = [System.Text.Encoding]::Default.GetBytes($instanceName)
            [byte[]]$requestData = @(0x0F) + 0x01 + $instanceNameData + 0x00
            [byte[]]$responseData = $null
            
            try
            {
                $udpClient.Connect($ipEndPoint)
                
                $bytesSent = $udpClient.Send($requestData, $requestData.Length)
                
                $responseData = do
                {
                    $udpClient.Receive([ref]$ipEndPoint)
                }
                while ($udpClient.Available -gt 0)
            }
            finally
            {
                $udpClient.Close()
                $udpClient.Dispose()
            }
            
            $dacPort = Parse-ServerResponseDac($responseData)
        }
        
        return $dacPort
    }
}
