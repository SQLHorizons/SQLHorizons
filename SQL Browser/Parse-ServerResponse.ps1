function Parse-ServerResponse([byte[]]$responseData)
{
    [PSObject[]]$instances = @()
    
    if (($responseData -ne $null) -and ($responseData[0] -eq 0x05))
    {
        $responseSize = [System.BitConverter]::ToInt16($responseData, 1)
        
        if ($responseSize -le $responseData.Length - 3)
        {
            # Discard any bytes beyond the received response size. An oversized response is usually the result of receiving multiple replies to a broadcast request.
            $responseString = [System.Text.Encoding]::Default.GetString(($responseData | Select -Skip 3 -First $responseSize))
            $instanceResponses = $responseString.Split(@(";;"), [System.StringSplitOptions]::RemoveEmptyEntries)
            
            $instances = foreach ($instanceResponse in $instanceResponses)
            {
                $instanceResponseValues = $instanceResponse.Split(";")
                $instanceResponseHash = @{ }
                for ($index = 0; $index -lt $instanceResponseValues.Length; $index += 2)
                {
                    $instanceResponseHash[$instanceResponseValues[$index]] = $instanceResponseValues[$index + 1]
                }
                
                New-Object PSObject -Property $instanceResponseHash
            }
        }
        else
        {
            Write-Warning "The response was too short. Expected $($responseSize) bytes but got $($responseData.Length - 3)."
        }
    }
    
    return, $instances
}
