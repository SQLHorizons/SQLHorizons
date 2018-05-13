
###################  DacServices.Register Method Variables  ###################

$targetDatabaseName = @{
    Name        = "trgDBName"
    Description = "The name of the database for which to add registration information."
    Value       = "MasterSQLPlus"
}
Set-Variable @targetDatabaseName

$applicationName = @{
    Name        = "appName"
    Description = "The application name to be stored in the DAC metadata."
    Value       = "MasterSQLPlus"
}
Set-Variable @applicationName

$applicationVersion = @{
    Name        = "appVersion"
    Description = "The version number to be stored in the DAC metadata."
    Value       = $([System.Version]"1.0.0.0")
}
Set-Variable @applicationVersion

$applicationDescription = @{
    Name        = "appDesc"
    Description = "The application description to be stored in the DAC metadata."
    Value       = ""
}
Set-Variable @applicationDescription

####################################  END  ####################################
