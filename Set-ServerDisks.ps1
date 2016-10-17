Function Set-ServerDisks
{
    [CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
    param
    (
            [parameter(ValueFromPipeline = $true)]
            [object]$configfile          = "F:\AllSQLUpdates\ConfigurationFiles\default-disks.csv"
    )

    if(Test-Path -Path $configfile -IsValid)
    {
        $disks = Import-Csv $configfile

        try
        {
            foreach ($Disk in Get-Disk | WHERE PartitionStyle -eq 'RAW' | Sort-Object Number)
            {
                Write-Verbose "Configuring  disk number '$($Disk.Number)'"
                $config = $disks | Where-Object {$_.id -eq $Disk.Number}

                if ($Disk.IsOffline -eq $true)
                {
                    Write-Verbose "Setting      disk number '$($Disk.Number)' Online"
                    $Disk | Set-Disk -IsOffline $false
                }
        
                if ($Disk.IsReadOnly -eq $true)
                {
                    Write-Verbose "Setting      disk number '$($Disk.Number)' to not ReadOnly"
                    $Disk | Set-Disk -IsReadOnly $false
                }

                Write-Verbose -Message "Checking     existing disk partition style..."
                if (($Disk.PartitionStyle -ne "GPT") -and ($Disk.PartitionStyle -ne "RAW"))
                {
                    Throw "Disk         '$($Disk.Number)' is already initialised with '$($Disk.PartitionStyle)'"
                }
                else
                {
                    if ($Disk.PartitionStyle -eq "RAW")
                    {
                        Write-Verbose -Message "Initializing disk number '$($Disk.Number)'."
                        $Disk | Initialize-Disk -PartitionStyle "GPT" -PassThru|Out-Null
                    }
                    else
                    {
                        Write-Verbose -Message "Disk         number '$($Disk.Number)' is already configured for 'GPT'"
                    }
                }

                # Check if existing partition already has file system on it       
                if (($Disk | Get-Partition | Get-Volume) -eq $null)
                {
                    Write-Verbose -Message "Creating     the '$($config.path)' partition..."
                    $PartParams = @{DiskNumber = $Disk.Number; UseMaximumSize = $true }
                    $Partition = New-Partition @PartParams

                    # Sometimes the disk will still be read-only after the call to New-Partition returns.
                    Start-Sleep -Seconds 5

                    Write-Verbose -Message "Formatting   the '$($config.name)' volume..."
                    $VolParams = @{
                                FileSystem         = "NTFS";
                                Confirm            = $false;
                                NewFileSystemLabel = $config.name;
                                AllocationUnitSize = 64KB
                                }

                    $Volume = $Partition | Format-Volume @VolParams

                    if (-not($config.path -like '?:'))
                    {
                        Write-Verbose -Message "Creating     AccessPath Directory '$($config.path)'..."
                        $Directory = New-Item $config.path -ItemType directory -Force -ErrorAction Stop
                    }

                    if ($Directory)
                    {
                        Write-Verbose -Message "Volume       AccessPath '$($config.path)', successfully created."
                    }            

                    Write-Verbose -Message "Adding       Partition Access Path '$($config.path)'..."
                    $PartitionAccessPath = $Partition | Add-PartitionAccessPath -AccessPath $config.path -ErrorAction Stop -PassThru

                    if ($PartitionAccessPath)
                    {
                        Write-Verbose -Message "Successfully initialized '$($config.path)'."
                    }

                }
                else 
                {
                    Throw "The volume   already exists, consider running 'Clear-Disk -Number $($Disk.Number) -RemoveData –RemoveOEM -Confirm:"+"`$false"+" before retrying."
                    #Clear-Disk -Number $DiskNumber -RemoveData –RemoveOEM -Confirm:$false -ErrorAction SilentlyContinue
                }
            }


        }
        catch
        {
            $message = $_.Exception.Message
            Throw "Disk error - Set-ServerDisks failed with the following error: '$($message)'"
        }
    }
    else 
    {
        Throw "The file $($configfile) doesn't exist."

    }
}
