CREATE TRIGGER [audit_cntl_2.17]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS  
    IF EXISTS (
    SELECT 1
       WHERE
	   EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)')
	   = 'CREATE_LOGIN'
	   AND
	   EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)')
	   LIKE 'sa'
       )
       ROLLBACK;
