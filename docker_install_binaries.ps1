$downloadPath = (([environment]::GetFolderPath("mydocuments")) + '/docker-20.10.9.zip')
$programPath = ([environment]::GetFolderPath("programfiles"))

Invoke-WebRequest -Uri 'https://download.docker.com/win/static/stable/x86_64/docker-20.10.9.zip' -OutFile $downloadPath

$docker = "'$($Env:ProgramFiles + "\Docker\dockerd")'"
$args = "-Command `"Expand-Archive -LiteralPath '$downloadPath' -DestinationPath '$programPath'; &$docker --register-service`""

# need to run file expansion and dockerd using elevated perms
Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", $args -Wait

&$Env:ProgramFiles\Docker\dockerd --register-service

Start-Service docker

&$Env:ProgramFiles\Docker\docker run hello-world:nanoserver