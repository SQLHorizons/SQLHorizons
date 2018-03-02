<############ Begin script Initialise-SQLConfiguration.ps1 ####################

    Author:         Paul Maxfield
    Create date:    01/03/2018

    Script:         Initialise-SQLConfiguration
    Description:    

    Assumptions:    Execution Policy Unrestricted.

    Set Execution Policy for current process:
    $ExecutionPolicy = @{
        ExecutionPolicy = "Unrestricted"
        Scope           = "Process"
        Force           = $true
    }
    Set-ExecutionPolicy @ExecutionPolicy

    Dependencies:   Requires PowerShell module(s) AWSPowerShell.

    Inputs:         

    Warning:        

##############################################################################>

##  Input parameters?
param(
    [string]$server = $env:COMPUTERNAME
)

##  Set Error Action Preference
$ErrorActionPreference = "Stop"

Try{
    ##  Load dependent modules.
    Import-Module AWSPowerShell, SQLPS -DisableNameChecking -ErrorAction Stop

    $SQLsrv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

#######################  apply: audit_cntl_2.1 trigger  #######################

    $trigger = $step = "audit_cntl_2.1"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'Ad Hoc Distributed Queries'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()

        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.2 trigger  #######################

    $trigger = $step = "audit_cntl_2.2"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'clr enabled'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.3 trigger  #######################

    $trigger = $step = "audit_cntl_2.3"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'cross db ownership chaining'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.4 trigger  #######################

    $trigger = $step = "audit_cntl_2.4"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'Database Mail XPs'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.5 trigger  #######################

    $trigger = $step = "audit_cntl_2.5"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'Ole Automation Procedures'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply: config_cntl_2.6 settings  ######################

    $step = "config_cntl_2.6"
    $cntl_value = $SQLsrv.Configuration.RemoteAccess

    if($cntl_value.ConfigValue -eq 1){
        $cntl_value.ConfigValue = 0
        $SQLsrv.Alter()

        Write-Host "Deployed control: $step."
        [bool]$RestartService = $true
    }

    Clear-Variable cntl_value, step

#######################  apply: audit_cntl_2.6 trigger  #######################

    $trigger = $step = "audit_cntl_2.6"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'remote access'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.7 trigger  #######################

    $trigger = $step = "audit_cntl_2.7"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'remote admin connections'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.8 trigger  #######################

    $trigger = $step = "audit_cntl_2.8"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'scan for startup procs'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_2.9 trigger  #######################

    $trigger = $step = "audit_cntl_2.9"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR ALTER_DATABASE
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(100)')
          like '% SET TRUSTWORTHY ON'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply: config_cntl_2.10 setting  ######################

    $step = "config_cntl_2.10"
    $WMI = New-Object Microsoft.SqlServer.Management.SMO.Wmi.ManagedComputer($server)

    foreach($cp in $WMI.ClientProtocols){
        $ServerInstance = "/ServerInstance[@Name='MSSQLSERVER']/Server"
        $urn = $cp.Urn.Value.Replace("/Client",$ServerInstance)
        $protocol = $WMI.GetSmoObject($urn)

        if($protocol.Name -iin ("sm","tcp")){
            $protocol.IsEnabled = $true
        }
        else{
            $protocol.IsEnabled = $false
        }
        $protocol.Alter()
    }
    [bool]$RestartService = $true

#####################  apply:  config_cntl_2.12 settings  #####################

    $step = "config_cntl_2.12"
    $WmiObject = @{
        ComputerName = $server
        Namespace    = "root\Microsoft\SqlServer\ComputerManagement14"
        Class        = "ServerSettingsGeneralFlag"
    }
    $ServerSettingsGeneralFlag = Get-WmiObject @WmiObject |
        Where-Object {$_.FlagName -eq "HideInstance"}

    if($ServerSettingsGeneralFlag.FlagValue -eq $false){
        $ServerSettingsGeneralFlag.SetValue($true) | Out-Null

        [bool]$RestartService = $true
    }

#####################  apply:  config_cntl_2.13 settings  #####################

    $step = "config_cntl_2.13"
    $SQLsrv.Refresh()
    $sysadmin = $SQLsrv.Logins.ItemById(1)

    if(!($sysadmin.IsDisabled)){
        $sysadmin.Disable()
    }

######################  apply:  audit_cntl_2.13 trigger  ######################

    $trigger = $step = "audit_cntl_2.13"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/SID)[1]','NVARCHAR(MAX)')
          = 'AQ=='
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(MAX)')
          = 'ALTER_LOGIN'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')
          LIKE '%ENABLE%'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#####################  apply:  config_cntl_2.14 settings  #####################

###  Note: conntrol removed as not appropriate to rename sysadmin account!  ###

######################  apply:  audit_cntl_2.15 trigger  ######################

    $trigger = $step = "audit_cntl_2.15"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'xp_cmdshell'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply:  audit_cntl_2.16 trigger  ######################

    $trigger = $step = "audit_cntl_2.16"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR ALTER_DATABASE
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')
          like '% AUTO_CLOSE ON %'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply:  audit_cntl_2.17 trigger  ######################

    $trigger = $step = "audit_cntl_2.17"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(MAX)')
          = 'CREATE_LOGIN'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','NVARCHAR(MAX)')
          LIKE 'sa'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_3.2 trigger  #######################

    $trigger = $step = "audit_cntl_3.2"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR GRANT_DATABASE
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/Grantees/Grantee)[1]','NVARCHAR(MAX)')
          = 'guest'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/Permissions/Permission)[1]','NVARCHAR(MAX)')
          = 'connect'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_3.4 trigger  #######################

    $trigger = $step = "audit_cntl_3.4"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'contained database authentication'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 1
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_3.8 trigger  #######################

    $trigger = $step = "audit_cntl_3.8"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/Grantees/Grantee)[1]','NVARCHAR(MAX)')
          = 'public'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_3.9 trigger  #######################

    $trigger = $step = "audit_cntl_3.9"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','NVARCHAR(MAX)')
          LIKE 'BUILTIN%'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(MAX)')
          LIKE 'CREATE%'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply:  audit_cntl_3.10 trigger  ######################

    $trigger = $step = "audit_cntl_3.10"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','NVARCHAR(MAX)') 
          LIKE '$server%' 
          AND 
          EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(MAX)') 
          LIKE 'CREATE%' 
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_4.2 trigger  #######################

    $trigger = $step = "audit_cntl_4.2"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','NVARCHAR(MAX)')
          = 'ADD_SERVER_ROLE_MEMBER'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/LoginType)[1]','NVARCHAR(MAX)')
          = 'SQL Login'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/RoleName)[1]','NVARCHAR(MAX)')
          = 'sysadmin'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_4.3 trigger  #######################

    $trigger = $step = "audit_cntl_4.3"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')
          LIKE '%CHECK_POLICY=OFF%'
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply:  config_cntl_5.1 setting  ######################

    $step = "config_cntl_5.1"
    $SQLsrv.Refresh()

    if($SQLsrv.NumberOfLogFiles -ne 12){
        $SQLsrv.NumberOfLogFiles = 12
        $SQLsrv.Alter()
        Write-Host "Configured control: $step."
    }

    Clear-Variable step

#######################  apply: audit_cntl_5.2 trigger  #######################

    $trigger = $step = "audit_cntl_5.2"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        IF EXISTS (
        SELECT 1
          WHERE
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyName)[1]','NVARCHAR(MAX)')
          = 'default trace enabled'
          AND
          EVENTDATA().value('(/EVENT_INSTANCE/PropertyValue)[1]','NVARCHAR(MAX)')
          = 0
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply:  config_cntl_5.3 setting  ######################

    $step = "config_cntl_5.3"
    $SQLsrv.Refresh()

    if($SQLsrv.AuditLevel -ne "None"){
        $SQLsrv.AuditLevel = "None"
        $SQLsrv.Alter()
        Write-Host "Configured control: $step."
    }

    Clear-Variable step

########################  apply: audit_cntl_5.4 audit  ########################

    $Audit = $step = "authentication.log"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Audits.Item($Audit))){
        $adt = New-Object Microsoft.SqlServer.Management.Smo.Audit
        $adt.Parent = $SQLsrv
        $adt.Name = $Audit

        $adt.DestinationType = [Microsoft.SqlServer.Management.Smo.AuditDestinationType]::File
        $adt.FilePath = $SQLsrv.ErrorLogPath
        $adt.MaximumRolloverFiles = 1
        $adt.MaximumFileSize = 500
        $adt.ReserveDiskSpace = $true

        $adt.Create()

        ## Set audit specification properties.
        $spc = New-Object Microsoft.SqlServer.Management.Smo.ServerAuditSpecification
        $spc.Parent = $SQLsrv
        $spc.Name = $Audit.Replace('.', '.specification.')
        $spc.AuditName = $adt.Name

        ## Set audit events.
        $events  = "AuditChangeGroup","FailedLoginGroup","SuccessfulLoginGroup"

        foreach($asd in $events){
            $act = New-Object Microsoft.SqlServer.Management.Smo.AuditSpecificationDetail($asd)
            $spc.AddAuditSpecificationDetail($act)
        }

        ## Create and enable audit specification.
        $spc.Create()
        $spc.Enable()
        $adt.Enable()

        Write-Host "Configured and deployed control: $step."
        Clear-Variable adt, step
    }

#######################  apply: audit_cntl_6.2 trigger  #######################

## Develop DDL trigger to prevent deployment of CLR that is not in SAFE mode ##

#######################  apply: audit_cntl_7.1 trigger  #######################

    $trigger = $step = "audit_cntl_7.1"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        DECLARE @CommandText NVARCHAR(MAX)
        SELECT  @CommandText = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')

        IF EXISTS (
        SELECT 1
          WHERE
          SUBSTRING(@CommandText, PATINDEX('%ALGORITHM = %', @CommandText) +12, 7)
          NOT IN ('AES_128','AES_192','AES_256')
          )
          ROLLBACK;
        "

        $trg.Create()
        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

#######################  apply: audit_cntl_7.2 trigger  #######################

    $trigger = $step = "audit_cntl_7.2"
    $SQLsrv.Refresh()

    if(!($SQLsrv.Triggers.Item($trigger))){
        $trg = New-Object Microsoft.SqlServer.Management.Smo.ServerDdlTrigger
        $trg.Parent = $SQLsrv
        $trg.Name = $trigger

        $trg.TextHeader = "
        CREATE TRIGGER [$trigger]
        ON ALL SERVER
        FOR DDL_SERVER_LEVEL_EVENTS
        AS"

        $trg.TextBody = "

        DECLARE @CommandText NVARCHAR(MAX)
        SELECT  @CommandText = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVARCHAR(MAX)')

        IF EXISTS (
        SELECT 1
          WHERE
          SUBSTRING(@CommandText, PATINDEX('%ALGORITHM = %', @CommandText) +12, 8)
          IN ('RSA_1024','RSA_512')
          )
          ROLLBACK;
        "

        $trg.Create()

        Write-Host "Deployed control: $step."
        Clear-Variable trg, step
    }

######################  apply:  config_cntl_8.1 setting  ######################

    $step = "config_cntl_8.1"

    $SQLBrowser = Get-WMIObject win32_service -ComputerName $server |
        Where-Object {$_.PathName -like "*sqlbrowser.exe*"}

    if(!($SQLBrowser.StartMode -eq "Disabled")){
        Set-Service -Name $SQLBrowser.Name -StartupType Disabled
        Write-Host "Configured control: $step."
    }

    Clear-Variable step

######################  apply:  config_cntl_8.2 setting  ######################

    $step = "config_cntl_8.2"
    $WmiObject = @{
        ComputerName = $server
        Namespace    = "root\Microsoft\SqlServer\ComputerManagement14"
        Class        = "ServerSettingsGeneralFlag"
    }
    $ServerSettingsGeneralFlag = Get-WmiObject @WmiObject |
        Where-Object {$_.FlagName -eq "ForceEncryption"}

    if($ServerSettingsGeneralFlag.FlagValue -eq $false){
        $ServerSettingsGeneralFlag.SetValue($true) | Out-Null

        [bool]$RestartService = $true
    }

######################  apply:  config_cntl_8.4 setting  ######################



######################  apply:  config_cntl_8.5 setting  ######################



###############################################################################

}
Catch [System.OutOfMemoryException]{
    ##Restart-Computer localhost
}
Catch{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host "Error at $step in $FailedItem. The error message was $ErrorMessage"
    Break
}
Finally{
    if($RestartService){
        Restart-Service -Name MSSQLSERVER -ErrorAction SilentlyContinue
    }
}
