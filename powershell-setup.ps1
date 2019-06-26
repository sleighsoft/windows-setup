if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Host "You need at least version 6 of powershell. Current version: $($PSVersionTable.PSVersion.Major)"
    Exit
}

set-executionpolicy remotesigned -s cu

iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

scoop install git

scoop bucket add extras

scoop update

scoop install grep which sudo miniconda

Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser

Copy-Item Users\Documents\PowerShell\ $env:USERPROFILE\Documents -recurse -force

# Disable OnScreen Keyboard
# https://www.reddit.com/r/Windows10/comments/8jbho9/windowsinternalcomposableshellexperiencestextinput/
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WindowsInternal.ComposableShell.Experiences.TextInput.InputApp.exe" /v Debugger /d "%SystemRoot%\system32\systray.exe" /f

# Disable LockScreen
Rename-Item -Path "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy" -NewName "!Microsoft.LockApp_cw5n1h2txyewy"

. "remove-default-apps.ps1"