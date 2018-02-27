ALTER TRIGGER [audit_cntl_3.8]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS
    IF EXISTS (
    SELECT 1
        WHERE
        EVENTDATA().value('(/EVENT_INSTANCE/Grantees/Grantee)[1]', 'NVARCHAR(100)')
        = 'public'
        )
        ROLLBACK;
