param(
    [string]$downloadPath,
    [string]$clonePath,
    [switch]$enforceDomain
)

if ($enforceDomain.IsPresent)
{
    try
    {
        [void]::([System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain())
    }
    catch
    {
        Write-Host "Computer must be connected to the company network to continue."
        exit(0)
    }
}

# Downloads and installs
if(!$downloadPath) {
    $downloadPath = 'C:\Dev\Installers'
}

if (!(Test-Path $downloadPath -PathType Container))
{
	New-Item -ItemType Directory -Force -Path $downloadPath
}

$programs = @{
	
	# Developer specific
	'Visual Studio' = @{
		url = "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=enterprise&channel=Release&version=VS2022&source=VSLandingPage&includeRecommended=true&cid=2030"
		downloadPath = ''
	}
	'Git' = @{
		url = "https://github.com/git-for-windows/git/releases/download/v2.34.1.windows.1/Git-2.34.1-64-bit.exe"
		downloadPath = ''
	}
	'MySQL' = @{
		url = "https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.7.36.1.msi"
		downloadPath = ''
	}
	'Python' = @{ 
		url = "https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe"
		downloadPath = ''
	}
	'JDK' = @{ 
		url = "https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.msi"
		downloadPath = ''
	}
	'NVM' = @{ 
		url = "https://github.com/coreybutler/nvm-windows/releases/download/1.1.8/nvm-setup.zip"
		downloadPath = ''
	}
	'Redis' = @{ 
		url = "https://github.com/microsoftarchive/redis/releases/download/win-3.0.504/Redis-x64-3.0.504.msi"
		downloadPath = ''
	}
	'.NET SDK' = @{ 
		url = "https://download.visualstudio.microsoft.com/download/pr/5303da13-69f7-407a-955a-788ec4ee269c/dc803f35ea6e4d831c849586a842b912/dotnet-sdk-5.0.403-win-x64.exe"
		downloadPath = ''
	}
	'Visual Studio Code' = @{ 
		url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
		downloadPath = ''
	}
	'Postman' = @{ 
		url = 'https://dl.pstmn.io/download/latest/win32'
		downloadPath = ''
	}
	'AWS Command Line Interface' = @{
		url = 'https://awscli.amazonaws.com/AWSCLIV2.msi'
		downloadPath = ''
	}
	'Android CLI' = @{
		url = 'https://dl.google.com/android/repository/commandlinetools-win-7583922_latest.zip'
		downloadPath = ''
	}

	# General
	'Toggl' = @{
		url = 'https://toggl.com/track/toggl-desktop/downloads/TogglTrack-windows64.exe'
		downloadPath = ''
	}
}

# Begin all downloads
$jobs = $programs.Keys | ForEach-Object {
    
	$program = $programs[$_]
    
    # check if program is already installed under machine or current user
	$installed = ((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).displayname -Match $_ -or (gp HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -match $_)

    # program specific installation checks
	If($_ -eq 'Android CLI') {
		$installed = (Test-Path 'C:\android\tools' -PathType Container)
	}

    If($_ -eq 'Postman') {
        $installed = (Test-Path "$HOME\AppData\Local\Postman")
    }

    If($installed)
    {
        Write-Host "$_ is already installed, skipping download/install."
    }
    else
    {
		$program.downloadPath = $downloadpath + "\" + (Split-Path $program.url -Leaf)

        If($_ -eq 'Visual Studio Code') {
			$program.downloadPath = $downloadpath + "\" + "VSCodeUserSetup - x64.exe"
        }
        
        If($_ -eq 'Visual Studio') {
			$program.downloadPath = $downloadpath + "\" + "VisualStudio.exe"
        }

        If($_ -eq 'Postman') {
            $program.downloadPath = $downloadpath + "\" + "Postman-x32.exe"
        }

        If($_ -eq 'Slack') {
            $program.downloadPath = $downloadpath + "\" + "SlackSetup.exe"
        }

        If($_ -eq 'Zoom') {
            $program.downloadPath = $downloadpath + "\" + "ZoomInstaller.exe"
        }

        If(!(Test-Path $program.downloadPath -PathType Leaf))
		{
            Start-Job -Name $_ {Invoke-WebRequest -Uri $using:program.url -OutFile $using:program.downloadPath}
        }
    }
}

# await job completion
$jobs | Wait-Job

Write-Host "Downloads finished, moving to install..."

# Run all installers
foreach($key in $programs.Keys)
{
    $dp = $programs[$key].downloadPath

    # Did we actual download anything?
    if ($dp -eq $null -or $dp -eq "") 
    {
        continue;
    }

    Write-Host "Installing $key..."

	# Try run the installer
	if ($dp -notmatch '.zip$') 
	{
		Start-Process -FilePath $dp -Wait
	}
	else 
	{
		$destination = $dp
		if ($key -eq 'Android CLI') {
			$destination = 'C:\android\tools'
		}

        # unzip any ziped files
		Expand-Archive -LiteralPath $dp -DestinationPath $destination

        # remove installer
		Remove-Item -LiteralPath $dp
	}
}

# NVM install
nvm install 8.11
nvm install 14.18
nvm use 14.18

# Git cloning
$repositories = @(
    "https://github.com/3mv3/powershell.git"
)

if (!$clonePath) {
    $clonePath = 'C:\Dev'
}

foreach($repo in $repositories) {
    git -C $clonePath clone $repo
}

# Install yarn USING node version 14.18
try
{
	npm | Out-Null
    Write-Host "Npm already installed"

	try
	{
		yarn | Out-Null
		Write-Host "Yarn already installed"
	}
	catch [System.Management.Automation.CommandNotFoundException]
	{
		Write-Host "Installing yarn..."
		npm install -g yarn
	}
}
catch [System.Management.Automation.CommandNotFoundException]
{
	Write-Host "Npm not installed, skipping yarn install"
}

# remove installer folder
Remove-Item -Force -Path $downloadPath -Recurse