Function Test-CommandExists
{
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {if(Get-Command $command){RETURN $true}}
    Catch { RETURN $false}
    Finally {$ErrorActionPreference=$oldPreference}
}

function Write-LogMessage
{
    Param
    (
        [string]$LogMessage
    )

    Write-Host ("[{0}] " -f (Get-Date -Format "HH:mm:ss")) -ForegroundColor DarkGray -NoNewline
    Write-Host ("[{0,20}] " -f ($Cat)) -ForegroundColor Yellow -NoNewline
    Write-Output $LogMessage
}

function Restart-ComputerAndScript
{
    Write-LogMessage "Restarting Computer"
    $user = $env:UserName
    Write-LogMessage "All Updates seem to be installed"
    $A = New-ScheduledTaskAction -Execute "powershell " -Argument "-File $ScriptFile" -WorkingDirectory "$ScriptDirectory"
    $T = New-JobTrigger -AtLogOn -RandomDelay 00:00:30 -user $user
    $S = New-ScheduledTaskSettingsSet -StartWhenAvailable
    Register-ScheduledTask -Force -TaskName "Continue_OOBE_run" -Action $A -Trigger $T -Settings $S -RunLevel Highest | Out-File -append -FilePath "$ScriptDirectory\$Cat.txt"
    Restart-Computer -Confirm
}

function Remove-ScheduledTask
{
    param
    (
        [string]$taskname
    )
    if((Get-ScheduledTask | Select-String $taskname).Count -gt 0)
    {
        Get-ScheduledTask  $taskname | Disable-ScheduledTask | Out-File -append -FilePath "$ScriptDirectory\$Cat.txt"
    }
}

function Reload-Profile {
    @(
    $Profile.AllUsersAllHosts,
    $Profile.AllUsersCurrentHost,
    $Profile.CurrentUserAllHosts,
    $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }
}

Function Get-Folder($initialDirectory)

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder to store development applications in"
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
