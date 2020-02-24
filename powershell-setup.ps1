# 1. Installs
#   - scoop
#     - git
#     - grep
#     - which
#     - miniconda3
#   - (Install-Module)
#     - PSReadLine (for themes)
#     - posh-git
#     - oh-my-posh
# 2. Disables LockScreen before password prompt
# 3. Disables OnScreen Keyboard

if ($PSVersionTable.PSVersion.Major -lt 6) {
  Write-Host "You need at least version 6 of powershell. Current version: $($PSVersionTable.PSVersion.Major)"
  Exit
}

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

Write-Output "Setting GIT_SSH to C:\Windows\System32\OpenSSH\ssh.exe"
[System.Environment]::SetEnvironmentVariable('GIT_SSH', 'C:\Windows\System32\OpenSSH\ssh.exe', 'USER')

try {
  Write-Output "Moving PowerShell profile to $env:USERPROFILE\Documents"
  Copy-Item Users\Documents\PowerShell $env:USERPROFILE\Documents -recurse -force
}
catch {
  Write-Output "Could not copy Users\Documents\Powershell to $env:USERPROFILE\Documents. Please manually move it"
  Start-Sleep 2
}

try {
  if (-Not (Get-Command "scoop")) {
    Write-Output "Installing scoop"
    Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
  }
}
catch { }

scoop update

if (-Not (Get-Command "git")) {
  scoop install git
}

scoop bucket add extras

if (-Not (Get-Command "grep")) {
  scoop install grep
}

if (-Not (Get-Command "which")) {
  scoop install which
}

if (-Not (Get-Command "conda")) {
  Write-Output "Installing miniconda3"
  scoop install miniconda3
}
conda init powershell

if (-Not (Get-Module -ListAvailable -Name PSReadLine)) {
  Write-Output "Installing PSReadLine"
  Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
  Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
}
if (-Not (Get-Module -ListAvailable -Name posh-git)) {
  Write-Output "Installing posh-git"
  Install-Module posh-git -Scope CurrentUser
}
if (-Not (Get-Module -ListAvailable -Name oh-my-posh)) {
  Write-Output "Installing oh-my-posh"
  Install-Module oh-my-posh -Scope CurrentUser
}

# Disable LockScreen
try {
  Write-Output "Disabling sliding LockScreen"
  Rename-Item -Path "C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy" -NewName "!Microsoft.LockApp_cw5n1h2txyewy" -Force -ErrorAction Stop
}
catch {
  Write-Output "Could not disable LockScreen. This is probably due to open handles. You can manually rename C:\Windows\SystemApps\Microsoft.LockApp_cw5n1h2txyewy"
}

Write-Output "Disabling OnScreen Keyboard"
# Disable OnScreen Keyboard
# https://www.reddit.com/r/Windows10/comments/8jbho9/windowsinternalcomposableshellexperiencestextinput/
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WindowsInternal.ComposableShell.Experiences.TextInput.InputApp.exe" /v Debugger /d "%SystemRoot%\system32\systray.exe" /f

Write-Host "Exiting in 3 seconds"
Start-Sleep 1
Write-Host "1"
Start-Sleep 1
Write-Host "2"
Start-Sleep 1
Write-Host "3"