CREATE TRIGGER [audit_cntl_3.2]
    ON DATABASE
    FOR GRANT_DATABASE
AS
BEGIN
	DECLARE @EventData XML = EVENTDATA();
	DECLARE @value Bit;

SELECT   
   @value = CASE   
      WHEN @EventData.value('(/EVENT_INSTANCE/Grantees/Grantee)[1]',   'NVARCHAR(100)') = 'guest'
	  AND @EventData.value('(/EVENT_INSTANCE/Permissions/Permission)[1]',   'NVARCHAR(100)') = 'connect'
	  THEN 1   
      ELSE 0  
   END

   IF @value = 1 ROLLBACK

END
