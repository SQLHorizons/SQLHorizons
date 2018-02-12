CREATE TRIGGER [audit_cntl_2.13]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS  
    IF EXISTS (
    SELECT 1
       WHERE
       EVENTDATA().value('(/EVENT_INSTANCE/SID)[1]', 'NVARCHAR(100)')
       = 'AQ=='
	   AND
	   EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)')
	   = 'ALTER_LOGIN'
	   AND
	   EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(100)')
	   LIKE '%ENABLE%'
       )
       ROLLBACK;
