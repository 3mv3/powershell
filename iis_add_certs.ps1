# Get certs
$cert = Get-ChildItem -Path Cert:\LocalMachine\my | Where {$_.Subject -match "test-cert"}
$compName = (Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select Name).Name
$default = "Default Web Site"

if (-Not $cert) {
    $certKeyPath = "c:\test-cert.pfx"
    $password = ConvertTo-SecureString 'password' -AsPlainText -Force
    $cert = New-SelfSignedCertificate -DnsName @("test-cert", "test-cert.com", "localhost") -CertStoreLocation "cert:\LocalMachine\My"
    $cert | Export-PfxCertificate -FilePath $certKeyPath -Password $password
    $rootCert = $(Import-PfxCertificate -FilePath $certKeyPath -CertStoreLocation 'Cert:\LocalMachine\Root' -Password $password)
}