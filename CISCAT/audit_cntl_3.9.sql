CREATE TRIGGER [audit_cntl_3.9]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS
    IF EXISTS (
    SELECT 1
        WHERE
        EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)')
        LIKE 'BUILTIN%'
        AND
        EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)')
        LIKE 'CREATE%'
        )
        ROLLBACK;
