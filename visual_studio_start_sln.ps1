param(
    [string]$slnPath
)

if (-not (Test-Path -Path $slnPath))
{
    Write-Host "invalid path"
    exit(0)
}

$file = [io.path]::GetFileNameWithoutExtension($slnPath)

# Open SLN if not already open
If(!(Get-Process | Where-Object { $_.MainWindowTitle -match $file -and $_.ProcessName -eq 'devenv' })) 
{
    Start-Process devenv `
         -ArgumentList $slnPath `
         -Verb runAs
}