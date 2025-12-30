# Windows 11 setup

## How to:
0. Install Windows in unattended mode - see [unattend-generator](https://schneegans.de/windows/unattend-generator/). Upload autounattend.xml as a basis and modify settings according to your needs
   - At least "mycomputer, VK7JG-NPHTM-C97JM-9MPGT-3V66T, myuser, mypassword", location/region and wi-fi
1. Update system
2. Reboot
3. Apply setup.ps1
4. Apply firewall-rules-inbound.ps1
5. Set home network as Private
6. Reboot
7. Connect to WireGuard network
8. Set WireGuard network as Private: ```Set-NetConnectionProfile -InterfaceAlias 'wg0' -NetworkCategory 'Private'```
9. Enable HDR and Auto HDR (System -> Display -> HDR)
10. Run Windows HDR Calibration

## Console-like features
```powershell
# Wake PC with controller
powercfg /devicequery wake_programmable
powercfg /deviceenablewake "device name"

# Autologin
# https://learn.microsoft.com/en-us/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "username" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "password" /f

# Don't require password after sleep
# Settings -> Accounts -> Sign-in options -> If you've been away, when should Windows require you to sign in again? -> Never

# Disable Xbox Game Bar
# Settings -> Gaming -> Game Bar -> Alloy your controller to open Game Bar -> Off
```

## Custom resolutions (AMD Radeon)
Create custom resolutions in Adrenalin:
```
Settings -> Display -> Create new custom resolution
2560x1440
Timing Standard: CVT - Reduced Blanking
```

## Debug
- If winget is failing:
```powershell
Add-AppxPackage -Path https://cdn.winget.microsoft.com/cache/source.msix
```

## Others
### DLNA
Windows search needs to be enabled, since it's a dependency
```
; Windows Search (indexing) service
Computer
SYSTEM\CurrentControlSet\Services\WSearch
Start
DWORD:2
```

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