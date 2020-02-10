######################################## Startup ###############################################
Clear-Host
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Welcome to Niels' Out Of Box Experience"
Write-Host ""
$ProgressPreference = 'SilentlyContinue'
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ScriptFile = $MyInvocation.MyCommand.Definition

. ("$ScriptDirectory\Utility.ps1")
. ("$ScriptDirectory\Config.ps1")

if ((Get-ScheduledTask | Select-String "Continue_OOBE_run").Count -gt 0)
{
    Write-LogMessage "Removing Startup Task"
    Unregister-ScheduledTask -TaskName "Continue_OOBE_run" -Confirm:$false
}

###############################################################################################



######################################## Perform all Windows Updates###########################
$Cat = "Windows Update"



if ((Get-PackageProvider -Name NuGet).Count -eq 0)
{
    Write-LogMessage "Adding NuGet Package Provider"
    Install-PackageProvider -Name NuGet -Force
}
else
{
    Write-LogMessage "NuGet Package Provider is already added"
}

if (!(Test-CommandExists Get-WindowsUpdate))
{
    Write-LogMessage "Installing PSWindowsUpdate Module"
    Install-Module PSWindowsUpdate -Force
}
else
{
    Write-LogMessage "PSWindowsUpdate is already installed"
}

Write-LogMessage "Checking for Windows Updates"
Import-Module PSWindowsUpdate
if ((Get-WindowsUpdate).Count -gt 0)
{
    Write-LogMessage "Installing Windows Updates"
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot | Out-File -append -FilePath "$ScriptDirectory\Log.txt"
    Restart-ComputerAndScript
}

if($Enable_WSL) {
    $feature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    if($feature.State -ne "Enabled") {
        Write-LogMessage "Enabling WSL"
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        Restart-ComputerAndScript
    }
}

###############################################################################################


######################################## Debloat ##############################################
#$Cat = "Debloat"
#
. ("$ScriptDirectory\Debloat.ps1")
#
#New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-File -append -FilePath "$ScriptDirectory\Debloat.txt"
#
#DebloatBlacklist
#Remove-Keys
#Protect-Privacy
#DisableCortana
#UnpinStart
#Remove3dObjects
Remove-SearchBox
#Remove-PSDrive HKCR

###############################################################################################



######################################## Chocolatey install ###################################
$Cat = "Chocolatey_Install"

if (!(Test-CommandExists Chocolatey))
{
    Write-LogMessage "Installing Chocolatey Module"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) *>&1 | Out-File -append -FilePath "$ScriptDirectory\Chocolatey_install.txt"

    Write-LogMessage "Reloading Profile to activate chocolatey"
    . Reload-Profile
}
###############################################################################################


######################################## App install ##########################################
$Cat = "App_install"

$devapps_folder = Get-Folder

Write-LogMessage $devapps_folder


if($Install_git) {
    Write-LogMessage "Installing git"
    choco install -y git --install-args="/DIR=$devapps_folder\git"  *>&1 | Out-File -append -FilePath "$ScriptDirectory\git.txt"
}

if($Install_CLion) {
    Write-LogMessage "Installing CLion"
    choco install -y clion-ide --install-args="/D=$devapps_folder\Jetbrains\CLion"  *>&1 | Out-File -append -FilePath "$ScriptDirectory\Jetbrains_CLion.txt"

    $subpath = "$devapps_folder\Jetbrains\CLion" -Replace "\\","/"
    (Get-Content "$devapps_folder\Jetbrains\CLion\bin\idea.properties") -Replace "# idea\.config\.path=[^\n]*","idea.config.path=$subpath/config" | Set-Content "$devapps_folder\Jetbrains\CLion\bin\idea.properties"
    (Get-Content "$devapps_folder\Jetbrains\CLion\bin\idea.properties") -Replace "# idea\.system\.path=[^\n]*","idea.system.path=$subpath/system" | Set-Content "$devapps_folder\Jetbrains\CLion\bin\idea.properties"

}

if($Install_PyCharm) {
    Write-LogMessage "Installing PyCharm"
    choco install -y Pycharm --install-args="/D=$devapps_folder\Jetbrains\PyCharm"  *>&1 | Out-File -append -FilePath "$ScriptDirectory\Jetbrains_PyCharm.txt"

    $subpath = "$devapps_folder\Jetbrains\PyCharm" -Replace "\\","/"
    (Get-Content "$devapps_folder\Jetbrains\PyCharm\bin\idea.properties") -Replace "# idea\.config\.path=[^\n]*","idea.config.path=$subpath/config" | Set-Content "$devapps_folder\Jetbrains\PyCharm\bin\idea.properties"
    (Get-Content "$devapps_folder\Jetbrains\PyCharm\bin\idea.properties") -Replace "# idea\.system\.path=[^\n]*","idea.system.path=$subpath/system" | Set-Content "$devapps_folder\Jetbrains\PyCharm\bin\idea.properties"

}

if($Install_WebStorm) {
    Write-LogMessage "Installing WebStorm"
    choco install -y WebStorm --install-args="/D=$devapps_folder\Jetbrains\WebStorm"  *>&1 | Out-File -append -FilePath "$ScriptDirectory\Jetbrains_WebStorm.txt"

    $subpath = "$devapps_folder\Jetbrains\WebStorm" -Replace "\\","/"
    (Get-Content "$devapps_folder\Jetbrains\WebStorm\bin\idea.properties") -Replace "# idea\.config\.path=[^\n]*","idea.config.path=$subpath/config" | Set-Content "$devapps_folder\Jetbrains\WebStorm\bin\idea.properties"
    (Get-Content "$devapps_folder\Jetbrains\WebStorm\bin\idea.properties") -Replace "# idea\.system\.path=[^\n]*","idea.system.path=$subpath/system" | Set-Content "$devapps_folder\Jetbrains\WebStorm\bin\idea.properties"

}

if($Install_IntelliJ) {
    Write-LogMessage "Installing IntelliJ"
    choco install -y intellijidea-ultimate --install-args="/D=$devapps_folder\Jetbrains\IntelliJ"  *>&1 | Out-File -append -FilePath "$ScriptDirectory\Jetbrains_IntelliJ.txt"

    $subpath = "$devapps_folder\Jetbrains\IntelliJ" -Replace "\\","/"
    (Get-Content "$devapps_folder\Jetbrains\IntelliJ\bin\idea.properties") -Replace "# idea\.config\.path=[^\n]*","idea.config.path=$subpath/config" | Set-Content "$devapps_folder\Jetbrains\IntelliJ\bin\idea.properties"
    (Get-Content "$devapps_folder\Jetbrains\IntelliJ\bin\idea.properties") -Replace "# idea\.system\.path=[^\n]*","idea.system.path=$subpath/system" | Set-Content "$devapps_folder\Jetbrains\IntelliJ\bin\idea.properties"

}

if($Install_Rider) {
    Write-LogMessage "Installing Rider"
    choco install -y jetbrains-rider --install-args="/D=$devapps_folder\Jetbrains\Rider"  *>&1 | Out-File -append -FilePath "$ScriptDirectory\Jetbrains_Rider.txt"

    $subpath = "$devapps_folder\Jetbrains\Rider" -Replace "\\","/"
    (Get-Content "$devapps_folder\Jetbrains\Rider\bin\idea.properties") -Replace "# idea\.config\.path=[^\n]*","idea.config.path=$subpath/config" | Set-Content "$devapps_folder\Jetbrains\Rider\bin\idea.properties"
    (Get-Content "$devapps_folder\Jetbrains\Rider\bin\idea.properties") -Replace "# idea\.system\.path=[^\n]*","idea.system.path=$subpath/system" | Set-Content "$devapps_folder\Jetbrains\Rider\bin\idea.properties"
}


if($Install_Office) {
    Write-LogMessage "Installing Office"
    Write-LogMessage "Not Implemented Yet"
}


if($Install_Edge) {
    Write-LogMessage "Installing Edge"
    choco install -y microsoft-edge  *>&1 | Out-File -append -FilePath "$ScriptDirectory\Microsoft_Edge.txt"
}

if($Install_Ubuntu) {
    Write-LogMessage "Downloading Ubuntu"
    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing
    Write-LogMessage "Installing Ubuntu"
    Add-AppxPackage .\Ubuntu.appx
    Write-LogMessage "Please setup ubuntu with your username and password"
    Start-Process wsl.exe -Wait
    Start-Process wsl -ArgumentList "sudo apt update; sudo apt upgrade; sudo apt install git" -Wait
}

if($Install_HWLib) {
    Write-LogMessage "Cloning Installer directory"
    Start-Process wsl -ArgumentList "git clone https://github.com/wovo/installers" -Wait -WorkingDirectory $devapps_folder
    Write-LogMessage "Running APT Installer directory"
    Start-Process wsl -ArgumentList "cd installers; sudo chmod +x ubuntu1; sudo ./ubuntu1" -Wait -WorkingDirectory $devapps_folder
    Write-LogMessage "Cloning HWLib"
    Start-Process wsl -ArgumentList "git clone https://github.com/wovo/hwlib" -Wait -WorkingDirectory $devapps_folder
    Write-LogMessage "Cloning BMPTK"
    Start-Process wsl -ArgumentList "git clone https://github.com/wovo/bmptk" -Wait -WorkingDirectory $devapps_folder
    Write-LogMessage "Cloning RTOS"
    Start-Process wsl -ArgumentList "git clone https://github.com/wovo/rtos" -Wait -WorkingDirectory $devapps_folder
    Write-LogMessage "Cloning Catch2"
    Start-Process wsl -ArgumentList "git clone https://github.com/catchorg/Catch2" -Wait -WorkingDirectory $devapps_folder

    $wsl_devapps_path = wsl wslpath -a $devapps_folder.Replace("\","\\")
    Start-Process wsl -ArgumentList "sed `"1iexport HWLIB='$wsl_devapps_path/hwlib'`" ~/.bashrc > ~/.bashrc2;cp ~/.bashrc2 ~/.bashrc" -Wait -WorkingDirectory $devapps_folder
    Start-Process wsl -ArgumentList "sed `"1iexport BMPTK='$wsl_devapps_path/bmptk'`" ~/.bashrc > ~/.bashrc2;cp ~/.bashrc2 ~/.bashrc" -Wait -WorkingDirectory $devapps_folder
    Start-Process wsl -ArgumentList "sed `"1iexport RTOS='$wsl_devapps_path/rtos'`" ~/.bashrc > ~/.bashrc2;cp ~/.bashrc2 ~/.bashrc" -Wait -WorkingDirectory $devapps_folder
    Start-Process wsl -ArgumentList "sed `"1iexport CATCH='$wsl_devapps_path/Catch2'`" ~/.bashrc > ~/.bashrc2;cp ~/.bashrc2 ~/.bashrc" -Wait -WorkingDirectory $devapps_folder

}