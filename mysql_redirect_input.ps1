# this script allows you to redirect input yo my sql using an existing file

param(
    [string]$server,
    [string]$password,
    [string]$schema
)

$mySql = 'C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll'
if (!(Test-Path $mySql -PathType Leaf))
{
	throw "Install MySQL workbench before running the SQL setup."
}
else
{
	Add-Type -Path $mySql
}
 
$Connection = [MySql.Data.MySqlClient.MySqlConnection]@{ConnectionString="server=$server;uid=root;pwd=$password"}
$Connection.Open()

$sql = New-Object MySql.Data.MySqlClient.MySqlCommand
$sql.Connection = $Connection

$sqlPath = 'C:\Dev\Installers\example.sql'

$spParams = @{
    FilePath               = 'C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe'
    ArgumentList           = @(
        "--host=$server"
        '--user=root'
        "--password=$password"
        $schema
    )
    RedirectStandardInput  = $sqlPath
    Wait                   = $true
}
Start-Process @spParams