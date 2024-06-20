$sql.CommandText = "INSERT IGNORE INTO schema.table
	SELECT 'value', Type, Uri, Properties
	FROM schema.temptable T1 WHERE EnvironmentID = 'MOCK'
	ON DUPLICATE KEY UPDATE Uri = T1.Uri, Properties = T1.Properties;"

# when executing a non-querying task such as creating table or inserting values, use this method
$sql.ExecuteNonQuery()