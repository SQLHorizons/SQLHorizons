CREATE TRIGGER [audit_cntl_5.2]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS
    IF EXISTS (
    SELECT 1
        WHERE
        EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]', 'NVARCHAR(100)')
       = 'default trace enabled'
        AND
        EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]', 'NVARCHAR(100)')
        = 0
        )
        ROLLBACK;
