#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Progams\Miniconda\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

# Clear logo without -nologo
Write-Output "`n`n`n`n`n`n`n"
Clear-Host

# add_ssh_keys $ssh_keys
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme SorinCustom