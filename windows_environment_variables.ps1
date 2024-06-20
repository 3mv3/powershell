# functions are always defined at the top of the file
# function parameters can be defined in multiple ways, but I prefer this syntax
# this function returns a bool
function HasEnvironmentVariable([string]$varName)
{
    ![string]::IsNullOrWhiteSpace(([Environment]::GetEnvironmentVariable($varName, 'User')))
}

if (!(HasEnvironmentVariable('NUGET_REPOSITORY')))
{
    Write-Host "Setting nuget repository environment variable..."
    [System.Environment]::SetEnvironmentVariable('NUGET_REPOSITORY',
        "https://mynugetexample.com/index.json",
        "User")
}