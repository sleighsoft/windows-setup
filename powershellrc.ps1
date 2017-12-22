$ssh_keys = @(
    "~/.ssh/<private_key>"
)

function add_ssh_keys($ssh_keys) {
    foreach($key in $ssh_keys) {
        $key_fingerprint = ssh-keygen -lf $key | %{ $_.Split(' ')[1]; }
        if(ssh-add -l | findstr $key_fingerprint) {
            echo "$key already loaded into ssh-agent"
        } else {
            echo "Adding $key to ssh-agent"
            $null | ssh-add $key
        }
    }
}

add_ssh_keys $ssh_keys

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme sorincustom