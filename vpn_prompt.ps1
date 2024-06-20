# I use this with a scheduled task on-login to log onto vpn straight away
$vpns = (Get-VpnConnection | select -Property Name); 
rasdial $vpns[$host.ui.PromptForChoice('', 'Choose a VPN', ($vpns | ForEach-Object{ New-Object System.Management.Automation.Host.ChoiceDescription $_.Name }), 0)].Name; 