function Parse-ServerResponseDac([byte[]]$responseData)
{
	$dacPort = 0
	
	if (($responseData -ne $null) -and ($responseData[0] -eq 0x05))
	{
		$responseSize = [System.BitConverter]::ToUInt16($responseData, 1)
		
		if (($responseData.Length -eq 6) -and ($responseSize -eq 6))
		{
			if ($responseData[3] -eq 0x01)
			{
				$dacPort = [System.BitConverter]::ToUInt16($responseData, 4)
			}
			else
			{
				Write-Error "An unexpected protocol version was returned. Expected 0x01 but got $($requestData[3])."
			}
		}
		else
		{
			Write-Error "The response size was incorrect."
		}
	}
	
	return $dacPort
}
