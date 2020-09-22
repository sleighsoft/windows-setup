Write-Verbose "======= Setting up WSL (restart required) =======" -Verbose

#This will self elevate the script with a UAC prompt since this script needs to be run as an Administrator in order to function properly.
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
    Read-Host "Press ENTER to continue"
    $CurrentShell = (Get-Process -Id $pid -FileVersionInfo | Select-Object -Property FileName).FileName
    Start-Process $CurrentShell -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart