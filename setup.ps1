################################################
##### General
################################################

# Create user directories
New-Item -Path $env:USERPROFILE\apps -ItemType directory
New-Item -Path $env:USERPROFILE\scripts -ItemType directory
New-Item -Path $env:USERPROFILE\.ssh -ItemType directory

# Upgrade packages and accept winget's msstore source agreement
winget upgrade --all --accept-source-agreements --accept-package-agreements

# Install WSL
wsl --install

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
Invoke-RestMethod `
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

# Create policies directories
New-Item -Path $env:USERPROFILE\apps\LGPO\policies -ItemType directory
New-Item -Path $env:USERPROFILE\apps\LGPO\policies\Machine -ItemType directory
New-Item -Path $env:USERPROFILE\apps\LGPO\policies\User -ItemType directory

# Download policies
Invoke-RestMethod `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/policies/machine.txt" `
    -OutFile "$env:USERPROFILE\apps\LGPO\policies\machine.txt"

Invoke-RestMethod `
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
##### Syncthing
################################################

# Download latest syncthing version
# https://copdips.com/2019/12/Using-Powershell-to-retrieve-latest-package-url-from-github-releases.html
$url = 'https://github.com/syncthing/syncthing/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$response.Dispose()
$version = $realTagUrl.split('/')[-1].Trim('v')
$filename = "syncthing-windows-amd64-v$version.zip"
$downloadUrl = $realTagUrl.Replace('tag', 'download') + '/' + $filename
Invoke-RestMethod `
    -Uri "$downloadUrl" `
    -OutFile "$env:USERPROFILE\apps\$filename"

# Extract zip
Expand-Archive `
    -LiteralPath "$env:USERPROFILE\apps\$filename" `
    -DestinationPath "$env:USERPROFILE\apps"

# Remove syncthing zip
Remove-Item "$env:USERPROFILE\apps\$filename"

# Rename syncthing folder
Get-ChildItem "$env:USERPROFILE\apps\syncthing-windows-amd64-v*" | Rename-Item -NewName "syncthing"

# Autostart syncthing
$action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\apps\syncthing\syncthing.exe" -Argument "--no-console --no-browser"
$trigger = New-ScheduledTaskTrigger -AtLogon -User "$env:USERNAME"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -ExecutionTimeLimit 0
$principal = New-ScheduledTaskPrincipal -UserID "$env:USERNAME" -LogonType S4U
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
Register-ScheduledTask -TaskName "Syncthing" -InputObject $task

# Allow syncthing through firewall (private network only)
New-NetFirewallRule -DisplayName 'Syncthing - TCP' -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" -Profile Private -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22000
New-NetFirewallRule -DisplayName 'Syncthing - UDP' -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" -Profile Private -Direction Inbound -Action Allow -Protocol UDP -LocalPort 22000,21027

# Download autoupdater script
Invoke-RestMethod `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/syncthing-autoupdater.ps1" `
    -OutFile "$env:USERPROFILE\scripts\syncthing-autoupdater.ps1"

# Add autoupdater to task scheduler
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-executionpolicy bypass -file $env:USERPROFILE\scripts\syncthing-autoupdater.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon -User "$env:USERNAME"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -ExecutionTimeLimit (New-TimeSpan -Hours 1)
$principal = New-ScheduledTaskPrincipal -UserID "$env:USERNAME" -LogonType S4U
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
Register-ScheduledTask -TaskName "Syncthing autoupdater" -InputObject $task

################################################
##### Install applications
################################################

winget install -e --id Microsoft.PowerShell
winget install -e --id Git.Git
winget install -e --id GitHub.GitHubDesktop
winget install -e --id VideoLAN.VLC
winget install -e --id Insomnia.Insomnia
winget install -e --id Spotify.Spotify
winget install -e --id DominikReichl.KeePass
winget install -e --id TheDocumentFoundation.LibreOffice
winget install -e --id tailscale.tailscale
winget install -e --id Bitwarden.Bitwarden

################################################
##### VSCode
################################################

# Install VSCode
winget install -e --id Microsoft.VisualStudioCode

# Create VSCode settings directory
New-Item -Path $env:USERPROFILE\AppData\Roaming\Code\User -ItemType directory

# Import VSCode settings
Invoke-RestMethod `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/vscode.json" `
    -OutFile "$env:USERPROFILE\AppData\Roaming\Code\User\settings.json"

# Install VSCode extensions
$credential = Get-Credential -credential "$env:USERNAME"
$commands = @'
    "& code --install-extension ms-vscode-remote.remote-wsl"
    "& code --install-extension ms-vscode.powershell"
'@
Start-Process -FilePath Powershell -LoadUserProfile -Credential $credential -ArgumentList '-Command', $commands