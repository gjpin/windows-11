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
##### Firewall
################################################

# Block all inbound connections on Public networks (no exceptions)
netsh advfirewall set public firewallpolicy blockinboundalways,allowoutbound

# Block IPs from https://github.com/crazy-max/WindowsSpyBlocker/ list
$ips = ((Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt").Content -split '\r?\n').Trim()
$ips = $ips | Where-Object {$_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"}
New-NetFirewallRule -DisplayName 'WindowsSpyBlocker' -Profile Any -Direction Outbound -Action Block -Protocol Any -LocalPort Any -RemoteAddress $ips

################################################
##### Hosts
################################################

# Add hosts file to Windows Defender exclusion list
# Will trigger UAC popup
Add-MpPreference -ExclusionPath "$env:WINDIR\system32\Drivers\etc\hosts"

# WindowsSpyBlocker (https://github.com/crazy-max/WindowsSpyBlocker/)
$hosts_ipv4 = (Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt").Content
Add-Content $env:WINDIR\system32\Drivers\etc\hosts "`n`n$hosts_ipv4"

$hosts_ipv6 = (Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy_v6.txt").Content
Add-Content $env:WINDIR\system32\Drivers\etc\hosts "`n`n$hosts_ipv6"

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
$zip.Entries | where {$_.Name -like 'LGPO.exe'} | foreach {[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$env:USERPROFILE\apps\LGPO\LGPO.exe", $true)}
$zip.Dispose()

# Remove LGPO zip
Remove-Item "$env:USERPROFILE\apps\LGPO\LGPO.zip"

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
    "Microsoft.WindowsStore"

foreach ($app in $apps)
{
  Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "$app"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}
  Get-AppxPackage $app | Remove-AppxPackage -AllUsers
}

# Uninstall OneDrive / Xbox / Cortana apps
$apps = "onedrive", "xbox", "cortana"

foreach ($app in $apps)
{
  winget uninstall $app
}

# Delete OneDrive folder
Remove-Item -Force "$env:USERPROFILE\OneDrive"

################################################
##### Setup WSL
################################################

# Enable WSL
wsl --install --inbox --web-download --no-distribution

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