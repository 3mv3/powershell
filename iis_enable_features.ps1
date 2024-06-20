$iisFeatures = @('IIS-WebServerRole',
'IIS-WebServer',
'IIS-CommonHttpFeatures',
'IIS-HttpErrors',
'IIS-HttpRedirect',
'IIS-ApplicationDevelopment',
'IIS-Security',
'IIS-RequestFiltering',
'IIS-NetFxExtensibility45',
'IIS-HealthAndDiagnostics',
'IIS-HttpLogging',
'IIS-RequestMonitor',
'IIS-Performance',
'IIS-WebServerManagementTools',
'IIS-ManagementScriptingTools',
'IIS-StaticContent',
'IIS-DefaultDocument',
'IIS-DirectoryBrowsing',
'IIS-CGI',
'IIS-ISAPIExtensions',
'IIS-ISAPIFilter',
'IIS-BasicAuthentication',
'IIS-HttpCompressionStatic',
'IIS-ManagementConsole',
'IIS-ManagementService',
'IIS-WindowsAuthentication',
'IIS-ASPNET45',
'IIS-ASPNET',
'IIS-NetFxExtensibility')

$features = Get-WindowsOptionalFeature -Online | Where {$_.State -eq "Disabled"}

foreach($feature in $iisFeatures)
{
    if ($features.FeatureName -eq $feature) {
	    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName $feature -All
    }
}