param(
    [string]$site,
)

# Add 443 binding
if (-not (Get-WebBinding -Name $site -Port "443" -Protocol "https")) {
    New-WebBinding -Name $site -Port "443" -Protocol https
    (Get-WebBinding -Name $site -Port "443" -Protocol https).AddSslCertificate($cert.Thumbprint, "my")
}

# Remove 80 binding
if ((Get-WebBinding -Name $site -Port "80" -Protocol "http")) {
    Remove-WebBinding -Name $site -Port "80" -Protocol "http"
}