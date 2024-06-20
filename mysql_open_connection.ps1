
param(
    [string]$server,
    [string]$password
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
$sql.CommandText = 'CREATE SCHEMA `test-schema`'

try
{
    $sql.ExecuteNonQuery()
}
catch
{
    # Should throw if schema already exists
}