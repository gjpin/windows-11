################################################
##### Firefox
################################################

# Install Firefox
winget install -e --source winget --id Mozilla.Firefox

#
# OPEN FIREFOX
#

# Get profile path
$FirefoxProfilePath = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles" -Filter "*.default-release" -Name

# Import Firefox configs to profile path
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/firefox/user.js" `
    -OutFile "$env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\$FirefoxProfilePath"

################################################
##### Firewall
################################################

### List blocked executables by firewall
```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'} -MaxEvents 50 |Where-Object -Property Message -Match "Outbound:*" | Select-Object -Unique -ExpandProperty Message

or

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog
Get-EventLog security -newest 20 -InstanceId 5157 -Message *Destination* | format-table -wrap
```

# Add function for firewall events
Add-Content -Path $profile -Value "function Get-FwEvents { Get-WinEvent -FilterHashtable @{LogName = 'Security' } -MaxEvents 50 | Where-Object -Property Message -Match `"Outbound:*`" | Select-Object -Unique -ExpandProperty Message }"
Add-Content -Path "$env:USERPROFILE\Documents\PowerShell\Profile.ps1" -Value "function Get-FwEvents { Get-WinEvent -FilterHashtable @{LogName = 'Security' } -MaxEvents 50 | Where-Object -Property Message -Match `"Outbound:*`" | Select-Object -Unique -ExpandProperty Message }"

# Add function to autoupdate firewall rules
Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/update-firewall-rules.ps1" `
    -OutFile "$env:USERPROFILE\scripts\update-firewall-rules.ps1"

Get-Content "$env:USERPROFILE\scripts\update-firewall-rules.ps1" | Add-Content $profile
Get-Content "$env:USERPROFILE\scripts\update-firewall-rules.ps1" | Add-Content "$env:USERPROFILE\Documents\PowerShell\Profile.ps1"

################################################
##### Arch Linux WSL (manual)
################################################

## Generate newer Arch Linux images
```bash
curl -LO https://archive.archlinux.org/iso/2025.06.01/archlinux-bootstrap-x86_64.tar.zst
sudo apt install -y zstd
sudo su
zstd -d archlinux-bootstrap-x86_64.tar.zst
tar -xvf archlinux-bootstrap-x86_64.tar
tar -zcvf arch_bootstrap.tar.gz -C root.x86_64 .
# Move arch_bootstrap.tar.gz to $env:USERPROFILE\Downloads
```

1. Download Arch Linux https://github.com/gjpin/windows-11/releases/download/archlinux-2025.02.01/arch_bootstrap.tar.gz
2. Install Arch Linux in WSL
```powershell
# Install ArchLinux WSL
New-Item -Path $env:USERPROFILE\WSL\ArchLinux -ItemType directory
wsl --import ArchLinux $env:USERPROFILE\WSL\ArchLinux $env:USERPROFILE\Downloads\arch_bootstrap.tar.gz
```
3. Make sure WSL runs ArchLinux with the new user
  - Windows Terminal -> Settings -> ArchLinux -> Command line: C:\Windows\system32\wsl.exe -d ArchLinux -u wsl
4. Run in Powershell `wsl -d ArchLinux`
5. Configure Arch Linux (see wsl-arch-linux.sh)
6. Copy SSH key to /home/wsl/.ssh and set correct permissions. example:
```bash
chmod 600 /home/wsl/.ssh/id_ecdsa
chmod 644 /home/wsl/.ssh/id_ecdsa.pub
```
7. Add SSH private key to ssh-agent: `ssh-add ~/.ssh/id_ecdsa`

################################################
##### Development
################################################

# Install Python 3.12
winget install -e --id Python.Python.3.12

# AI
$credential = Get-Credential -credential "$env:USERNAME"
$commands = @'
    "& code --install-extension ms-dotnettools.csdevkit"
'@
Start-Process -FilePath Powershell -LoadUserProfile -Credential $credential -ArgumentList '-Command', $commands

# Install Ollama
winget install -e --source winget --id Ollama.Ollama

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
##### steamcmd
################################################

# References:
# https://developer.valvesoftware.com/wiki/SteamCMD#Windows

# Create steamcmd directory
New-Item -Path $env:USERPROFILE\apps\steamcmd -ItemType directory

# Download steamcmd
Invoke-WebRequest `
    -Uri "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" `
    -OutFile "$env:USERPROFILE\apps\steamcmd\steamcmd.zip"

# Extract zip
Expand-Archive `
    -LiteralPath "$env:USERPROFILE\apps\steamcmd\steamcmd.zip" `
    -DestinationPath "$env:USERPROFILE\apps\steamcmd"

# Remove steamcmd zip
Remove-Item "$env:USERPROFILE\apps\steamcmd\steamcmd.zip"

# Add steamcmd to path
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$env:USERPROFILE\apps\steamcmd",
    [EnvironmentVariableTarget]::Machine)

# Update steamcmd
& "$env:USERPROFILE\apps\steamcmd\steamcmd.exe" "+@ShutdownOnFailedCommand 1" "+quit"

################################################
##### WindowsSpyBlocker
################################################

### Add WindowsSpyBlocker hosts
```powershell
# Add hosts file to Windows Defender exclusion list
# Will trigger UAC popup
Add-MpPreference -ExclusionPath "$env:WINDIR\system32\Drivers\etc\hosts"

# WindowsSpyBlocker (https://github.com/crazy-max/WindowsSpyBlocker/)
$hosts_ipv4 = (Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt").Content
Add-Content $env:WINDIR\system32\Drivers\etc\hosts "`n`n$hosts_ipv4"

$hosts_ipv6 = (Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy_v6.txt").Content
Add-Content $env:WINDIR\system32\Drivers\etc\hosts "`n`n$hosts_ipv6"
```

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