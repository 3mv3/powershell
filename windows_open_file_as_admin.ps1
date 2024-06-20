param(
   [string]$path
)

if (!$path) {
    Add-Type -AssemblyName System.Windows.Forms

    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = $Env:Programfiles }
    
    $null = $FileBrowser.ShowDialog()
    
    $path = $FileBrowser.FileName    
} 

if ($path) {
    if (!(Test-Path -Path $path)){
        throw 'Invalid path'
    }

    New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" `
        -Name $path `
        -PropertyType String `
        -Value "~ RUNASADMIN"
} 
else {
    throw 'Path required'
}