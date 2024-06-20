#Requires -RunAsAdministrator
Function import($path)
{
    Write-Host "Importing new cert to machine store: " + $path
    $cert = Import-PfxCertificate -FilePath $HOME\Downloads\temp.pfx -CertStoreLocation $path -Password (ConvertTo-SecureString -String "password" -AsPlainText -Force)
    Write-Host "Cert imported!"
    return $cert
}

Write-Host "Removing legacy localhost certificates..."
gci "Cert:\*\" -Recurse | Where-Object { $_.Subject -clike '*localhost*' } | rm
Write-Host "Legacy certificates removed!"

Write-Host "Creating new trusted cert with highly secure SOC2 password..."
dotnet dev-certs https --trust -ep $HOME\downloads\temp.pfx --password 'password'
Write-Host "Cert created under current user profile and exported!"

$cert = import -path Cert:\LocalMachine\My
$cert = import -path Cert:\LocalMachine\AuthRoot

Write-Host "Re-binding IIS default site..."
(Get-WebBinding -Name "Default Web Site" -Port "443" -Protocol https).AddSslCertificate($cert.Thumbprint, "my")
Write-Host "IIS re-bound!"

Write-Host "Cert management complete."