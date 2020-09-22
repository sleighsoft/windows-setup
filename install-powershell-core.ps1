# Install Powershell Core

function Install-PowershellCore {
    iex "& { $(irm https://aka.ms/install-powershell.ps1) } -Destination C:\Programs\PowerShell\"
}


function Update-PowershellCore {
    Remove-Item C:\Programs\PowerShell\ -Recurse -Force
    Install-PowershellCore
}


function Add-UpdatePowershellCoreToProfile {
    New-Item -Path $profile -ItemType "file"

    $updateCode = @'

function Update-PowershellCore {
    Remove-Item C:\Programs\PowerShell\ -Recurse -Force
    iex "& { $(irm https://aka.ms/install-powershell.ps1) } -Destination C:\Programs\PowerShell\"
}

'@

    Out-File -FilePath $profile -Append -Encoding UTF8
}

Write-Verbose "Installing Powershell Core" -Verbose
Install-PowershellCore

Write-Verbose "Adding Update-PowershellCore to $profile" -Verbose
Add-UpdatePowershellCoreToProfile