ALTER TRIGGER [audit_cntl_4.2]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS
    IF EXISTS (
    SELECT 1
        WHERE
        EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(MAX)')
        = 'ADD_SERVER_ROLE_MEMBER'
        AND
        EVENTDATA().value('(/EVENT_INSTANCE/LoginType)[1]', 'NVARCHAR(MAX)')
        = 'SQL Login'
        AND
        EVENTDATA().value('(/EVENT_INSTANCE/RoleName)[1]', 'NVARCHAR(MAX)')
        = 'sysadmin'
        )
        ROLLBACK;
