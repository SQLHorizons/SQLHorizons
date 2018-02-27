

DECLARE @getValue INT;
 EXEC master..xp_instance_regread
 @rootkey = N'HKEY_LOCAL_MACHINE',
 @key = N'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib',
 @value_name = N'ForceEncryption',
 @value = @getValue OUTPUT;
 SELECT @getValue;
