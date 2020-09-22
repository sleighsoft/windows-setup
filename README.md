# Debloat & Setup Windows 10

Removes unwanted software from Windows 10 installations & installs some useful applications!

**Note:** These scripts are 100% based on personal preference. You may clone this repository and start your own Windows setup.

## Installs

Installs some useful software instead:

- Powershell Core (to `C:\Programs\PowerShell\`) (https://github.com/PowerShell/PowerShell)

- scoop (package manager) (https://github.com/lukesampson/scoop)
    - grep
    - which
    - miniconda (https://docs.conda.io/en/latest/miniconda.html)
    - posh-git (https://github.com/dahlbyk/posh-git)
    - oh-my-posh + theme (https://github.com/JanDeDobbeleer/oh-my-posh)
        - SorinCustom
    - vscode (editor)
    - firefox (browser) + addons
      - Decentraleyes
      - NoScript
      - UBlock Origin
      - HTTPSEverywhere
      - Vimium
    - keepass (password manager)

## Enables

- Windows Subsystem for Linux (WSL)

## Disables

- LockScreen (that thing where you have to click once to remove before you can type in your password)
- Bing Search in Windows search

Protect Privacy:
    - Disables Windows Feedback Experience
    - Stops Cortana from being used as part of your Windows Search Function
    - Disables Web Search in Start Menu
    - Stops the Windows Feedback Experience from sending anonymous data
    - Prevents bloatware applications from returning and removes Start Menu suggestions
    - Disables Wi-fi Sense
    - Disables live tiles
    - Turns off Data Collection via the AllowTelemtry key by changing it to 0
    - Disabling Location Tracking
    - Disables People icon on Taskbar
    - Disables scheduled tasks that are considered unnecessary 
    - Disabling the Diagnostics Tracking Service

## Hides

- Explorer "Libraries"
  - 3DObjects
  - Music
  - Videos
  - Pictures

## Removes

- default Windows 10 apps
    - "Microsoft.3DBuilder"
    - "Microsoft.Appconnector"
    - "Microsoft.BingFinance"
    - "Microsoft.BingNews"
    - "Microsoft.BingSports"
    - "Microsoft.BingWeather"
    - "Microsoft.FreshPaint"
    - "Microsoft.MSPaint"
    - "Microsoft.Getstarted"
    - "Microsoft.MicrosoftOfficeHub"
    - "Microsoft.MicrosoftSolitaireCollection"
    - "Microsoft.MicrosoftStickyNotes"
    - "Microsoft.People"
    - "Microsoft.WindowsAlarms"
    - "Microsoft.WindowsCamera"
    - "Microsoft.WindowsMaps"
    - "Microsoft.WindowsPhone"
    - "Microsoft.WindowsSoundRecorder"
    - "Microsoft.XboxApp"
    - "Microsoft.ZuneMusic"
    - "Microsoft.ZuneVideo"
    - "microsoft.windowscommunicationsapps"
    - "Microsoft.MinecraftUWP"
    - "Microsoft.MicrosoftPowerBIForWindows"
    - "Microsoft.NetworkSpeedTest"
    - "Microsoft.GetHelp"

- Threshold 2 apps
    - "Microsoft.CommsPhone"
    - "Microsoft.ConnectivityStore"
    - "Microsoft.Messaging"
    - "Microsoft.Office.Sway"
    - "Microsoft.OneConnect"
    - "Microsoft.WindowsFeedbackHub"

- Redstone apps
    - "Microsoft.BingFoodAndDrink"
    - "Microsoft.BingTravel"
    - "Microsoft.BingHealthAndFitness"
    - "Microsoft.WindowsReadingList"

- non-Microsoft
    - "9E2F88E3.Twitter"
    - "PandoraMediaInc.29680B314EFC2"
    - "Flipboard.Flipboard"
    - "ShazamEntertainmentLtd.Shazam"
    - "king.com.CandyCrushSaga"
    - "king.com.CandyCrushSodaSaga"
    - "king.com.*"
    - "ClearChannelRadioDigital.iHeartRadio"
    - "4DF9E0F8.Netflix"
    - "6Wunderkinder.Wunderlist"
    - "Drawboard.DrawboardPDF"
    - "2FE3CB00.PicsArt-PhotoStudio"
    - "D52A8D61.FarmVille2CountryEscape"
    - "TuneIn.TuneInRadio"
    - "GAMELOFTSA.Asphalt8Airborne"
    - "TheNewYorkTimes.NYTCrossword"
    - "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    - "Facebook.Facebook"
    - "flaregamesGmbH.RoyalRevolt2"
    - "Playtika.CaesarsSlotsFreeCasino"
    - "A278AB0D.MarchofEmpires"
    - "KeeperSecurityInc.Keeper"
    - "ThumbmunkeysLtd.PhototasticCollage"
    - "XINGAG.XING"
    - "89006A2E.AutodeskSketchBook"
    - "D5EA27B7.Duolingo-LearnLanguagesforFree"
    - "46928bounde.EclipseManager"
    - "A278AB0D.DisneyMagicKingdoms"
    - "828B5831.HiddenCityMysteryofShadows"
    - "ActiproSoftwareLLC.562882FEEB491"


## Setup

1. Open a PowerShell Terminal
2. Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force`
3. Run `Unblock-File .\run-all.ps1`
4. Run `.\run-all.ps1`

All in one:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
Unblock-File .\run-all.ps1
.\run-all.ps1
```

## Updating to WSL 2

To update to WSL 2, do the following after running `.\run-all.ps1` and after rebooting:

1. Download & Install https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
2. Open Powershell as Administrator and run: `wsl --set-default-version 2`
3. Install a Linux from the MicrosoftStore and run it.