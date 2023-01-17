# References:
# https://github.com/metablaster/WindowsFirewallRuleset

################################################
##### Windows services and applications
################################################

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

New-NetFirewallRule -DisplayName "Windows Kernel" -Group "Windows Services" `
    -Program "System" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Microsoft Edge" -Group "Windows Services" `
    -Program "%PROGRAMFILES(x86)%\Microsoft\Edge\Application\msedge.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Microsoft Edge - Update" -Group "Windows Services" `
    -Program "%PROGRAMFILES(x86)%\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "LSASS" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\lsass.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Microsoft.DesktopAppInstaller_*x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$wingetPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "Winget" -Group "Windows Services" `
    -Program "$wingetPath\winget.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter MicrosoftCorporationII.WindowsSubsystemForLinux_*_x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$wslPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "WSL" -Group "Windows Services" `
    -Program "$wslPath\wsl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

################################################
##### User services and applications
################################################

# Powershell
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

# Github Desktop
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

# Git
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

# VSCode
New-NetFirewallRule -DisplayName "Visual Studio Code" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code\Code.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Android Studio
New-NetFirewallRule -DisplayName "Android Studio" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Android\Android Studio\bin\studio64.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Android Studio - Java" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Android\Android Studio\jre\bin\java.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Android Studio - Emulator" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Android\Sdk\emulator\qemu\windows-x86_64\qemu-system-x86_64.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Spotify
New-NetFirewallRule -DisplayName "Spotify" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Roaming\Spotify\Spotify.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Steam - Outbound
New-NetFirewallRule -DisplayName "Steam" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\Steam.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam Service" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Common Files\Steam\SteamService.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\bin\cef\cef.win7x64\steamwebhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Epic Games Launcher
New-NetFirewallRule -DisplayName "Epic Games Launcher 64bit" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher 32bit" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Engine\Binaries\Win64\EpicWebHelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Joplin
New-NetFirewallRule -DisplayName "Joplin" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Joplin\Joplin.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Obsidian
New-NetFirewallRule -DisplayName "Obsidian" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Obsidian\Obsidian.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Nextcloud
New-NetFirewallRule -DisplayName "Nextcloud" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Nextcloud\nextcloud.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Nextcloud Web Engine" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Nextcloud\QtWebEngineProcess.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# WireGuard
New-NetFirewallRule -DisplayName "WireGuard" -Group "User Applications" `
    -Program "%PROGRAMFILES%\WireGuard\wireguard.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "WireGuard" -Group "User Applications" `
    -Program "%PROGRAMFILES%\WireGuard\wg.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Tailscale
New-NetFirewallRule -DisplayName "Tailscale" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Tailscale IPN\tailscale.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Tailscale IPN" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Tailscale IPN\tailscale-ipn.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Tailscale Daemon" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Tailscale IPN\tailscaled.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Bitwarden
New-NetFirewallRule -DisplayName "Bitwarden" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Bitwarden\Bitwarden.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Insomnia
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

# AMD Software - Adrenaline
New-NetFirewallRule -DisplayName "AMD Software - Adrenalin" -Group "User Applications" `
    -Program "%PROGRAMFILES%\AMD\CNext\CNext\RadeonSoftware.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# SteelSeries GG
New-NetFirewallRule -DisplayName "SteelSeries GG" -Group "User Applications" `
    -Program "%PROGRAMFILES%\steelseries\gg\steelseriesengine.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "SteelSeries GG - Update" -Group "User Applications" `
    -Program "%PROGRAMFILES%\steelseries\gg\steelseriesgg.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "SteelSeries GG - Engine" -Group "User Applications" `
    -Program "%PROGRAMFILES%\steelseries\gg\apps\engine\steelseriesengine.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Raspberry Pi Imager
New-NetFirewallRule -DisplayName "Raspberry Pi Imager" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Raspberry Pi Imager\rpi-imager.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Riot Client
New-NetFirewallRule -DisplayName "Riot Client" -Group "User Applications" `
    -Program "C:\Riot Games\Riot Client\RiotClientServices.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Riot Client UX" -Group "User Applications" `
    -Program "C:\Riot Games\Riot Client\UX\RiotClientUx.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# League of Legends
New-NetFirewallRule -DisplayName "League of Legends installer" -Group "User Applications" `
    -Program "$env:USERPROFILE\Downloads\Install League of Legends euw.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "League of Legends client" -Group "User Applications" `
    -Program "C:\Riot Games\League of Legends\LeagueClient.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "League of Legends client UX" -Group "User Applications" `
    -Program "C:\Riot Games\League of Legends\LeagueClientUx.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "League of Legends client UX render" -Group "User Applications" `
    -Program "C:\Riot Games\League of Legends\LeagueClientUxRender.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Valorant
New-NetFirewallRule -DisplayName "Valorant" -Group "User Applications" `
    -Program "C:\Riot Games\VALORANT\live\ShooterGame\Binaries\Win64\VALORANT-Win64-Shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Vanguard
New-NetFirewallRule -DisplayName "Vanguard" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Riot Vanguard\vgc.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Vanguard - Tray" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Riot Vanguard\vgtray.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# EA App
New-NetFirewallRule -DisplayName "EA app - Web Engine" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\QtWebEngineProcess.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "EA app - Desktop" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\EADesktop.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "EA app - Background service" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\EABackgroundService.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "EA app - Updater" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\EAUpdater.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "EA app - LocalhostSvc" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\EALocalHostSvc.exe"`
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "EA app - Launch Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\ealaunchhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Apex Legends - EA
# New-NetFirewallRule -DisplayName "Apex Legends" -Group "User Applications" `
#     -Program "D:\eagames\Apex\r5apex.exe" `
#     -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# New-NetFirewallRule -DisplayName "Apex Legends - EAC launcher" -Group "User Applications" `
#     -Program "D:\eagames\Apex\EasyAntiCheat_launcher.exe" `
#     -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Steam - Apex Legends
New-NetFirewallRule -DisplayName "Steam - Apex Legends - EAC launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Apex Legends\EasyAntiCheat_launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - Apex Legends" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Apex Legends\r5apex.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Battle.Net
New-NetFirewallRule -DisplayName "Battle.Net installer" -Group "User Applications" `
    -Program "$env:USERPROFILE\Downloads\Battle.net-Setup.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Battle.Net" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Battle.net\Battle.net.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Battle.Net launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Battle.net\Battle.net Launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Battle.Net agent" -Group "User Applications" `
    -Program "C:\ProgramData\Battle.net\Agent\Agent.8093\Agent.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Battle.Net agent 2" -Group "User Applications" `
    -Program "C:\ProgramData\Battle.net\Agent\Agent.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Diablo Immortal
# New-NetFirewallRule -DisplayName "Diablo Immortal" -Group "User Applications" `
#     -Program "D:\battle.net\Diablo Immortal\Engine\Binaries\Win64\DiabloImmortal.exe" `
#     -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Overwatch 2
# New-NetFirewallRule -DisplayName "Overwatch 2" -Group "User Applications" `
#     -Program "D:\battle.net\Overwatch\_retail_\Overwatch.exe" `
#     -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Starcraft 2
# New-NetFirewallRule -DisplayName "Starcraft 2" -Group "User Applications" `
#     -Program "D:\battle.net\StarCraft II\Versions\Base89165\SC2_x64.exe" `
#     -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# COD Warzone
# New-NetFirewallRule -DisplayName "COD Warzone" -Group "User Applications" `
#     -Program "D:\battle.net\Call of Duty\_retail_\cod.exe" `
#     -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Unity
New-NetFirewallRule -DisplayName "Unity Hub" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity Hub\Unity Hub.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unity Hub - Licensing" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity Hub\UnityLicensingClient_V1\Unity.Licensing.Client.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unity Editor" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity\Hub\Editor\2021.3.16f1\Editor\Unity.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unity Editor - Package manager" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity\Hub\Editor\2021.3.16f1\Editor\Data\Resources\PackageManager\Server\UnityPackageManager.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Docker
New-NetFirewallRule -DisplayName "Docker" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Docker\Docker\resources\com.docker.backend.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# VirtualBox
New-NetFirewallRule -DisplayName "VirtualBox" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oracle\VirtualBox\VirtualBoxVM.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Discord
$VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\Discord" -Filter app-* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$discordPath = "$env:USERPROFILE\AppData\Local\Discord\$VersionFolder"
New-NetFirewallRule -DisplayName "Discord" -Group "User Applications" `
    -Program "$discordPath\Discord.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Edge WebView
$VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files (x86)\Microsoft\EdgeWebView\Application" -Filter "???.*" -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$edgewebviewPath = "C:\Program Files (x86)\Microsoft\EdgeWebView\Application\$VersionFolder"
New-NetFirewallRule -DisplayName "Edge WebView" -Group "User Applications" `
    -Program "$edgewebviewPath\msedgewebview2.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Firefox
New-NetFirewallRule -DisplayName "Firefox" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Mozilla Firefox\firefox.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# .NET / dotnet
New-NetFirewallRule -DisplayName ".NET / dotnet" -Group "User Applications" `
    -Program "%PROGRAMFILES%\dotnet\dotnet.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Update group policy settings
gpupdate /target:Computer

################################################
##### Local services (through WireGuard and LAN)
################################################

# Core networking
New-NetFirewallRule -DisplayName "Core Networking - ICMPv4" -Group "Windows Services" `
    -Program "System" -Protocol "ICMPv4" `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Core Networking - Dynamic Host Configuration Protocol (DHCP-In)" -Group "Windows Services" `
    -Program "%SystemRoot%\system32\svchost.exe" -Service "dhcp" -Protocol "UDP" -LocalPort 68 -RemotePort 67 `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Steam - Remote Play
New-NetFirewallRule -DisplayName "Steam - Remote Play" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\Steam.exe" `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Syncthing
New-NetFirewallRule -DisplayName "Syncthing" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Syncthing" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Sunshine - Streaming
New-NetFirewallRule -DisplayName "Sunshine - Streaming" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Sunshine\sunshine.exe" `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Moonlight - Streaming
New-NetFirewallRule -DisplayName "Moonlight - Streaming" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Moonlight Game Streaming\Moonlight.exe" `
    -Profile Private -RemoteAddress 10.0.0.0/24, 10.100.100.0/24 `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Update group policy settings
gpupdate /target:Computer

################################################
##### Outro
################################################

# References:
# https://github.com/crazy-max/WindowsSpyBlocker/

# WindowsSpyBlocker
$ips = ((Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt").Content -split '\r?\n').Trim()
$ips = $ips | Where-Object { $_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$" }
New-NetFirewallRule -DisplayName "WindowsSpyBlocker" -Group "WindowsSpyBlocker" `
    -LocalAddress Any -RemoteAddress $ips `
    -Enabled True -Action Block -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Helper script to update dynamic firewall rules
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/update-firewall-rules.ps1" `
    -OutFile "$env:USERPROFILE\scripts\update-firewall-rules.ps1"

# Update group policy settings
gpupdate /target:Computer