# Install applications

Write-Verbose "======= Installing Applications =======" -Verbose

if ($PSVersionTable.PSVersion.Major -lt 6) {
  Write-Error "You need at least version 6 of powershell. Current version: $($PSVersionTable.PSVersion.Major)"
  Exit
}

Write-Verbose "Setting GIT_SSH to C:\Windows\System32\OpenSSH\ssh.exe" -Verbose
[System.Environment]::SetEnvironmentVariable('GIT_SSH', 'C:\Windows\System32\OpenSSH\ssh.exe', 'USER')

try {
  Write-Verbose "Moving PowerShell profile to $env:USERPROFILE\Documents" -Verbose
  Copy-Item Users\Documents\PowerShell $env:USERPROFILE\Documents -recurse -force
}
catch {
  Write-Verbose "Could not copy Users\Documents\Powershell to $env:USERPROFILE\Documents. Please manually move it" -Verbose
  Start-Sleep 2
}

if (-Not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
  Write-Verbose "Installing scoop" -Verbose
  Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
} else {
  Write-Verbose "scoop already installed" -Verbose
}

if (-Not (Get-Command "git" -ErrorAction SilentlyContinue)) {
  Write-Verbose "Installting git" -Verbose
  scoop install git
} else {
  Write-Verbose "git already installed" -Verbose
}

Write-Verbose "Updating scoop" -Verbose
scoop update

Write-Verbose "Adding extras to scoop buckets" -Verbose
scoop bucket add extras

if (-Not (Get-Command "conda" -ErrorAction SilentlyContinue)) {
  Write-Verbose "Installing miniconda3" -Verbose
  scoop install miniconda3
} else {
  Write-Verbose "conda already installed" -Verbose
}

Write-Verbose "Initializing conda for powershell" -Verbose
conda init powershell

Write-Verbose "Updating conda" -Verbose
conda update conda -y

if (-Not (Get-Command -Type Application "code" -ErrorAction SilentlyContinue)) {
  Write-Verbose "Installing VSCode" -Verbose
  scoop install vscode
} else {
  Write-Verbose "VSCode already installed" -Verbose
}

if (Get-Command -Type Application "code" -ErrorAction SilentlyContinue) {
  Write-Verbose "Installing VSCode extensions" -Verbose
  code --install-extension afgomez.better-cobalt
  code --install-extension hbenl.vscode-test-explorer
  code --install-extension littlefoxteam.vscode-python-test-adapter
  code --install-extension ms-python.python
  code --install-extension njpwerner.autodocstring
  code --install-extension tomoki1207.selectline-statusbar
  code --install-extension VisualStudioExptTeam.vscodeintellicode
  code --install-extension bungcip.better-toml
  code --install-extension yzhang.markdown-all-in-one
}

if (-Not (Get-Command -Type Application "firefox" -ErrorAction SilentlyContinue)) {
  Write-Verbose "Installing Firefox" -Verbose
  scoop install firefox
} else {
  Write-Verbose "Firefox already installed" -Verbose
}

Write-Verbose "Installing KeePass" -Verbose
scoop install keepass

if (-Not (Get-Module -ListAvailable -Name posh-git)) {
  Write-Verbose "Installing posh-git" -Verbose
  Install-Module posh-git -Scope CurrentUser -Force
}

if (-Not (Get-Module -ListAvailable -Name oh-my-posh)) {
  Write-Verbose "Installing oh-my-posh" -Verbose
  Install-Module oh-my-posh -Scope CurrentUser -Force
}

Read-Host "Press ENTER to exit"