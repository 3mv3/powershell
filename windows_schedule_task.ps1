param(
    [string]$taskName,
    [string]$description,
    [string]$executable
)

if (-Not (Get-ScheduledTask | Where {$_.TaskName -eq $taskName}))
{
    Write-Host "Creating scheduled task..."

    $task = New-ScheduledTaskAction -Execute $executable -Argument ""

    $trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
    $trigger.Repetition = (New-ScheduledTaskTrigger -Once -At "12am" -RepetitionInterval (New-TimeSpan -Hours 4) -RepetitionDuration (New-TimeSpan -Hours 24)).repetition

    $reg = Register-ScheduledTask -TaskName $taskName -Description $description -Trigger $trigger -Action $task
}