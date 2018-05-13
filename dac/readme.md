[Data-tier Applications](https://docs.microsoft.com/en-us/sql/relational-databases/data-tier-applications/data-tier-applications?view=sql-server-2017)
==========================================================================

Managing DAC with PowerShell.

[Import DACFx Reference](https://msdn.microsoft.com/library/dn645454.aspx)
--------------------------------------------------------------------------

```powershell
##  register the dac dll.
$dac = "$env:ProgramFiles\Microsoft SQL Server\140\DAC\bin\Microsoft.SqlServer.Dac.dll"
Add-Type -Path $dac
````

[Connecting DacServices](https://msdn.microsoft.com/en-gb/library/microsoft.sqlserver.dac.dacservices.aspx)
--------------------------------------------------------------------------

```powershell
##  get DAC server object.
$conStr  = "server=$server;";
$conStr += "User ID=sa;Password=$password;";
$DACsrv  = New-Object Microsoft.SqlServer.Dac.DacServices($conStr)
````

[DacServices.Register Method](https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.dac.dacservices.register(v=sql.120).aspx#Anchor_3)
--------------------------------------------------------------------------

[n](https://github.com/SQLHorizons/SQLHorizons/blob/master/dac/DacServices.Register.ps1)

```powershell
##  register the DAC.
$trgDBName  = "MasterSQLPlus"
$appName    = "MasterSQLPlus"
$appVersion = $([System.Version]"1.0.0.0")
$appDesc    = ""

$dr = $DACsrv.Register($trgDBName, $appName, $appVersion, $appDesc)
````

[DacServices.Extract Method](https://msdn.microsoft.com/en-gb/library/microsoft.sqlserver.dac.dacservices.extract.aspx)
--------------------------------------------------------------------------

```powershell
##  extract the DAC.
$fileName   = "$env:HOMEPATH\.dacpac\SQLOps\SQLOps.dacpac"
$trgDBName  = "SQLOps"
$appName    = "SQLOps"
$appVersion = $([System.Version]"1.0.0.0")

$de = $DACsrv.Extract($fileName, $trgDBName, $appName, $appVersion)
```

