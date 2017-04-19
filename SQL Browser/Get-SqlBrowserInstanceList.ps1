function Get-SqlBrowserInstanceList
{
<#
.SYNOPSIS
Gets the list of available SQL Instances on the server.
.DESCRIPTION
Gets the list of available SQL Instances on the server by querying the SQL Browser Service on port 1434.
.EXAMPLE
Get-SqlBrowserInstanceList servername
.EXAMPLE
Get-SqlBrowserInstanceList servername.dnsdomain.tld
.EXAMPLE
Get-SqlBrowserInstanceList $env:COMPUTERNAME
.EXAMPLE
Get-SqlBrowserInstanceList 192.168.1.255 -Broadcast
.EXAMPLE
Get-SqlBrowserInstanceList 255.255.255.255 -Broadcast
.PARAMETER $ServerName
The name or IP Address of the server.
.PARAMETER $Broadcast
If the broadcast switch is specified, the query will be sent as a broadcast and may receive replies from multiple hosts; otherwise, the query is sent to a single server.
#>
    [CmdletBinding(SupportsShouldProcess = $False)]
    param
    (
        [Parameter(Mandatory = $True, ValueFromPipeLine = $True)]
        [string]$ServerName,
        [switch]$Broadcast
    )
    
    process
    {
        [System.Net.IPAddress]$ipAddress = [System.Net.Dns]::GetHostAddresses($serverName) | Select -First 1
        $parsedResponses = @()
        
        if ($ipAddress -ne $null)
        {
            [System.Net.IPEndPoint]$localIPEndPoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
            [System.Net.IPEndPoint]$remoteIPEndPoint = New-Object System.Net.IPEndPoint($ipAddress, 1434)
            
            if ($ipAddress -eq [System.Net.IPAddress]::Broadcast)
            {
                $Broadcast = $true
            }
            
            [System.Net.Sockets.UdpClient]$receiver = New-Object System.Net.Sockets.UdpClient
            $receiver.Client.ReceiveTimeout = 30000
            
            [byte]$queryMode = 0x03
            $sleepDuration = 1
            [System.Net.Sockets.UdpClient]$sender = $null
            
            if ($Broadcast -eq $true)
            {
                Write-Verbose "Using broadcast mode."
                $queryMode = 0x02
                $sleepDuration = 30
                
                # Set the receiver to allow another client on the same socket.
                $receiver.Client.SetSocketOption([System.Net.Sockets.SocketOptionLevel]::Socket, [System.Net.Sockets.SocketOptionName]::ReuseAddress, $true)
                $receiver.Client.Bind($localIPEndPoint)
                
                # Because broadcasting from this UdpClient instance causes the underlying socket to be unable to receive normally, a separate sender must be bound to the same socket as the receiver.
                # NOTE: Windows Firewall does not view a reused socket as being part of the same conversation. If Windows Firewall is active, this requires special firewall rules to work.
                $sender = New-Object System.Net.Sockets.UdpClient
                $sender.EnableBroadcast = $Broadcast
                $sender.Client.SetSocketOption([System.Net.Sockets.SocketOptionLevel]::Socket, [System.Net.Sockets.SocketOptionName]::ReuseAddress, $true)
                $sender.Client.Bind($receiver.Client.LocalEndPoint);
            }
            else
            {
                $sender = $receiver
                $receiver.Client.Bind($localIPEndPoint)
            }
            
            $responses = @{ }
            
            try
            {
                # Send the broadcast.
                Write-Verbose "Sending request to $($ipAddress)..."
                $sender.Connect($remoteIPEndPoint)
                $bytesSent = $sender.Send(@($queryMode), 1)
                
                # Wait to give responses time to arrive.
                Sleep $sleepDuration
                
                do
                {
                    [System.Net.IPEndPoint]$responderIPEndPoint = $null
                    $response = $receiver.Receive([ref]$responderIPEndPoint)
                    $responder = $responderIPEndPoint.ToString()
                    
                    if ($responses.Contains($responder))
                    {
                        $responses[$responder] += $response
                    }
                    else
                    {
                        $responses.Add($responder, $response)
                    }
                }
                while ($receiver.Available -gt 0)
            }
            finally
            {
                if ($sender -ne $receiver)
                {
                    $sender.Close()
                    $sender.Dispose()
                }
                
                $receiver.Close()
                $receiver.Dispose()
            }
            
            foreach ($responseItem in $responses.GetEnumerator())
            {
                Write-Verbose "Parsing the response from $($responseItem.Name)..."
                $parsedResponse = Parse-ServerResponse $responseItem.Value
                $parsedResponses += $parsedResponse
                Write-Verbose ($parsedResponse | ft ServerName, InstanceName, tcp, np, Version, IsClustered -AutoSize | Out-String)
            }
        }
        
        return $parsedResponses
    }
}
