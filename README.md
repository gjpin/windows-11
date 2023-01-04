# Windows 11 setup

## How to:
1. Update system
2. Change PC name
3. Reboot
4. Apply setup.ps1
6. Apply firewall-rules.ps1
7. Reboot

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

### No connection in WSL
```bash

# Set nameserver
sudo tee /etc/resolv.conf << EOF
nameserver 1.1.1.1
EOF

sudo tee /etc/wsl.conf << EOF
[network]
generateResolvConf = false
EOF

sudo chattr +i /etc/resolv.conf
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