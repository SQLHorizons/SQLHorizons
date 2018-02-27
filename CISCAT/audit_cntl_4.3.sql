CREATE TRIGGER [audit_cntl_4.3]
ON ALL SERVER   
FOR DDL_SERVER_LEVEL_EVENTS   
AS
    IF EXISTS (
    SELECT 1
        WHERE
        EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
        LIKE '%CHECK_POLICY=OFF%'
        )
        ROLLBACK;