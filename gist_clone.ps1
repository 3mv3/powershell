param(
   [string]$path = 'C:\Dev\EMV3\gists',
   [string]$token = 'your-access-token'
)

$Parameters = @{
    Uri             = 'https://api.github.com/gists'
    Method          = 'GET'
    Headers         = @{
        'Accept' = 'application/vnd.github+json'
        'Authorization' = 'Bearer ' + $token
        'X-GitHub-Api-Version' = '2022-11-28'
    } 
}

$GistResponse = (Invoke-WebRequest @Parameters).Content | ConvertFrom-Json

Foreach($item in $GistResponse)
{
    $id = $item.git_pull_url

    $name = ($first = $item.files | Select -index 0 | Get-Member -MemberType NoteProperty | Select -Index 0).Name

    git -C $path clone $id $name
}