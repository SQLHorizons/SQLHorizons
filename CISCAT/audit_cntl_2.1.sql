CREATE TRIGGER [audit_cntl_2.1]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS

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
  
