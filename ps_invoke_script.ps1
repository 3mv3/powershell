#Requires -RunAsAdministrator

Set-ExecutionPolicy Unrestricted

# we can load the paths of other scripts and invoke them as expressions
$vpn = Join-Path $PSScriptRoot "setup_vpn.ps1"
$download = Join-Path $PSScriptRoot "setup_installers.ps1"

# Connect, download + install, configure
try
{
    Invoke-Expression .`$vpn`
}
catch
{
    Write-Host "Error configuring vpn. Setup cannot continue until computer is connected to the icsfl.com domain. "
    exit(0)
}

Invoke-Expression .`$download`