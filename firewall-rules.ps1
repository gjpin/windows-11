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

New-NetFirewallRule -DisplayName "WSL 2" -Group "Windows Services" `
    -Program "%SYSTEMROOT%\System32\wsl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter microsoft.windowsterminal_*_x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$wingetPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "Windows Terminal" -Group "Windows Services" `
    -Program "$wingetPath\windowsterminal.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "WSL 3" -Group "Windows Services" `
    -Program "$env:ProgramFiles\WSL\wsl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "WSL - Service" -Group "Windows Services" `
    -Program "%PROGRAMFILES%\WSL\wslservice.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Microsoft Store
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter microsoft.windowsstore_*_x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$storePath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "Microsoft Store" -Group "Windows Services" `
    -Program "$storePath\winstore.app.exe" `
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

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Microsoft.Powershell_*x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$powershellPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "Powershell" -Group "User Applications" `
    -Program "$powershellPath\pwsh.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Github Desktop
$VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\GitHubDesktop" -Filter app-* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$githubPath = "$env:USERPROFILE\AppData\Local\GitHubDesktop\$VersionFolder"
New-NetFirewallRule -DisplayName "Github Desktop" -Group "User Applications" `
    -Program "$githubPath\GitHubDesktop.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Github Desktop - LFS" -Group "User Applications" `
    -Program "$githubPath\resources\app\git\mingw64\libexec\git-core\git-lfs.exe" `
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

New-NetFirewallRule -DisplayName "Visual Studio Code - Extension Manager" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code\resources\app\node_modules.asar.unpacked\@vscode\vsce-sign\bin\vsce-sign.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Golang
New-NetFirewallRule -DisplayName "Golang" -Group "User Applications" `
    -Program "%PROGRAMFILES%\go\bin\go.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Visual Studio 2022
New-NetFirewallRule -DisplayName "Visual Studio 2022 - devenv" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" `
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

New-NetFirewallRule -DisplayName "Android Studio - ADB" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Android\Sdk\platform-tools\adb.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Spotify
New-NetFirewallRule -DisplayName "Spotify" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Roaming\Spotify\Spotify.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Steam - Outbound
New-NetFirewallRule -DisplayName "Steam" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\Steam.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - Service" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Common Files\Steam\SteamService.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\bin\cef\cef.win7x64\steamwebhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Monitor" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\steamvr\bin\win64\vrmonitor.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Tours" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\steamvr\tools\steamvr_environments\game\bin\win64\steamtours.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\steamvr\bin\vrwebhelper\win64\vrwebhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# steamcmd
New-NetFirewallRule -DisplayName "Steam - steamcmd" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\steamcmd\steamcmd.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Epic Games Launcher
New-NetFirewallRule -DisplayName "Epic Games Launcher 64bit" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher 32bit" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher - Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\Engine\Binaries\Win64\EpicWebHelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher - EOS" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\epic online services\epiconlineservices.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher - EOS Overlay" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\Launcher\portal\extras\overlay\eosoverlayrenderer-win64-shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher - EOS User Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\epic online services\epiconlineservicesuserhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Epic Games Launcher - EOS Install Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Epic Games\epic online services\epiconlineservicesinstallhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Unreal Engine
New-NetFirewallRule -DisplayName "Unreal Engine 5.3 - Editor" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\UE_5.3\Engine\Binaries\Win64\UnrealEditor.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unreal Engine 5.3 - Web Helper" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\UE_5.3\Engine\Binaries\Win64\EpicWebHelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unreal Engine 5.3 - Quixel Bridge" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\UE_5.3\Engine\Plugins\Bridge\ThirdParty\Win\node-bifrost.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unreal Engine 5.3 - Prerequirements" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\UE_5.3\engine\extras\redist\en-us\ueprereqsetup_x64.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"
    
# Fortnite
New-NetFirewallRule -DisplayName "Fortnite - Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Fortnite - Client" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Fortnite - EAC" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping_EAC.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Fortnite - BattlEye" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping_BE.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Fortnite - EOS" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping_EAC_EOS.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# UEFN
New-NetFirewallRule -DisplayName "UEFN" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\UnrealEditorFortnite-Win64-Shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "UEFN - Unreal Revision control" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Fortnite\FortniteGame\Binaries\Win64\urc.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "UEFN - FAB" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\fortnite\engine\binaries\win64\epicwebhelper.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Epic Games Launcher - Lords of the Fallen
$VersionFolders = Get-ChildItem -Directory -Path "%PROGRAMFILES%\Epic Games\lordsofthefallen" -Filter *1* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$lotfPath = "%PROGRAMFILES%\Epic Games\lordsofthefallen\$VersionFolder"
New-NetFirewallRule -DisplayName "Epic Games Launcher - Lord of the Fallen 1" -Group "User Applications" `
    -Program "$lotfPath\lotf2\binaries\win64\lotf2-win64-shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "%PROGRAMFILES%\Epic Games\lordsofthefallen" -Filter *1* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$lotfPath = "%PROGRAMFILES%\Epic Games\lordsofthefallen\$VersionFolder"
New-NetFirewallRule -DisplayName "Epic Games Launcher - Lord of the Fallen 2" -Group "User Applications" `
    -Program "$lotfPath\lotf2.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "%PROGRAMFILES%\Epic Games\lordsofthefallen" -Filter *1* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$lotfPath = "%PROGRAMFILES%\Epic Games\lordsofthefallen\$VersionFolder"
New-NetFirewallRule -DisplayName "Epic Games Launcher - Lord of the Fallen 3" -Group "User Applications" `
    -Program "$lotfPath\start_protected_game.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Destiny 2
New-NetFirewallRule -DisplayName "Destiny 2" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\destiny2\destiny2.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Destiny 2 - Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\destiny2\destiny2launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Destiny 2 - Epic Overlay" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\epic games\epic online services\managedartifacts\98bc04bc842e4906993fd6d6644ffb8d\eosoverlayrenderer-win64-shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Warframe
New-NetFirewallRule -DisplayName "Warframe" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\warframe\warframe.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Warframe - Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\warframe\downloaded\tools\launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Warframe - x64 binary" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\warframe\downloaded\warframe.x64.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Joplin
New-NetFirewallRule -DisplayName "Joplin" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Joplin\Joplin.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Obsidian
New-NetFirewallRule -DisplayName "Obsidian" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Obsidian\Obsidian.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Remnant II
New-NetFirewallRule -DisplayName "Remnant II - Win64-Shipping" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Remnant2\Remnant2\Binaries\Win64\Remnant2-Win64-Shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Remnant II" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\Remnant2\Remnant2.exe" `
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

New-NetFirewallRule -DisplayName "EA app - Link2EA" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\Link2EA.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "EA app - EA Steam Proxy" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Electronic Arts\EA Desktop\EA Desktop\EASteamProxy.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - It Takes Two" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\ItTakesTwo\Nuts\Binaries\Win64\ItTakesTwo.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Apex Legends - EA
New-NetFirewallRule -DisplayName "Apex Legends" -Group "User Applications" `
    -Program "D:\eagames\Apex\r5apex.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Apex Legends - EAC launcher" -Group "User Applications" `
    -Program "D:\eagames\Apex\EasyAntiCheat_launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Steam - Apex Legends
New-NetFirewallRule -DisplayName "Steam - Apex Legends - EAC launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Apex Legends\EasyAntiCheat_launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - Apex Legends" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Apex Legends\r5apex.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# GOG
New-NetFirewallRule -DisplayName "GOG client" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\GOG Galaxy\GalaxyClient.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "GOG communication" -Group "User Applications" `
    -Program "C:\ProgramData\GOG.com\Galaxy\redists\GalaxyCommunication.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "GOG updater" -Group "User Applications" `
    -Program "C:\ProgramData\GOG.com\Galaxy\redists\GalaxyUpdater.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "GOG updater 2" -Group "User Applications" `
    -Program "C:\ProgramData\GOG.com\Galaxy\prefetch\desktop-galaxy-updater\GalaxyUpdater.exe" `
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
New-NetFirewallRule -DisplayName "Diablo Immortal" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Diablo Immortal\Engine\Binaries\Win64\DiabloImmortal.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Overwatch 2
New-NetFirewallRule -DisplayName "Overwatch 2" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Overwatch\_retail_\Overwatch.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Starcraft 2
New-NetFirewallRule -DisplayName "Starcraft 2" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\StarCraft II\Versions\Base89165\SC2_x64.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# COD Warzone
New-NetFirewallRule -DisplayName "COD Warzone" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Call of Duty\_retail_\cod.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Vermintide 2
New-NetFirewallRule -DisplayName "Vermintide 2 - Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Warhammer Vermintide 2\launcher\Launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Vermintide 2 - EAC Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Warhammer Vermintide 2\launcher\eac_launcher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Vermintide 2" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\Warhammer Vermintide 2\binaries_dx12\vermintide2_dx12.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Unity
New-NetFirewallRule -DisplayName "Unity Hub" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity Hub\Unity Hub.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unity Hub - Licensing" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity Hub\UnityLicensingClient_V1\Unity.Licensing.Client.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unity Editor - 2022.3.7f1" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity\Hub\Editor\2022.3.7f1\Editor\Unity.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Unity Editor - Package manager - 2022.3.7f1" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Unity\Hub\Editor\2022.3.7f1\Editor\Data\Resources\PackageManager\Server\UnityPackageManager.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Docker
New-NetFirewallRule -DisplayName "Docker" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Docker\Docker\resources\com.docker.backend.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Docker Desktop" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Docker\Docker\Docker Desktop.exe" `
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

New-NetFirewallRule -DisplayName "Firefox - Maintenance Service" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\mozilla maintenance service\maintenanceservice.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Chrome
New-NetFirewallRule -DisplayName "Chrome" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Google\Chrome\Application\chrome.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Chrome - Updater" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Google\Update\GoogleUpdate.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# .NET / dotnet
New-NetFirewallRule -DisplayName ".NET / dotnet" -Group "User Applications" `
    -Program "%PROGRAMFILES%\dotnet\dotnet.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Moonlight - Streaming
New-NetFirewallRule -DisplayName "Moonlight" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Moonlight Game Streaming\Moonlight.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# My Dell
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Dellinc.Mydell_*_x64__htrsf667h5kn2 -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$mydellPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "My Dell" -Group "Windows Services" `
    -Program "$mydellPath\mydell.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Dellinc.Mydell_*_x64__htrsf667h5kn2 -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$mydellPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
New-NetFirewallRule -DisplayName "My Dell - Updater" -Group "Windows Services" `
    -Program "$mydellPath\bridge\fusnbroker.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# BattlEye
New-NetFirewallRule -DisplayName "BattlEye" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Common Files\BattlEye\BEService.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Cargo by KitBash3D
New-NetFirewallRule -DisplayName "Cargo by KitBash3D" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Kitbash3D\Cargo by KitBash3D\Cargo by KitBash3D.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Cargo by KitBash3D - Downloader" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Kitbash3D\Cargo by KitBash3D\resources\downloader\CargoDownloadApp.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# HTTP Toolkit
New-NetFirewallRule -DisplayName "HTTP Toolkit" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\httptoolkit\HTTP Toolkit.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "HTTP Toolkit - Server" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\httptoolkit\resources\httptoolkit-server\bin\node.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Oh My Posh
New-NetFirewallRule -DisplayName "Oh My Posh" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Tailscale
New-NetFirewallRule -DisplayName "Tailscale - IPN" -Group "User Applications" `
    -Program "%PROGRAMFILES%\tailscale\tailscale-ipn.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Tailscale - tailscaled" -Group "User Applications" `
    -Program "%PROGRAMFILES%\tailscale\tailscaled.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# CS 2
New-NetFirewallRule -DisplayName "Counter Strike 2" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\counter-strike global offensive\game\bin\win64\cs2.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# JDK 21 - Microsoft
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Microsoft" -Filter jdk-21.*-hotspot -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$java21Path = "$env:ProgramFiles\Microsoft\$VersionFolder"
New-NetFirewallRule -DisplayName "JDK 21 - Microsoft (javaw.exe)" -Group "User Applications" `
    -Program "$java21Path\bin\javaw.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Microsoft" -Filter jdk-21.*-hotspot -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$java21Path = "$env:ProgramFiles\Microsoft\$VersionFolder"
New-NetFirewallRule -DisplayName "JDK 21 - Microsoft (java.exe)" -Group "User Applications" `
    -Program "$java21Path\bin\java.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"
    
# JDK 21 - Temurin
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Eclipse Adoptium" -Filter jdk-21.*-hotspot -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$java21Path = "$env:ProgramFiles\Eclipse Adoptium\$VersionFolder"
New-NetFirewallRule -DisplayName "JDK 21 - Eclipse Adoptium (javaw.exe)" -Group "User Applications" `
    -Program "$java21Path\bin\javaw.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Eclipse Adoptium" -Filter jdk-21.*-hotspot -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$java21Path = "$env:ProgramFiles\Eclipse Adoptium\$VersionFolder"
New-NetFirewallRule -DisplayName "JDK 21 - Eclipse Adoptium (java.exe)" -Group "User Applications" `
    -Program "$java21Path\bin\java.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# JRE 21 - Temurin
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Eclipse Adoptium" -Filter jre-21.*-hotspot -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$java21Path = "$env:ProgramFiles\Eclipse Adoptium\$VersionFolder"
New-NetFirewallRule -DisplayName "JRE 21 - Eclipse Adoptium (javaw.exe)" -Group "User Applications" `
    -Program "$java21Path\bin\javaw.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Eclipse Adoptium" -Filter jre-21.*-hotspot -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$java21Path = "$env:ProgramFiles\Eclipse Adoptium\$VersionFolder"
New-NetFirewallRule -DisplayName "JRE 21 - Eclipse Adoptium (java.exe)" -Group "User Applications" `
    -Program "$java21Path\bin\java.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Python 3.12
New-NetFirewallRule -DisplayName "Python 3.12" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\Programs\Python\Python312\python.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Brave Browser
New-NetFirewallRule -DisplayName "Brave Browser" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\bravesoftware\brave-browser\application\brave.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Oculus
New-NetFirewallRule -DisplayName "Oculus - Setup" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\OculusSetup.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Client" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-client\OculusClient.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Server" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-runtime\ovrserver_x64.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Redir" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-runtime\OVRRedir.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Service Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-runtime\OVRServiceLauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Dash" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-dash\dash\bin\OculusDash.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Platform Runtime" -Group "User Applications" `
    -Program "%PROGRAMFILES%\oculus\support\oculus-platform-runtime\oculus-platform-runtime.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Virtual Desktop
New-NetFirewallRule -DisplayName "Virtual Desktop - Streamer" -Group "User Applications" `
    -Program "%PROGRAMFILES%\virtual desktop streamer\virtualdesktop.streamer.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Virtual Desktop - Setup" -Group "User Applications" `
    -Program "%PROGRAMFILES%\virtual desktop streamer\virtualdesktop.setup.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Virtual Desktop - Updater" -Group "User Applications" `
    -Program "%PROGRAMFILES%\virtual desktop streamer\updater.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Windows Assessment and Deployment Kit (ADK)
New-NetFirewallRule -DisplayName "Windows ADK - Installer" -Group "User Applications" `
    -Program "$env:USERPROFILE\Downloads\adksetup.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# SideQuest
New-NetFirewallRule -DisplayName "SideQuest" -Group "User Applications" `
    -Program "$env:USERPROFILE\AppData\Local\programs\sidequest\sidequest.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Minecraft Legacy Launcher
New-NetFirewallRule -DisplayName "Minecraft Legacy Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\minecraft launcher\minecraftlauncher.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Deep Rock Galactic
New-NetFirewallRule -DisplayName "Deep Rock Galactic" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\deep rock galactic\fsd\binaries\win64\fsd-win64-shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Skyrim - Wabbajack
New-NetFirewallRule -DisplayName "Skyrim - Wabbajack" -Group "User Applications" `
    -Program "C:\VR\Skyrim VR\Wabbajack\Wabbajack.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Skyrim - Wabbajack 3.5.0.1" -Group "User Applications" `
    -Program "C:\VR\Skyrim VR\Wabbajack\3.5.0.1\Wabbajack.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Fanatec
New-NetFirewallRule -DisplayName "Fanatec - Control Panel" -Group "User Applications" `
    -Program "%PROGRAMFILES%\fanatec\fanatec wheel\ui\fanateccontrolpanel.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Fanatec - Fanalab" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\fanatec\fanalab\control\fanalab.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Assetto Corsa Competizione
New-NetFirewallRule -DisplayName "Assetto Corsa Competizione" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\assetto corsa competizione\ac2\binaries\win64\ac2-win64-shipping.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Dirt Rally 2.0
New-NetFirewallRule -DisplayName "Dirt Rally 2.0" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\dirt rally 2.0\dirtrally2.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Automobilista 2
New-NetFirewallRule -DisplayName "Automobilista 2" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\Automobilista 2\AMS2.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Automobilista 2 - AVX" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\Automobilista 2\AMS2AVX.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# 3DMark
New-NetFirewallRule -DisplayName "3DMark" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\3dmark\bin\x64\3dmark.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# No Man's Sky
New-NetFirewallRule -DisplayName "No Man's Sky" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\steam\steamapps\common\no man's sky\binaries\nms.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# EGS - Borderlands 3
New-NetFirewallRule -DisplayName "EGS - Borderlands 3" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Epic Games\borderlands3\oakgame\binaries\win64\borderlands3.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

################################################
##### Inbound
################################################

# Steam
New-NetFirewallRule -DisplayName "Steam - Remote Play (UDP)" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\Steam.exe" `
    -Protocol UDP -LocalPort 27031-27036 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - Remote Play (TCP)" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\Steam.exe" `
    -Protocol TCP -LocalPort 27036 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\SteamVR\bin\win32\vrstartup.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Home" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\steamtours.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Home Tools" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\steamtourscfg.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Server" -Group "User Applications" `
    -Program "%PROGRAMFILES(x86)%\Steam\steamapps\common\SteamVR\bin\win64\vrserver.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Syncthing
New-NetFirewallRule -DisplayName "Syncthing - TCP" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" `
    -Protocol TCP -LocalPort 22000 `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Syncthing - UDP" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" `
    -Protocol UDP -LocalPort 22000, 21027 `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Syncthing - TCP" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" `
    -Protocol TCP -LocalPort 22000 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Syncthing - UDP" -Group "User Applications" `
    -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" `
    -Protocol UDP -LocalPort 22000, 21027 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Sunshine
New-NetFirewallRule -DisplayName "Sunshine - TCP" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Sunshine\sunshine.exe" `
    -Protocol TCP -LocalPort 47984, 47989, 47990, 48010 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Sunshine - UDP" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Sunshine\sunshine.exe" `
    -Protocol UDP -LocalPort 47998, 47999, 48000, 48002 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Oculus
New-NetFirewallRule -DisplayName "Oculus - Client" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-client\OculusClient.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Redir" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-runtime\OVRRedir.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Server" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-runtime\OVRServer_x64.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Service Launcher" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-runtime\OVRServiceLauncher.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Dash" -Group "User Applications" `
    -Program "%PROGRAMFILES%\Oculus\Support\oculus-dash\dash\bin\OculusDash.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Virtual Desktop
New-NetFirewallRule -DisplayName "Virtual Desktop - Streamer" -Group "User Applications" `
    -Program "%PROGRAMFILES%\virtual desktop streamer\VirtualDesktop.Streamer.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

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
gpupdate /force