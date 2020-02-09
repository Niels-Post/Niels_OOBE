Function DebloatBlacklist {
    $Bloatware = @(
    "Microsoft.BingNews"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.News"
    "Microsoft.Office.Lens"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.RemoteDesktop"
    "Microsoft.SkypeApp"
    "Microsoft.StorePurchaseApp"
    "Microsoft.Office.Todo.List"
    "Microsoft.Whiteboard"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "*EclipseManager*"
    "*ActiproSoftwareLLC*"
    "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
    "*Duolingo-LearnLanguagesforFree*"
    "*PandoraMediaInc*"
    "*CandyCrush*"
    "*Wunderlist*"
    "*Flipboard*"
    "*Twitter*"
    "*Facebook*"
    "*Spotify*"
    "*Minecraft*"
    "*Royal Revolt*"
    "*Sway*"
    "*Speed Test*"
    )
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage   | Out-File -append -FilePath "$ScriptDirectory\$Cat.txt"
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online   | Out-File -append -FilePath "$ScriptDirectory\$Cat.txt"
        Write-LogMessage "Removing $Bloat."
    }
}

Function Remove-Keys {

    #These are the registry keys that it will delete.

    $Keys = @(

    #Remove Background Tasks
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

    #Windows File
    "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"

    #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

    #Scheduled Tasks to delete
    "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"

    #Windows Protocol Keys
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

    #Windows Share Target
    "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )

    #This writes the output of each key it is removing and also removes the keys listed above.
    ForEach ($Key in $Keys) {
        Write-LogMessage "Removing $Key from registry"
        if(Test-Path -Path $Key)
        {
            Remove-Item $Key -Recurse  | Out-File -append -FilePath "$ScriptDirectory\$Cat.txt"
        }
    }
}

Function Protect-Privacy {
    #Disables Windows Feedback Experience
    Write-LogMessage "Disabling Windows Feedback Experience program"
    $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    If (Test-Path $Advertising) {
        Set-ItemProperty $Advertising Enabled -Value 0
    }

    #Stops Cortana from being used as part of your Windows Search Function
    Write-LogMessage "Stopping Cortana from being used as part of your Windows Search Function"
    $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    If (Test-Path $Search) {
        Set-ItemProperty $Search AllowCortana -Value 0
    }

    #Disables Web Search in Start Menu
    Write-LogMessage "Disabling Bing Search in Start Menu"
    $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0
    If (!(Test-Path $WebSearch)) {
        New-Item $WebSearch
    }
    Set-ItemProperty $WebSearch DisableWebSearch -Value 1

    #Stops the Windows Feedback Experience from sending anonymous data
    Write-LogMessage "Stopping the Windows Feedback Experience program"
    $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
    If (!(Test-Path $Period)) {
        New-Item $Period
    }
    Set-ItemProperty $Period PeriodInNanoSeconds -Value 0

    #Prevents bloatware applications from returning and removes Start Menu suggestions
    Write-LogMessage "Adding Registry key to prevent bloatware apps from returning"
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    If (!(Test-Path $registryPath)) {
        New-Item $registryPath
    }
    Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1

    If (!(Test-Path $registryOEM)) {
        New-Item $registryOEM
    }
    Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0
    Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0
    Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0
    Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0

    #Preping mixed Reality Portal for removal
    Write-LogMessage "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
    $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
    If (Test-Path $Holo) {
        Set-ItemProperty $Holo  FirstRunSucceeded -Value 0
    }

    #Disables Wi-fi Sense
    Write-LogMessage "Disabling Wi-Fi Sense"
    $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
    $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
    $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
    If (!(Test-Path $WifiSense1)) {
        New-Item $WifiSense1
    }
    Set-ItemProperty $WifiSense1  Value -Value 0
    If (!(Test-Path $WifiSense2)) {
        New-Item $WifiSense2
    }
    Set-ItemProperty $WifiSense2  Value -Value 0
    Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0

    #Disables live tiles
    Write-LogMessage "Disabling live tiles"
    $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
    If (!(Test-Path $Live)) {
        New-Item $Live
    }
    Set-ItemProperty $Live  NoTileApplicationNotification -Value 1

    #Turns off Data Collection via the AllowTelemtry key by changing it to 0
    Write-LogMessage "Turning off Data Collection"
    $DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    $DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    $DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    If (Test-Path $DataCollection1) {
        Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0
    }
    If (Test-Path $DataCollection2) {
        Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0
    }
    If (Test-Path $DataCollection3) {
        Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0
    }

    #Disabling Location Tracking
    Write-LogMessage "Disabling Location Tracking"
    $SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
    $LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
    If (!(Test-Path $SensorState)) {
        New-Item $SensorState
    }
    Set-ItemProperty $SensorState SensorPermissionState -Value 0
    If (!(Test-Path $LocationConfig)) {
        New-Item $LocationConfig
    }
    Set-ItemProperty $LocationConfig Status -Value 0

    #Disables People icon on Taskbar
    Write-LogMessage "Disabling People icon on Taskbar"
    $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
    If (Test-Path $People) {
        Set-ItemProperty $People -Name PeopleBand -Value 0
    }

    #Disables scheduled tasks that are considered unnecessary
    Write-LogMessage "Disabling scheduled tasks"
    if((Get-ScheduledTask | Select-String "XblGameSaveTaskLogon").Count -gt 0)
    {
        Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask
    }

    Remove-ScheduledTask XblGameSaveTask
    Remove-ScheduledTask Consolidator
    Remove-ScheduledTask UsbCeip
    Remove-ScheduledTask DmClient
    Remove-ScheduledTask DmClientOnScenarioDownload

    Write-LogMessage "Stopping and disabling Diagnostics Tracking Service"
    #Disabling the Diagnostics Tracking Service
    Stop-Service "DiagTrack"
    Set-Service "DiagTrack" -StartupType Disabled


#    Write-LogMessage "Removing CloudStore from registry if it exists"
#    $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
#    If (Test-Path $CloudStore) {
#        Stop-Process (Get-Process explorer) -Force
#        Remove-Item $CloudStore -Force -Confirm:$false
#        Start-Process (Get-Process explorer) -Wait
#    }
}

Function DisableCortana {
    Write-LogMessage "Disabling Cortana"
    $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
    $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
    $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
    If (!(Test-Path $Cortana1)) {
        New-Item $Cortana1
    }
    Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0
    If (!(Test-Path $Cortana2)) {
        New-Item $Cortana2
    }
    Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1
    Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1
    If (!(Test-Path $Cortana3)) {
        New-Item $Cortana3
    }
    Set-ItemProperty $Cortana3 HarvestContacts -Value 0

}

Function UnpinStart {
    #https://superuser.com/questions/1068382/how-to-remove-all-the-tiles-in-the-windows-10-start-menu
    #Unpins all tiles from the Start Menu
    Write-LogMessage "Unpinning all tiles from the start menu"
    (New-Object -Com Shell.Application).
            NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
            Items() |
            % { $_.Verbs() } |
            ? {$_.Name -match 'Un.*pin from Start'} |
            % {$_.DoIt()}
}

Function Remove3dObjects {
    #Removes 3D Objects from the 'My Computer' submenu in explorer
    Write-LogMessage "Removing 3D Objects from explorer 'My Computer' submenu"
    $Objects32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    $Objects64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    If (Test-Path $Objects32) {
        Remove-Item $Objects32 -Recurse
    }
    If (Test-Path $Objects64) {
        Remove-Item $Objects64 -Recurse
    }
}

Function Remove-SearchBox {
    Write-LogMessage "Disabling Taskbar Search Box"
    $searchboxitem = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    if(!(Test-Path $searchboxitem)) {
        New-Item $searchboxitem
    }
    Set-ItemProperty $searchboxitem SearchboxTaskbarMode -value 0
    Stop-Process (Get-Process explorer) -Force
    Start-Process explorer.exe -Wait
    Start-Sleep -Seconds 2
}

