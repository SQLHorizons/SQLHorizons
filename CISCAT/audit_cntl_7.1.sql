USE [master]
GO

CREATE TRIGGER [audit_cntl_7.1]
ON ALL SERVER   
FOR CREATE_SYMMETRIC_KEY, ALTER_SYMMETRIC_KEY   
AS
DECLARE @CommandText NVARCHAR(MAX)
SELECT  @CommandText = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')

    IF EXISTS (
	SELECT 1
		WHERE
		SUBSTRING(@CommandText, PATINDEX('%ALGORITHM = %', @CommandText) +12, 7)
		NOT IN ('AES_128','AES_192','AES_256')
    )
    ROLLBACK;
