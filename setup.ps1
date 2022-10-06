################################################
##### General
################################################

# Create user directories
New-Item -Path $env:USERPROFILE\apps -ItemType directory
New-Item -Path $env:USERPROFILE\scripts -ItemType directory
New-Item -Path $env:USERPROFILE\src -ItemType directory
New-Item -Path $env:USERPROFILE\.ssh -ItemType directory

# Disallow wake timers
powercfg /setdcvalueindex scheme_current 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
powercfg /setacvalueindex scheme_current 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0

################################################
##### Telemetry / Privacy enhancements (scheduled tasks only)
################################################

# Disable Windows Customer Experience Program (Proxy) task
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Autochk" -TaskName "Proxy"

# Disable Windows Customer Experience Program (Microsoft Compatibility Appraiser) task
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience" -TaskName "Microsoft Compatibility Appraiser"

# Disable Windows Customer Experience Program (Consolidator) task
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program" -TaskName "Consolidator"

# Disable Windows Customer Experience Program (UsbCeip) task
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program" -TaskName "UsbCeip"

# Disable Windows Error Reporting task
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Windows Error Reporting" -TaskName "QueueReporting"

################################################
##### Install LGPO
################################################

# Create LGPO folder
New-Item -Path $env:USERPROFILE\apps\LGPO -ItemType directory

# Download LGPO
Invoke-WebRequest `
    -Uri "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip" `
    -OutFile "$env:USERPROFILE\apps\LGPO\LGPO.zip"

# Extract LGPO
Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead("$env:USERPROFILE\apps\LGPO\LGPO.zip")
$zip.Entries | where { $_.Name -like 'LGPO.exe' } | foreach { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$env:USERPROFILE\apps\LGPO\LGPO.exe", $true) }
$zip.Dispose()

# Remove LGPO zip
Remove-Item "$env:USERPROFILE\apps\LGPO\LGPO.zip"

################################################
##### Remove preinstaled apps
################################################

# References:
# https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#17-preinstalled-apps

$apps = "Microsoft.BingNews", `
    "Microsoft.BingWeather", `
    "Microsoft.BingFinance", `
    "Microsoft.BingSports", `
    "9E2F88E3.Twitter", `
    "Microsoft.XboxApp", `
    "Microsoft.Office.Sway", `
    "Microsoft.Office.OneNote", `
    "Microsoft.MicrosoftOfficeHub", `
    "Microsoft.SkypeApp", `
    "Microsoft.MicrosoftStickyNotes", `
    "SpotifyAB.SpotifyMusic", `
    "Microsoft.MicrosoftSolitaireCollection", `
    "Disney.37853FC22B2CE", `
    "Clipchamp.Clipchamp", `
    "Microsoft.Getstarted", `
    "Microsoft.WindowsMaps", `
    "Microsoft.YourPhone", `
    "MicrosoftTeams", `
    "Microsoft.WindowsFeedbackHub", `
    "MicrosoftCorporationII.QuickAssist", `
    "Microsoft.WindowsCamera", `
    "Microsoft.Todos", `
    "Microsoft.ZuneMusic", `
    "Microsoft.ZuneVideo", `
    "Microsoft.PowerAutomateDesktop", `
    "Microsoft.People", `
    "Microsoft.WindowsAlarms", `
    "Microsoft.windowscommunicationsapps", `
    "Microsoft.StorePurchaseApp", `
    "Microsoft.WindowsStore", `
    "Microsoft.WindowsSoundRecorder"

foreach ($app in $apps) {
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like "$app" } | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName }
    Get-AppxPackage $app | Remove-AppxPackage -AllUsers
}

# Uninstall OneDrive / Xbox / Cortana apps
$apps = "onedrive", "xbox", "cortana"

foreach ($app in $apps) {
    winget uninstall $app
}

# Delete OneDrive folder
Remove-Item -Force "$env:USERPROFILE\OneDrive"

################################################
##### Setup WSL
################################################

# Enable WSL
wsl --install --no-distribution

# Install Ubuntu 22.04
winget install -e --source winget --id Canonical.Ubuntu.2204 --accept-source-agreements --accept-package-agreements

################################################
##### Install applications
################################################

# Applicatons with --force are only used in packages which URL is not versioned
# and the hash may not match

winget install -e --source winget --id Microsoft.PowerShell
winget install -e --source winget --id Git.Git
winget install -e --source winget --id GitHub.GitHubDesktop
winget install -e --source winget --id VideoLAN.VLC
winget install -e --source winget --id Insomnia.Insomnia
winget install -e --source winget --force --id Spotify.Spotify 
winget install -e --source winget --id DominikReichl.KeePass
winget install -e --source winget --id TheDocumentFoundation.LibreOffice
winget install -e --source winget --id Joplin.Joplin
winget install -e --source winget --id tailscale.tailscale
winget install -e --source winget --id Bitwarden.Bitwarden
winget install -e --source winget --id Nextcloud.NextcloudDesktop

# Disable startup apps
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name 'Spotify' -Value ([byte[]](0x33, 0x32, 0xFF))
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name 'Steam' -Value ([byte[]](0x33, 0x32, 0xFF))
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run -Name 'EpicGamesLauncher' -Value ([byte[]](0x33, 0x32, 0xFF))

################################################
##### VSCode
################################################

# Install VSCode
winget install -e --source winget --id Microsoft.VisualStudioCode

# Create VSCode settings directory
New-Item -Path $env:USERPROFILE\AppData\Roaming\Code\User -ItemType directory

# Import VSCode settings
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/vscode.json" `
    -OutFile "$env:USERPROFILE\AppData\Roaming\Code\User\settings.json"

# Install VSCode extensions
$credential = Get-Credential -credential "$env:USERNAME"
$commands = @'
    "& code --install-extension ms-vscode-remote.remote-wsl"
    "& code --install-extension ms-vscode.powershell"
'@
Start-Process -FilePath Powershell -LoadUserProfile -Credential $credential -ArgumentList '-Command', $commands

################################################
##### Firewall
################################################

# Block IPs from https://github.com/crazy-max/WindowsSpyBlocker/ list
$ips = ((Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt").Content -split '\r?\n').Trim()
$ips = $ips | Where-Object { $_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$" }
New-NetFirewallRule -DisplayName "WindowsSpyBlocker" -Group "WindowsSpyBlocker" `
    -LocalAddress Any -RemoteAddress $ips `
    -Enabled True -Action Block -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# References:
# https://github.com/metablaster/WindowsFirewallRuleset

# Allow Windows services and applications through firewall (outbound)
New-NetFirewallRule -DisplayName "Service Host" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\svchost.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Service Initiated Healing" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\sihclient.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Device Census" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\DeviceCensus.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Windows Defender" -Group "Windows Services" `
    -Program "%ALLUSERSPROFILE%\Microsoft\Windows Defender\Platform\MsMpEng.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Windows Defender CLI" -Group "Windows Services" `
    -Program "%ALLUSERSPROFILE%\Microsoft\Windows Defender\Platform\MpCmdRun.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Malicious Software Removal Tool" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\MRT.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Activation Client" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\slui.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "KMS Connection Broker" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\SppExtComObj.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "nslookup" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\nslookup.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "curl" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\curl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Smartscreen" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\smartscreen.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Update Session Orchestrator" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\usoclient.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "SSH" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\OpenSSH\ssh.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Windows Security Health Service" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\SecurityHealthService.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Windows UAC" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\consent.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "ICMP" -Group "Windows Services" `
    -Program "SYSTEM" `
    -Service Any -Protocol ICMPv4 `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Microsoft Edge" -Group "Windows Services" `
    -Program "%PROGRAMFILES(x86)%\Microsoft\Edge\Application\msedge.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Microsoft Edge - Update" -Group "Windows Services" `
    -Program "%PROGRAMFILES(x86)%\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Allow user applications through firewall (outbound)
## Winget
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Microsoft.DesktopAppInstaller_*x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$wingetPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "Winget" -Group "User Applications" `
    -Program "$wingetPath\winget.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Powershell
New-NetFirewallRule -DisplayName "Powershell 64bit" -Group "User Applications" `
    -Program "%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Powershell ISE 64bit" -Group "User Applications" `
    -Program "%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell_ise.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Powershell 32bit" -Group "User Applications" `
    -Program "%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Powershell ISE 32bit" -Group "User Applications" `
    -Program "%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell_ise.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Powershell Core" -Group "User Applications" `
    -Program "%PROGRAMFILES%\PowerShell\7\pwsh.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Github Desktop
$VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\GitHubDesktop" -Filter app-* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$githubPath = "$env:USERPROFILE\AppData\Local\GitHubDesktop\$VersionFolder"
New-NetFirewallRule -DisplayName "Github Desktop" -Group "User Applications" `
    -Program "$githubPath\GitHubDesktop.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Github Desktop - Remote HTTPS" -Group "User Applications" `
    -Program "$githubPath\resources\app\git\mingw64\bin\git-remote-https.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Github Desktop - Update" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\GitHubDesktop\Update.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Git
New-NetFirewallRule -DisplayName "Git - curl" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Git\mingw64\bin\curl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Git" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Git\mingw64\bin\git.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Git - Remote HTTPS" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Git\mingw64\libexec\git-core\git-remote-https.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Git - SSH" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Git\usr\bin\ssh.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## VSCode
New-NetFirewallRule -DisplayName "Visual Studio Code" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code\Code.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Spotify
New-NetFirewallRule -DisplayName "Spotify" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Roaming\Spotify\Spotify.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Steam
New-NetFirewallRule -DisplayName "Steam" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\Steam.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam Service" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Common Files\Steam\SteamService.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\bin\cef\cef.win7x64\steamwebhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Epic Games Launcher
New-NetFirewallRule -DisplayName "Epic Games Launcher 64bit" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher 32bit" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Engine\Binaries\Win64\EpicWebHelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Joplin
New-NetFirewallRule -DisplayName "Joplin" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Joplin\Joplin.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Nextcloud
New-NetFirewallRule -DisplayName "Nextcloud" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Nextcloud\nextcloud.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Nextcloud Web Engine" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Nextcloud\QtWebEngineProcess.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Tailscale
New-NetFirewallRule -DisplayName "Tailscale" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Tailscale IPN\tailscale.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Tailscale IPN" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Tailscale IPN\tailscale-ipn.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Tailscale Daemon" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Tailscale IPN\tailscaled.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Bitwarden
New-NetFirewallRule -DisplayName "Bitwarden" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Bitwarden\Bitwarden.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## Insomnia
$VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\insomnia" -Filter app-* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$insomniaPath = "$env:USERPROFILE\AppData\Local\insomnia\$VersionFolder"
New-NetFirewallRule -DisplayName "Insomnia" -Group "User Applications" `
    -Program "$insomniaPath\Insomnia.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Insomnia - Update" -Group "User Applications" `
    -Program "$insomniaPath\Update.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Insomnia - Update" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\insomnia\Update.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## AMD Software - Adrenaline
New-NetFirewallRule -DisplayName "AMD Software - Adrenalin" -Group "User Applications" `
    -Program "C:\Program Files\AMD\CNext\CNext\RadeonSoftware.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

## WSL
New-NetFirewallRule -DisplayName "WSL" -Group "User Applications" `
    -Program "%SYSTEMROOT%\System32\wsl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Update group policy settings
gpupdate /target:Computer

# Helper script to update dynamic firewall rules
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/update-firewall-rules.ps1" `
    -OutFile "$env:USERPROFILE\scripts\update-firewall-rules.ps1"

################################################
##### Apply local group policies
################################################

# References:
# https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services
# https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies
# https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-security-configuration-framework/windows-security-baselines
# https://learn.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity

# Create policies directories
New-Item -Path $env:USERPROFILE\apps\LGPO\policies -ItemType directory
New-Item -Path $env:USERPROFILE\apps\LGPO\policies\Machine -ItemType directory
New-Item -Path $env:USERPROFILE\apps\LGPO\policies\User -ItemType directory

# Download policies
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/policies/machine.txt" `
    -OutFile "$env:USERPROFILE\apps\LGPO\policies\machine.txt"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/policies/user.txt" `
    -OutFile "$env:USERPROFILE\apps\LGPO\policies\user.txt"

# Build policy files
& "$env:USERPROFILE\apps\LGPO\LGPO.exe" `
    /r "$env:USERPROFILE\apps\LGPO\policies\machine.txt" `
    /w "$env:USERPROFILE\apps\LGPO\policies\Machine\registry.pol"

& "$env:USERPROFILE\apps\LGPO\LGPO.exe" `
    /r "$env:USERPROFILE\apps\LGPO\policies\user.txt" `
    /w "$env:USERPROFILE\apps\LGPO\policies\User\registry.pol"

# Import settings from policy files
& "$env:USERPROFILE\apps\LGPO\LGPO.exe" `
    /g "$env:USERPROFILE\apps\LGPO\policies"