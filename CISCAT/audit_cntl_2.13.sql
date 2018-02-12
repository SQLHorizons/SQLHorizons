ALTER TRIGGER [audit_cntl_2.13]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS  
    IF EXISTS (
    SELECT 1
       WHERE
       EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]', 'NVARCHAR(100)')
       = 'remote access'
       )
       ROLLBACK;
