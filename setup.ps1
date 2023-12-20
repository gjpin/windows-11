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

# Enable auditing for "Object Access"
# https://learn.microsoft.com/en-us/windows/win32/fwp/auditing-and-logging
auditpol /set /category:"Object Access" /success:disable /failure:enable

# Install WSL
wsl --install

################################################
##### Powershell
################################################

# References:
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4
# https://learn.microsoft.com/en-us/windows/terminal/tutorials/custom-prompt-setup

# Change powershell execution policy to RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Create powershell profile file
New-Item -type file -path $profile -force
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

# Add function for firewall events
Add-Content $profile "function Get-FwEvents { Get-WinEvent -FilterHashtable @{LogName = 'Security' } -MaxEvents 50 | Where-Object -Property Message -Match `"Outbound:*`" | Select-Object -Unique -ExpandProperty Message }"

# Add function to autoupdate firewall rules
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/update-firewall-rules.ps1" `
    -OutFile "$env:USERPROFILE\scripts\update-firewall-rules.ps1"

Get-Content "$env:USERPROFILE\scripts\update-firewall-rules.ps1" | Add-Content $profile

# Install Oh My Posh
winget install -e --source winget --id JanDeDobbeleer.OhMyPosh

# Set Oh My Posh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_lean.omp.json" | Invoke-Expression

################################################
##### Nerd Fonts (CaskaydiaMono Nerd Font)
################################################

# Download latest Nerd Fonts version
$url = 'https://github.com/ryanoasis/nerd-fonts/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$response.Dispose()
$version = $realTagUrl.split('/')[-1].Trim('v')
$filename = "CascadiaMono.zip"
$downloadUrl = $realTagUrl.Replace('tag', 'download') + '/' + $filename
Invoke-WebRequest `
    -Uri "$downloadUrl" `
    -OutFile "$env:TEMP\$filename"

# Extract zip
Expand-Archive `
    -LiteralPath "$env:USERPROFILE\Downloads\$filename" `
    -DestinationPath "$env:TEMP"

# Install Nerd fonts
$FontFolder = "$env:TEMP"
$FontItem = Get-Item -Path $FontFolder
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')

foreach ($Font in $FontList) {
        Write-Host 'Installing font -' $Font.BaseName
        Copy-Item $Font "C:\Windows\Fonts"
        New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name         
}

################################################
##### Telemetry / Privacy enhancements (scheduled tasks only)
################################################

# References:
# https://github.com/ChrisTitusTech/winutil/blob/main/config/tweaks.json#L1513

# Disable scheduled tasks
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience" -TaskName "Microsoft Compatibility Appraiser"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience" -TaskName "ProgramDataUpdater"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Autochk" -TaskName "Proxy"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program" -TaskName "Consolidator"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program" -TaskName "UsbCeip"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\DiskDiagnostic" -TaskName "Microsoft-Windows-DiskDiagnosticDataCollector"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Feedback\Siuf" -TaskName "DmClient"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Feedback\Siuf" -TaskName "DmClientOnScenarioDownload"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Windows Error Reporting" -TaskName "QueueReporting"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience" -TaskName "MareBackup"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience" -TaskName "StartupAppTask"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience" -TaskName "PcaPatchDbTask"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Maps" -TaskName "MapsUpdateTask"

################################################
##### Install LGPO
################################################

# Create LGPO folder
New-Item -Path $env:USERPROFILE\lgpo -ItemType directory

# Download LGPO
Invoke-WebRequest `
    -Uri "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip" `
    -OutFile "$env:USERPROFILE\lgpo\LGPO.zip"

# Extract LGPO
Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead("$env:USERPROFILE\lgpo\LGPO.zip")
$zip.Entries | Where-Object { $_.Name -like 'LGPO.exe' } | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$env:USERPROFILE\lgpo\LGPO.exe", $true) }
$zip.Dispose()

# Remove LGPO zip
Remove-Item "$env:USERPROFILE\lgpo\LGPO.zip"

################################################
##### Update winget-cli
################################################

# Download latest stable winget-cli version
$url = 'https://github.com/microsoft/winget-cli/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$response.Dispose()
$version = $realTagUrl.split('/')[-1].Trim('v')
$filename = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$downloadUrl = $realTagUrl.Replace('tag', 'download') + '/' + $filename
Invoke-WebRequest `
    -Uri "$downloadUrl" `
    -OutFile "$env:USERPROFILE\Downloads\$filename"

# Install winget-cli
Add-AppxPackage -Path "$env:USERPROFILE\Downloads\Microsoft.DesktopAppInstaller_*.msixbundle"

# Remove bundle file
Remove-Item "$env:USERPROFILE\Downloads\$filename"

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
    "Microsoft.WindowsSoundRecorder"

foreach ($app in $apps) {
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like "$app" } | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName }
    Get-AppxPackage $app | Remove-AppxPackage -AllUsers
}

# Uninstall OneDrive / Cortana apps
$apps = "onedrive", "cortana"

foreach ($app in $apps) {
    winget uninstall $app
}

# Delete OneDrive folder
Remove-Item -Force "$env:USERPROFILE\OneDrive"

################################################
##### Install applications
################################################

# Applicatons with --force are only used in packages which URL is not versioned
# and the hash may not match

[Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', 'true', 'Machine')

winget install -e --source winget --id Microsoft.PowerShell
winget install -e --source winget --id Microsoft.VCRedist.2015+.x64
winget install -e --source winget --id Git.Git
winget install -e --source winget --id GitHub.GitHubDesktop
winget install -e --source winget --id VideoLAN.VLC
winget install -e --source winget --id Insomnia.Insomnia
winget install -e --source winget --id DominikReichl.KeePass
winget install -e --source winget --id TheDocumentFoundation.LibreOffice

winget install -e --source winget --id WireGuard.WireGuard
winget install -e --source winget --id Bitwarden.Bitwarden
winget install -e --source winget --id Discord.Discord
winget install -e --source winget --id Google.Chrome
winget install -e --source winget --id 7zip.7zip

# Install in a non-admin powershell
winget install -e --source winget --id Spotify.Spotify
winget install -e --source winget --id Obsidian.Obsidian

################################################
##### Firefox
################################################

# Install Firefox
winget install -e --source winget --id Mozilla.Firefox

##
# Open and close Firefox to create profile
##

# Get profile path
$FirefoxProfilePath = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles" -Filter "*.default-release" -Name

# Import Firefox configs to profile path
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/firefox/user.js" `
    -OutFile "$env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\$FirefoxProfilePath"

################################################
##### VSCode
################################################

# Install VSCode
winget install -e --source winget --id Microsoft.VisualStudioCode

# Create VSCode settings directory
New-Item -Path $env:USERPROFILE\AppData\Roaming\Code\User -ItemType directory

# Import VSCode settings
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/vscode/settings.json" `
    -OutFile "$env:USERPROFILE\AppData\Roaming\Code\User\settings.json"

# Install VSCode extensions
$credential = Get-Credential -credential "$env:USERNAME"
$commands = @'
    "& code --install-extension ms-vscode-remote.remote-wsl"
    "& code --install-extension ms-vscode.powershell"
'@
Start-Process -FilePath Powershell -LoadUserProfile -Credential $credential -ArgumentList '-Command', $commands

################################################
##### .NET
################################################

# References:
# https://learn.microsoft.com/en-us/dotnet/core/tools/telemetry#how-to-opt-out
# https://learn.microsoft.com/en-us/aspnet/core/security/enforcing-ssl?view=aspnetcore-7.0&tabs=visual-studio#trust-the-aspnet-core-https-development-certificate-on-windows-and-macos

# Disable .NET telemetry
[Environment]::SetEnvironmentVariable('DOTNET_CLI_TELEMETRY_OPTOUT', 'true', 'Machine')

# Install .NET SDK 8
winget install -e --source winget --id Microsoft.DotNet.SDK.8

# Trust ASP.NET Core HTTPS certificate
dotnet --info
dotnet dev-certs https --trust

################################################
##### Syncthing (installation + autostart + autoupdate)
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
Invoke-WebRequest `
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

# Download autoupdater script
Invoke-WebRequest `
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
##### Virtualization
################################################

# References:
# https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
# https://learn.microsoft.com/en-us/powershell/module/dism/enable-windowsoptionalfeature?view=windowsserver2022-ps

# Enable Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Enable Windows Hypervisor Platform
Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -NoRestart

################################################
##### Sunshine
################################################

# References:
# https://github.com/lust4life/display-resolution

# Helper script to set resolution/frequency
New-Item -Path $env:USERPROFILE\scripts\set-display-resolution-frequency -ItemType directory

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/set-display-resolution-frequency/main.psm1" `
    -OutFile "$env:USERPROFILE\scripts\set-display-resolution-frequency\main.psm1"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/set-display-resolution-frequency/CDS.cs" `
    -OutFile "$env:USERPROFILE\scripts\set-display-resolution-frequency\CDS.cs"

# Install Sunshine and ViGEmBus
winget install -e --source winget --id ViGEm.ViGEmBus
winget install -e --source winget --id LizardByte.Sunshine

# Import Sunshine configurations
New-Item -Path "C:\Program Files\Sunshine\config" -ItemType directory -ErrorAction SilentlyContinue

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/sunshine/apps.json" `
    -OutFile "C:\Program Files\Sunshine\config\apps.json"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/sunshine/sunshine.conf" `
    -OutFile "C:\Program Files\Sunshine\config\sunshine.conf"

################################################
##### Apply local group policies
################################################

# References:
# https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services
# https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies
# https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-security-configuration-framework/windows-security-baselines
# https://learn.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity

# Create a backup of the policies
New-Item -Path $env:USERPROFILE\lgpo\backup -ItemType directory
& "$env:USERPROFILE\lgpo\LGPO.exe" /b "$env:USERPROFILE\lgpo\backup"

# Create policies directories
New-Item -Path $env:USERPROFILE\lgpo\policies -ItemType directory
New-Item -Path $env:USERPROFILE\lgpo\policies\Machine -ItemType directory
New-Item -Path $env:USERPROFILE\lgpo\policies\User -ItemType directory

# Download policies
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/policies/machine.txt" `
    -OutFile "$env:USERPROFILE\lgpo\policies\machine.txt"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/policies/user.txt" `
    -OutFile "$env:USERPROFILE\lgpo\policies\user.txt"

# Build policy files
& "$env:USERPROFILE\lgpo\LGPO.exe" `
    /r "$env:USERPROFILE\lgpo\policies\machine.txt" `
    /w "$env:USERPROFILE\lgpo\policies\Machine\registry.pol"

& "$env:USERPROFILE\lgpo\LGPO.exe" `
    /r "$env:USERPROFILE\lgpo\policies\user.txt" `
    /w "$env:USERPROFILE\lgpo\policies\User\registry.pol"

# Import settings from policy files
& "$env:USERPROFILE\lgpo\LGPO.exe" `
    /g "$env:USERPROFILE\lgpo\policies"