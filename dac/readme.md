[Data-tier Applications](https://docs.microsoft.com/en-us/sql/relational-databases/data-tier-applications/data-tier-applications?view=sql-server-2017)
=========================================================================

Managing DAC with PowerShell

[Import DACFx Reference](https://msdn.microsoft.com/library/dn645454.aspx)
--------------------------------------------------------------------------

```powershell
##  register the dac dll.
$dac = "$env:ProgramFiles\Microsoft SQL Server\140\DAC\bin\Microsoft.SqlServer.Dac.dll"
Add-Type -Path $dac
````

[Connecting DacServices](https://msdn.microsoft.com/en-gb/library/microsoft.sqlserver.dac.dacservices.aspx)

```powershell
##  get DAC server object.
$conStr  = "server=$server;";
$conStr += "User ID=sa;Password=$password;";
$DACsrv = New-Object Microsoft.SqlServer.Dac.DacServices($conStr)
````
