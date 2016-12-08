Function Copy-DBUsers
{
	[CmdletBinding(DefaultParameterSetName = "Default", SupportsShouldProcess = $true)]
	Param (
            [parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [object]$Source,
            [object]$Destination,
            [object]$Database
          )
 
    $sourceserver   = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($Source)
    $destserver     = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server($Destination)
    $DBobj          = $sourceserver.Databases.Item($dbName)

    foreach($dbuser in $DBobj.Users|
        Where-Object {$_.IsSystemObject -eq $false})
    {
        $sourcelogin     = $sourceserver.Logins.Item($dbuser.Login)
        $username        = $sourcelogin.name
        $destlogin       = New-Object Microsoft.SqlServer.Management.Smo.Login($destserver, $username)

        if($destlogin.Name -and !$destserver.Logins.Item($destlogin.Name))
        {
            Write-Host "Attempt to add Login $username on $tgtSrv" 
            $destlogin.Set_Sid($sourcelogin.Get_Sid())
		    $destlogin.Language = $sourcelogin.Language


		    $defaultdb       = $sourcelogin.DefaultDatabase					
		    if ($destserver.databases[$defaultdb] -eq $null){$defaultdb = "master"}
		    $destlogin.DefaultDatabase = $defaultdb
					
		    $checkexpiration = "ON"; $checkpolicy = "ON"
		    if ($sourcelogin.PasswordPolicyEnforced -eq $false) { $checkpolicy = "OFF" }
		    if (!$sourcelogin.PasswordExpirationEnabled) { $checkexpiration = "OFF" }
					
		    $destlogin.PasswordPolicyEnforced = $sourcelogin.PasswordPolicyEnforced
		    $destlogin.PasswordExpirationEnabled = $sourcelogin.PasswordExpirationEnabled

		    # Attempt to add SQL Login User
		    if ($sourcelogin.LoginType -eq "SqlLogin")
		    {
			    $destlogin.LoginType = "SqlLogin"
			    $sourceloginname     = $username
                $language            = $sourcelogin.Language
						
			    switch ($sourceserver.versionMajor)
			    {
				    0 { $sql = "SELECT convert(varbinary(256),password) as hashedpass FROM master.dbo.syslogins WHERE loginname='$sourceloginname'" }
				    8 { $sql = "SELECT convert(varbinary(256),password) as hashedpass FROM dbo.syslogins WHERE name='$sourceloginname'" }
				    9 { $sql = "SELECT convert(varbinary(256),password_hash) as hashedpass FROM sys.sql_logins where name='$sourceloginname'" }
				    default
				    {
					    $sql = "SELECT CAST(CONVERT(varchar(256), CAST(LOGINPROPERTY(name,'PasswordHash') 
			    AS varbinary (256)), 1) AS nvarchar(max)) as hashedpass FROM sys.server_principals
			    WHERE principal_id = $($sourcelogin.id)"
				    }
			    }
						
			    try { $hashedpass = $sourceserver.ConnectionContext.ExecuteScalar($sql) }
			    catch
			    {
				    $hashedpassdt = $sourceserver.databases['master'].ExecuteWithResults($sql)
				    $hashedpass = $hashedpassdt.Tables[0].Rows[0].Item(0)
			    }
						
			    if ($hashedpass.gettype().name -ne "String")
			    {
				    $passtring = "0x"; $hashedpass | % { $passtring += ("{0:X}" -f $_).PadLeft(2, "0") }
				    $hashedpass = $passtring
			    }
						
			    try
			    {
				    $destlogin.Create($hashedpass, [Microsoft.SqlServer.Management.Smo.LoginCreateOptions]::IsHashed)
				    $destlogin.refresh()
				    Write-Output "Successfully added $username to $tgtSrv"
			    }
			    catch
			    {
				    try
				    {
					    $sid = "0x"; $sourcelogin.sid | % { $sid += ("{0:X}" -f $_).PadLeft(2, "0") }
					    $sqlfailsafe = "IF(SUSER_ID('$username') IS NULL) BEGIN CREATE LOGIN [$username] WITH PASSWORD = $hashedpass HASHED, SID = $sid, 
									    DEFAULT_DATABASE = [$defaultdb], CHECK_POLICY = $checkpolicy, 
									    CHECK_EXPIRATION = $checkexpiration, DEFAULT_LANGUAGE = [$language];/*SQL_LOGIN*/ END;"
								
					    $null = $destserver.ConnectionContext.ExecuteNonQuery($sqlfailsafe)
					    $destlogin = $destserver.logins[$username]
					    Write-Output "Successfully added $username to $tgtSrv"
				    }
				    catch
				    {
					    Write-Warning "Failed to add $username to $tgtSrv`: $_"
				        #Write-Error $_.Exception.InnerException
                        $destlogin.Script()
					    continue
				    }
			    }
            }
		    # Attempt to add Windows User
		    elseif ($sourcelogin.LoginType -eq "WindowsUser" -or $sourcelogin.LoginType -eq "WindowsGroup")
		    {
			    $destlogin.LoginType = $sourcelogin.LoginType
			    try
			    {
				    $destlogin.Create()
				    $destlogin.Refresh()
				    Write-Output "Successfully added $username to $tgtSrv"
			    }
			    catch
			    {
				    Write-Warning "Failed to add $username to $tgtSrv"
				    #Write-Error $_.Exception.InnerException
                    $destlogin.Script()
				    continue
			    }
            }
					
		    # This script does not currently support certificate mapped or asymmetric key users.
		    else
		    {
			    Write-Warning "$($sourcelogin.LoginType) logins not supported. $($username) skipped."
			    continue
            }
					
		    if ($sourcelogin.IsDisabled)
		    {
			    try { $destlogin.Disable() }
			    catch { Write-Warning "$username disabled on source, but could not be disabled on destination."; }
            }
		    if ($sourcelogin.DenyWindowsLogin)
		    {
			    try { $destlogin.DenyWindowsLogin = $true }
			    catch { Write-Warning "$username denied login on source, but could not be denied login on destination."; }
            }
        }
        elseif($username)
        {
            $srcsid = $null; $tgtsid = $null
            $srcsid = "0x"; $sourcelogin.Get_Sid() | % { $srcsid += ("{0:X}" -f $_).PadLeft(2, "0") }
            $tgtsid = "0x"; ($destserver.Logins.Item($destlogin.Name)).Get_Sid() | % { $tgtsid += ("{0:X}" -f $_).PadLeft(2, "0") }
            if($srcsid -eq $tgtsid){ Write-Host "login $username already created on $tgtSrv, and sids match..."}
        }
    }
}
