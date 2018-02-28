$ExecutionPolicy = @{
    ExecutionPolicy = "Unrestricted"
    Scope           = "Process"
    Force           = $true
}
Set-ExecutionPolicy @ExecutionPolicy

Import-Module -Name 'SQLPS' -DisableNameChecking
Start-Service -Name MSSQLSERVER

$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("(local)")
