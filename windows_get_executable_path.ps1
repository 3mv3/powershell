param(
    [string]$executable,
)

(Get-ChildItem -Path $env:LOCALAPPDATA -Recurse -Filter $executable | Select-Object -First 1 | %{$_.FullName})