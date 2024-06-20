$acl = Get-Acl -Path $path

$hasRights = ($acl | Select -ExpandProperty Access | Where {$_.FileSystemRights -eq "FullControl" -and $_.AccessControlType -eq "Allow" -and $_.IdentityReference -eq "BUILTIN\Users"}) -ne $null

if (-Not $hasRights)
{
    Write-Host "Updating access rights on folder..."

    $access = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","FullControl","ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($access)
    $acl | Set-Acl $path
}