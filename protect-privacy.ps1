#This will self elevate the script with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
  Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
  Start-Sleep 1
  Write-Host "3"
  Start-Sleep 1
  Write-Host "2"
  Start-Sleep 1
  Write-Host "1"
  Start-Sleep 1
  $CurrentShell = (Get-Process -Id $pid -FileVersionInfo | Select-Object -Property FileName).FileName
  Start-Process $CurrentShell -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
  Exit
}
  
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

Function Protect-Privacy {
  #Disables Windows Feedback Experience
  Write-Output "Disabling Windows Feedback Experience program"
  $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
  If (Test-Path $Advertising) {
    Set-ItemProperty $Advertising Enabled -Value 0 
  }

  #Stops Cortana from being used as part of your Windows Search Function
  Write-Output "Stopping Cortana from being used as part of your Windows Search Function"
  $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
  If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0 
  }

  #Disables Web Search in Start Menu
  Write-Output "Disabling Bing Search in Start Menu"
  $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
  Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
  If (!(Test-Path $WebSearch)) {
    New-Item $WebSearch
  }
  Set-ItemProperty $WebSearch DisableWebSearch -Value 1 
      
  #Stops the Windows Feedback Experience from sending anonymous data
  Write-Output "Stopping the Windows Feedback Experience program"
  $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
  If (!(Test-Path $Period)) { 
    New-Item $Period
  }
  Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

  #Prevents bloatware applications from returning and removes Start Menu suggestions
  Write-Output "Adding Registry key to prevent bloatware apps from returning"
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
  Write-Output "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
  $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
  If (Test-Path $Holo) {
    Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
  }

  #Disables Wi-fi Sense
  Write-Output "Disabling Wi-Fi Sense"
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
  Write-Output "Disabling live tiles"
  $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
  If (!(Test-Path $Live)) {
    New-Item $Live
  }
  Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 

  #Turns off Data Collection via the AllowTelemtry key by changing it to 0
  Write-Output "Turning off Data Collection"
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
  Write-Output "Disabling Location Tracking"
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
  Write-Output "Disabling People icon on Taskbar"
  $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
  If (Test-Path $People) {
    Set-ItemProperty $People -Name PeopleBand -Value 0
  }

  #Disables scheduled tasks that are considered unnecessary 
  Write-Output "Disabling scheduled tasks"
  Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask
  Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask
  Get-ScheduledTask  Consolidator | Disable-ScheduledTask
  Get-ScheduledTask  UsbCeip | Disable-ScheduledTask
  Get-ScheduledTask  DmClient | Disable-ScheduledTask
  Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask

  Write-Output "Stopping and disabling Diagnostics Tracking Service"
  #Disabling the Diagnostics Tracking Service
  Stop-Service "DiagTrack"
  Set-Service "DiagTrack" -StartupType Disabled

  Write-Output "Removing CloudStore from registry if it exists"
  $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
  If (Test-Path $CloudStore) {
    Stop-Process Explorer.exe -Force
    Remove-Item $CloudStore
    Start-Process Explorer.exe -Wait
  }
}

Function Disable-Cortana {
  Write-Host "Disabling Cortana"
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

Protect-Privacy 
Disable-Cortana

Write-Host "Exiting in 3 seconds"
Start-Sleep 1
Write-Host "1"
Start-Sleep 1
Write-Host "2"
Start-Sleep 1
Write-Host "3"