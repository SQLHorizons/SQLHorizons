Import-Module -Name 'SQLPS' -DisableNameChecking

$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("(local)")
$trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger($srv, "audit_cntl_2.1")

$trg.TextHeader = "
CREATE TRIGGER [audit_cntl_2.1]
ON ALL SERVER
FOR DDL_SERVER_LEVEL_EVENTS
AS"

$trg.TextBody   = "

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

##  apply audit_cntl_2.1 trigger.
$trg.Create()
