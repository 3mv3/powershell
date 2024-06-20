# if file was updated more than 4 hours ago, it needs updating
if ((Get-Item "C:\Users\$env:UserName\.aws\credentials").LastWriteTime -lt (Get-Date).AddHours(-4))
{
    Write-Host "Credentials need updating"
}