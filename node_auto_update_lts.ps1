function Move-To-Lts
{
    # nvm use has to run on elevated perms
    Write-Host "Moving to lts..."
    Start-Process powershell -Verb RunAs -ArgumentList 'nvm use lts' -Wait -WindowStyle Hidden
}

# try install
$resp = nvm install lts

if ($resp -and $resp.Contains('is already installed'))
{
    # extract version number using regex
    $_ = $resp -match 'Version ((\d*).(\d*).(\d*)) is already installed'

    $cur = nvm current

    if (-not $cur.Contains($matches[1]))
    {
        Move-To-Lts
    }
    else
    {
        Write-Host "Already on lts"
    }
}
else
{
    Move-To-Lts
}