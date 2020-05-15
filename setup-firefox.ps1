Write-Verbose "======= Firefox Setup =======" -Verbose

Function Get-DownloadDirectory {
    (New-Object -ComObject Shell.Application).NameSpace("shell:Downloads").Self.Path
}


Function Download-Addons {

    $Addons = @{
        "Decentraleyes.zip" = "https://addons.mozilla.org/firefox/downloads/file/3539177/"
        "NoScript.zip" = "https://addons.mozilla.org/firefox/downloads/file/3552502/"
        "UBlock Origin.zip" = "https://addons.mozilla.org/firefox/downloads/file/3551054/"
        "HTTPSEverywhere.zip" = "https://addons.mozilla.org/firefox/downloads/file/3528100/"
        "Vimium.zip" = "https://addons.mozilla.org/firefox/downloads/file/3518684/"
    }

    $DownloadDirectory = Get-DownloadDirectory

    $WebClient = New-Object net.webclient
    $OutFiles = @()
    foreach ($Addon in $Addons.GetEnumerator()) {
        $OutFile = Join-Path -Path $DownloadDirectory -ChildPath $Addon.Name
        if (-Not (Test-Path $OutFile -PathType Leaf)) {
            Write-Verbose "Downloading $($Addon.Key)" -Verbose
            $WebClient.Downloadfile($Addon.Value, $OutFile)
        }
        $OutFiles += $OutFile
    }
    $OutFiles
}

Function Extract-AddonIds($OutFiles) {
    $DynamicAddonIds = @{
        (Join-Path -Path $(Get-DownloadDirectory) -ChildPath "Vimium.zip") = "{d7742d87-e61d-4b78-b8a1-b469842139fa}"
    }

    $Ids = @()

    Add-Type -assembly "system.io.compression.filesystem"
    $Shell = New-Object -ComObject Shell.Application
    foreach ($File in $OutFiles) {
        if ($DynamicAddonIds.ContainsKey($File)) {
            $Ids += $DynamicAddonIds[$File]
        }
        else {
            $Zip = [io.compression.zipfile]::OpenRead($File)
            $ManifestFile = $Zip.Entries | Where-Object { $_.Name -eq "manifest.json"}
            $Stream = $ManifestFile.Open()
            $Reader = New-Object IO.StreamReader($Stream)
            $Content = $Reader.ReadToEnd()
            $Reader.Close()
            $Stream.Close()
            $Zip.Dispose()

            $Json = $Content | ConvertFrom-Json

            if ($Json.PSObject.Properties.Name.Contains("applications")) {
                $Ids += $Json.applications.gecko.id
            }
            ElseIf ($Json.PSObject.Properties.Name.Contains("browser_specific_settings")) {
                $Ids += $Json.browser_specific_settings.gecko.id
            }
        }
    }
    $Ids
}


Function Rename-Addons($Files, $Ids) {
    $RenamedFiles = @()
    while ($Files) {
        $File, $Files = $Files
        $Id, $AddonIds = $AddonIds
        $NewName = "$Id.xpi"   
        Rename-Item -Path $File -NewName $NewName
        $RenamedFiles += $NewName
    }
    $RenamedFiles
}


Function Move-FilesToAddonDirectory($Files) {
    $BasePath = Join-Path -Path $env:APPDATA -ChildPath "Mozilla\Firefox\Profiles\"
    $Directories = Get-ChildItem $BasePath -directory
    $CurrentProfile = $Directories.Where({$_.Name -match "default-release$"}, "First")
    $ProfileDirectory = Join-Path -Path $BasePath -ChildPath $CurrentProfile.Name
    $ExtensionDirectory = Join-Path -Path $ProfileDirectory -ChildPath "extensions"

    Write-Verbose "Firefox Profile Directory: $ExtensionDirectory" -Verbose
    foreach ($File in $Files) {
        Write-Verbose "Installing Addon: $File" -Verbose
        Move-Item -Path $File -Destination $ExtensionDirectory
    }
}



$OutFiles = Download-Addons
$AddonIds = Extract-AddonIds $OutFiles
$RenamedFiles = Rename-Addons $OutFiles $AddonId
Move-FilesToAddonDirectory $RenamedFiles