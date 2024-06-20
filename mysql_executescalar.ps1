# use .ExecuteScalar when you want mysql to return values
params(
  [string]$server,
  [string]$password,
  [string]$schema
)

$Connection = [MySql.Data.MySqlClient.MySqlConnection]@{ConnectionString="server=$server;uid=root;pwd=$password;database=$schema"}
$Connection.Open()

$sql = New-Object MySql.Data.MySqlClient.MySqlCommand
$sql.Connection = $Connection

$sql.CommandText = "SHOW TABLES LIKE 'schema.endpoints'"

try
{
    $FirstTime = $sql.ExecuteScalar()

    If ($FirstTime -eq $null)
    {
        # query returned no results
    }
    else
    {
        # query returned results
    }
}
catch
{
    Write-Host "An error occurred:"
    Write-Host $_
    exit
}