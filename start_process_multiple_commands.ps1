# arsg without interpolation can be passed like so
$args1 = "cd C:\Dev"

# if you are using string interpolation for variables,
# then when you pass this arg to start-process it needs to be
# wrapped in quotations
$args2 = "`"Write-Host $env:computername`""

$args3 = "Write-Host $env:username"

$command = [string]::Concat($args1, ";", $args2, ";", $args3)

Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", '-Command', $command -Wait