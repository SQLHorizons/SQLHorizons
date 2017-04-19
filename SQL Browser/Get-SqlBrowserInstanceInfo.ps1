function Get-SqlBrowserInstanceInfo
{
<#
.SYNOPSIS
Gets information about the specified SQL Instance from the server.
.DESCRIPTION
Gets information about the specified SQL Instance from the server by querying the SQL Browser Service on port 1434.
.EXAMPLE
Get-SqlBrowserInstanceInfo servername instancename
.EXAMPLE
Get-SqlBrowserInstanceInfo servername.dnsdomain.tld instancename
.EXAMPLE
Get-SqlBrowserInstanceInfo $env:COMPUTERNAME
.PARAMETER $ServerName
The name or IP Address of the server.
.PARAMETER $InstanceName
The name of the SQL Instance.    #>
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
		$instances = @()
		[System.Net.IPAddress]$ipAddress = $null
		
		$ipAddress = [System.Net.Dns]::GetHostAddresses($serverName) | Select -First 1
		
		if ($ipAddress -ne $null)
		{
			[System.Net.IPEndPoint]$ipEndPoint = New-Object System.Net.IPEndPoint($ipAddress, 1434)
			[System.Net.Sockets.UdpClient]$udpClient = New-Object System.Net.Sockets.UdpClient
			$udpClient.Client.ReceiveTimeout = 10000
			
			$instanceNameData = [System.Text.Encoding]::Default.GetBytes($instanceName)
			[byte[]]$requestData = @(0x04) + $instanceNameData + 0x00
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
			
			$instances = Parse-ServerResponse $responseData
		}
		
		return $instances
	}
}
