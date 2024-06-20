$applications = @{
  'app1' = @{
    pool = 'application1'
    clr = 'v4.0'
    path = 'c:\dev\repo\application1'
  }
  'app2' = @{
    pool = 'application2'
    clr = 'v4.0'
    path = 'c:\dev\repo\application2'
  }
}

# Setup app pools
foreach($key in $applications.Keys)
{
  $app = $applications[$key]

  if(Test-Path IIS:\AppPools\$($_.PoolName))
  {
    Remove-WebAppPool $app.pool
  }

  $appPool = New-WebAppPool -Name $app.pool -Force
  Set-ItemProperty -Path IIS:\AppPools\$($app.pool) managedRuntimeVersion $app.clr

  if(Test-Path "IIS:\Sites\Default Web Site\$($key)") 
  {
    Remove-WebApplication -Site "Default Web Site" -Name $key
  }
  
  New-WebApplication -Name $key -Site "Default Web Site" -PhysicalPath $app.path -ApplicationPool $app.pool
}