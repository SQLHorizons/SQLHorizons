Import-Module -Name 'SQLPS' -DisableNameChecking

$SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server("(local)")

##  apply audit_cntl_2.1 trigger.
$trigger = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
$trigger.Parent = $SQLsrv
$trigger.Name = "audit_cntl_2.1"

$trigger.TextHeader = "
CREATE TRIGGER [audit_cntl_2.1]
ON ALL SERVER
FOR DDL_SERVER_LEVEL_EVENTS
AS"

$trigger.TextBody   = "

IF EXISTS (
SELECT 1
  WHERE
  EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]', 'NVARCHAR(MAX)')
  = 'Ad Hoc Distributed Queries'
  AND
  EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]', 'NVARCHAR(MAX)')
  = 1
  )
  ROLLBACK;
"

$trigger.Create()

Clear-Variable trigger
