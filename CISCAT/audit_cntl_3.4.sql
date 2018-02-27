ALTER TRIGGER [audit_cntl_3.4]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS  
    IF EXISTS (
    SELECT 1
        WHERE
        EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]', 'NVARCHAR(100)')
        = 'contained database authentication'
        AND
        EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]', 'NVARCHAR(100)')
        = 1
        )
        ROLLBACK;
