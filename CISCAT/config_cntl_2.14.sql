USE [master]

IF EXISTS (SELECT SUSER_ID('sa'))
BEGIN
	ALTER LOGIN sa WITH NAME = [dbAdmin]
END
