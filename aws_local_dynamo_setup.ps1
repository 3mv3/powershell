# download dynamodb 
$path = "$HOME\Downloads\dynamo"

if (-not (Get-Item $path))
{
    Write-Host "Downloading dynamo..."
    Invoke-WebRequest "https://s3.eu-central-1.amazonaws.com/dynamodb-local-frankfurt/dynamodb_local_latest.zip" -OutFile $path + ".zip"
    Expand-Archive "$HOME\Downloads\dynamo.zip" -DestinationPath $path
    rm $path + ".zip"
}

# launch dynamo
start-process powershell -workingdirectory $path `
                -argumentlist '-noexit [Console]::Title = \"DynamoDB\"; java -D\"java.library.path=./DynamoDBLocal_lib\" -jar DynamoDBLocal.jar -sharedDb'


$tableName = "my_table"

# configure dynamodb
$table = aws dynamodb describe-table --table-name $tableName `
    --endpoint-url http://localhost:8000 `
    --region us-east-1 `
    --profile OCE_Staging_PowerUser

if(-not $table)
{
    Write-Host "Missing tables, creating now..."
    aws dynamodb create-table `
        --table-name $tableName `
        --attribute-definitions `
            AttributeName=PK,AttributeType=S `
            AttributeName=SK,AttributeType=S `
        --key-schema `
            AttributeName=PK,KeyType=HASH `
            AttributeName=SK,KeyType=RANGE `
        --provisioned-throughput `
            ReadCapacityUnits=5,WriteCapacityUnits=5 `
        --table-class STANDARD `
        --endpoint-url http://localhost:8000 `
        --region us-east-1 `
        --profile OCE_Staging_PowerUser

    aws dynamodb update-table `
        --region us-east-1 `
        --endpoint-url http://localhost:8000 `
        --profile OCE_Staging_PowerUser `
        --table-name $tableName `
        --attribute-definitions `
            AttributeName=GSI1PK,AttributeType=S `
            AttributeName=GSI1SK,AttributeType=S `
        --global-secondary-index-updates `
            '[{\"Create\":{\"IndexName\":\"GSI1\",\"KeySchema\":[{\"AttributeName\":\"GSI1PK\",\"KeyType\":\"HASH\"},{\"AttributeName\":\"GSI1SK\",\"KeyType\":\"RANGE\"}],\"Projection\":{\"ProjectionType\":\"ALL\"},\"ProvisionedThroughput\":{\"ReadCapacityUnits\": 10,\"WriteCapacityUnits\": 5}}}]'
    
    Write-Host "Tables created successfully"
}

<#
aws dynamodb delete-table --table-name RfsmartAuthenticationConfigs `
    --endpoint-url http://localhost:8000 `
    --region us-east-1 `
    --profile OCE_Staging_PowerUser
#>

aws dynamodb scan --table-name $tableName `
    --endpoint-url http://localhost:8000 `
    --region us-east-1 `
    --profile OCE_Staging_PowerUser

<# if dynamodb server gets stuck or doesn't shut down correctly
taskkill /F /PID (Get-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess)[0].Id
#>