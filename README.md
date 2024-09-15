# Windows 11 setup

## How to:
1. Update system
2. Reboot
3. Apply setup.ps1
4. Apply firewall-rules.ps1
5. Change start menu folders: Settings -> Personalization -> Start -> Folders -> Settings / File Explorer
6. Set home network as Private
7. Reboot
8. Connect to Tailscale network
9. Set Tailscale network as Private: ```Set-NetConnectionProfile -InterfaceAlias 'Tailscale' -NetworkCategory 'Private'```
10. Install ArchLinux in WSL
  - After the installation, make sure WSL runs ArchLinux with the new user:
  - Windows Terminal -> Settings -> ArchLinux -> Command line: C:\Windows\system32\wsl.exe -d ArchLinux -u wsl
```powershell
# Prepare ArchLinux
# Or download from https://github.com/gjpin/windows-11/releases/download/archlinux-2024.09.01/arch_bootstrap.tar.gz
curl -LO https://archive.archlinux.org/iso/2024.09.01/archlinux-bootstrap-x86_64.tar.zst
sudo apt install -y zstd
sudo su
zstd -d archlinux-bootstrap-x86_64.tar.zst
tar -xvf archlinux-bootstrap-x86_64.tar
tar -zcvf arch_bootstrap.tar.gz -C root.x86_64 .

# Move arch_bootstrap.tar.gz to $env:USERPROFILE\Downloads

# Install ArchLinux WSL
New-Item -Path $env:USERPROFILE\WSL\ArchLinux -ItemType directory
wsl --import ArchLinux $env:USERPROFILE\WSL\ArchLinux $env:USERPROFILE\Downloads\arch_bootstrap.tar.gz

################################################
##### Configure ArchLinux
################################################
wsl -d ArchLinux

# Init and populate keyring
pacman-key --init
pacman-key --populate

# Configure mirrorlist
tee /etc/pacman.d/mirrorlist << 'EOF'
Server = https://europe.mirror.pkgbuild.com/$repo/os/$arch
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
EOF

# Update packages
pacman -Syu --noconfirm

# Install base packages
pacman -S --noconfirm base base-devel

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf
locale-gen

# Set keymap
echo "KEYMAP=us" > /etc/vconsole.conf

# Set hostname
echo archlinux > /etc/hostname

# Set /etc/hosts
tee /etc/hosts << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 archlinux.localdomain archlinux
EOF

# Install common applications
pacman -S --noconfirm \
    coreutils \
    htop \
    git \
    p7zip \
    unzip \
    unrar \
    lm_sensors \
    upower \
    nano \
    wget \
    openssh \
    fwupd \
    zstd \
    lzop \
    man-db \
    man-pages \
    e2fsprogs \
    util-linux \
    rsync \
    jq \
    yq \
    lazygit \
    ripgrep \
    fd \
    gptfdisk \
    bc \
    cpupower \
    procps-ng \
    gawk \
    fzf \
    findutils \
    net-tools

# Install ZSH and dependencies
pacman -S --noconfirm zsh

# Change root password
passwd

# Setup user
useradd -m -G wheel -s /usr/bin/zsh wsl
passwd wsl
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Create SSH directory and config file
mkdir -p /home/wsl/.ssh

chown 700 /home/wsl/.ssh

tee /home/wsl/.ssh/config << EOF
Host *
    ServerAliveInterval 60
EOF

# Create zsh configs directory
mkdir -p /home/wsl/.zshrc.d

# Configure ZSH
curl https://raw.githubusercontent.com/gjpin/arch-linux/main/configs/zsh/.zshrc -o /home/wsl/.zshrc

# Configure powerlevel10k zsh theme
curl https://raw.githubusercontent.com/gjpin/arch-linux/main/configs/zsh/.p10k.zsh -o /home/wsl/.p10k.zsh

# Make sure that all /home/wsl actually belongs to wsl
chown -R wsl:wsl /home/wsl

# Install other packages
pacman -S --noconfirm kubectl cilium talosctl k9s go nodejs npm
```

## Debug
- If winget is failing:
```powershell
Add-AppxPackage -Path https://cdn.winget.microsoft.com/cache/source.msix
```

## Firewall
- Firewall can only be configured through Group Policy due to:
  - Disallowed globally open ports user preference merge
  - Disallowed authenticated applications user preference merge
  - Disallowed local firewall rule policy merge
  - Disallowed local IPsec policy merge
- Block inbound/outbound traffic by default
  - Exceptions are in Firewall section of the Powershell script
- Shield up mode (except Private profile)
- Disable unicast responses to multicast and broadcast traffic
- Block outgoing connections to [WindowsSpyBlocker](https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt) IPs

## Restricted traffic (through local group policy)
- Apply [Windows Restricted Traffic Limited Functionality Baseline](https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services), with exceptions for security/updates
  - Exceptions are commented, in order to keep it easy to keep track of diffs

## Microsoft Edge (through local group policy)
- Enhance default security and privacy
- Disable unwanted features
- Install extensions from Chrome store

## Security
- Virtualization-based protection of code integrity
- System Guard Secure Launch

## Misc
- Disable Windows Search (indexing)
- Disallow wake timers
- Remove preinstalled apps using winget and Remove-AppxPackage
- Install applications
- Disable bing search, chat/widget icons, etc
- More changes, mostly contained in user policies file

## VSCode
- Install VSCode
- Import custom settings
- Install Powershell and Remote WSL extensions

## Others

### No connection in WSL
```bash
sudo tee /etc/wsl.conf << EOF
[boot]
systemd=true

[network]
generateResolvConf=false
EOF

sudo tee /etc/resolv.conf << EOF
nameserver 1.1.1.1
EOF

sudo chattr +i /etc/resolv.conf
```

### List blocked executables by firewall
```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'} -MaxEvents 50 |Where-Object -Property Message -Match "Outbound:*" | Select-Object -Unique -ExpandProperty Message

or

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog
Get-EventLog security -newest 20 -InstanceId 5157 -Message *Destination* | format-table -wrap
```

### Run Powershell script without changing global execution policy
```
powershell.exe -ExecutionPolicy Unrestricted -File "$env:USERPROFILE\scripts\update-firewall-rules.ps1"
```

### Android Emulator - Disable Vulkan
```powershell
# Create Android directory
New-Item -Path $env:USERPROFILE\.android -ItemType directory

# Create Android config file
New-Item -type file -path $env:USERPROFILE\.android\advancedFeatures.ini -force

Set-Content $env:USERPROFILE\.android\advancedFeatures.ini "Vulkan = off`nGLDirectMem = on"
```

### Compare registry snapshots
```powershell
cd "$env:USERPROFILE\Documents"

# take snapshot
dir -rec -erroraction ignore HKLM:\ | % name > Base-HKLM.txt
dir -rec -erroraction ignore HKCU:\ | % name > Base-HKCU.txt

# make registry change

# take new snapshot
dir -rec -erroraction ignore HKLM:\ | % name > Current-HKLM-$(get-date -f yyyy-MM-dd).txt
dir -rec -erroraction ignore HKCU:\ | % name > Current-HKCU-$(get-date -f yyyy-MM-dd).txt

# compare snapshots
```

### Disable turbo boost when running on battery
```powershell
# References:
# https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem
# https://learn.microsoft.com/en-us/windows-server/administration/performance-tuning/hardware/power/power-performance-tuning#processor-performance-boost-mode
# https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options

# Get hardware type
$HardwareType = (Get-WmiObject -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType

# If device is mobile, disable turbo boost when running on battery
if ($HardwareType -eq 2) {
    Powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTMODE 0
    Powercfg -setactive scheme_current
}
```

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

### Apply Microsoft recommended driver block rules (no longer required. enabled by default)
```powershell

# References:
# https://github.com/wdormann/applywdac
# https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/microsoft-recommended-driver-block-rules

Add-Type -AssemblyName System.IO.Compression.FileSystem
$binpolicyzip = [IO.Path]::GetTempFileName() | Rename-Item -NewName { $_ -replace 'tmp$', 'zip' } –PassThru
Invoke-WebRequest https://aka.ms/VulnerableDriverBlockList -UseBasicParsing -OutFile $binpolicyzip
$zipFile = [IO.Compression.ZipFile]::OpenRead($binpolicyzip)
$zipFile.Entries | Where-Object Name -like SiPolicy_Enforced.p7b | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$env:windir\system32\CodeIntegrity\SiPolicy.p7b", $true) }
Get-ChildItem "$env:windir\system32\CodeIntegrity\SiPolicy.p7b"
```