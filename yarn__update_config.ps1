$_ = yarn config get 'npmScopes["testscope"].npmAuthToken'

if ($_ -eq 'null')
{
    Write-Host "Setting yarn config..."
    yarn config set npmScopes.testscope.npmAuthToken "mytoken"
}