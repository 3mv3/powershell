# powershell script that adds a visual studio tool which references this script and can be triggered from within VS

# Requires visual studio to be closed
# Open config file, change 16. to match the version you want
$filename = Resolve-Path "c:\users\$env:UserName\appdata\local\microsoft\visualstudio\16.*\settings\CurrentSettings.vssettings" | Select -ExpandProperty Path
$xmlDoc = New-Object xml
$xmlDoc.Load($filename)
$modified = $False;

# Check if tool already exists
If(($xmlDoc.SelectNodes("//ExternalTools/UserCreatedTool") | Where-Object {$_.Title -match 'Update Endpoints'}).Count -eq 0)
{
    $extTools = $xmlDoc.SelectSingleNode('//ExternalTools');
[xml]$setupNode = @"
<UserCreatedTool>
    <Arguments>-file "$PSScriptRoot\urlupdate.ps1 -domain -region"</Arguments>
    <CloseOnExit>true</CloseOnExit>
    <Command>C:\windows\system32\windowspowershell\v1.0\powershell.exe</Command>
    <Index>3</Index>
    <InitialDirectory/>
    <IsGUIapp>false</IsGUIapp>
    <NameID>0</NameID>
    <Package>{00000000-0000-0000-0000-000000000000}</Package>
    <PromptForArguments>true</PromptForArguments>
    <SaveAllDocs>true</SaveAllDocs>
    <Title>Update Endpoints</Title>
    <Unicode>false</Unicode>
    <UseOutputWindow>true</UseOutputWindow>
    <UseTaskList>false</UseTaskList>
</UserCreatedTool>
"@
    $extTools.AppendChild($xmlDoc.ImportNode($setupNode.UserCreatedTool, $true))
    $modified = $True;
}

If ($modified)
{
    $xmlDoc.Save($filename)
}