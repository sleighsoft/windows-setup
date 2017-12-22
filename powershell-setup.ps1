set-executionpolicy remotesigned -s cu

iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

scoop install git-with-openssh grep which sudo pshazz

Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser

Copy-Item Users\Documents\WindowsPowerShell\ $env:USERPROFILE\Documents -recurse -force

. "remove-default-apps.ps1"