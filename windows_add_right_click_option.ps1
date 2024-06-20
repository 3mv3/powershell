# this script adds a menu item to the right-click menu with the option to open powershell in the current directory
# as an administrator

try
{
	New-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell" -Name PowerShellAsAdmin -Value "Open PowerShell window here as administrator"
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\PowerShellAsAdmin" -Name "Extended" -Value â€â€  -PropertyType "String"
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\PowerShellAsAdmin" -Name "HasLUAShield" -Value â€â€  -PropertyType "String"
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\PowerShellAsAdmin" -Name "Icon" -Value â€powershell.exeâ€  -PropertyType "String"

	$cmd = "Start-Process powershell  -ArgumentList '-NoExit', '-Command cd %V' -Verb runAs"
	New-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\PowerShellAsAdmin" -Name command -Value "C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -windowstyle hidden -Command $cmd"  
}
catch
{
	Write-Host "Failed to add powershell admin shortcut"
}