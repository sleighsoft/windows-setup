# Install Powershell Core
Write-Verbose "Installing Powershell Core" -Verbose
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -AddToPath"