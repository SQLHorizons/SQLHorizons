ALTER TRIGGER [audit_cntl_2.16]
ON ALL SERVER   
FOR ALTER_DATABASE   
AS
    IF EXISTS (
    SELECT 1
       WHERE
       EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(100)')
       like '% AUTO_CLOSE ON WITH NO_WAIT'
       )
       ROLLBACK;
