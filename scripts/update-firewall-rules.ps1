# WindowsSpyBlocker
$ips = ((Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt").Content -split '\r?\n').Trim()
$ips = $ips | Where-Object { $_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$" }
Set-NetFirewallRule -DisplayName "WindowsSpyBlocker" `
    -LocalAddress Any -RemoteAddress $ips `
    -Enabled True -Action Block -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Winget
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Microsoft.DesktopAppInstaller_*x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$wingetPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
Set-NetFirewallRule -DisplayName "Winget" `
    -Program "$wingetPath\winget.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# WSL
$VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter MicrosoftCorporationII.WindowsSubsystemForLinux_*_x64__8wekyb3d8bbwe -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$wslPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
Set-NetFirewallRule -DisplayName "WSL" `
    -Program "$wslPath\wsl.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Github Desktop
$VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\GitHubDesktop" -Filter app-* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$githubPath = "$env:USERPROFILE\AppData\Local\GitHubDesktop\$VersionFolder"
Set-NetFirewallRule -DisplayName "Github Desktop" `
    -Program "$githubPath\GitHubDesktop.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

Set-NetFirewallRule -DisplayName "Github Desktop - Remote HTTPS" `
    -Program "$githubPath\resources\app\git\mingw64\bin\git-remote-https.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

Set-NetFirewallRule -DisplayName "Github Desktop - Update" `
    -Program "$env:USERPROFILE\AppData\Local\GitHubDesktop\Update.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

# Insomnia
$VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\insomnia" -Filter app-* -Name
$VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
$insomniaPath = "$env:USERPROFILE\AppData\Local\insomnia\$VersionFolder"
Set-NetFirewallRule -DisplayName "Insomnia" `
    -Program "$insomniaPath\Insomnia.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

Set-NetFirewallRule -DisplayName "Insomnia - Update" `
    -Program "$insomniaPath\Update.exe" `
    -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

gpupdate /target:Computer