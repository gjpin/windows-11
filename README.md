# Windows 11 setup

## Firewall
- Firewall can only be configured through Group Policy due to:
  - Disallowed globally open ports user preference merge
  - Disallowed authenticated applications user preference merge
  - Disallowed local firewall rule policy merge
  - Disallowed local IPsec policy merge
- Block inbound/outbound traffic by default
  - Exceptions are in Firewall section of the Powershell script
- Shield up mode
- Disable unicast responses to multicast and broadcast traffic
- Block outgoing connections to [WindowsSpyBlocker](https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt) IPs

## Hosts
- Add hosts file to Windows Defender exclusion list
- Add addresses from [WindowsSpyBlocker](https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt) list

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
### Syncthing (installation + autostart + autoupdate)
```powershell
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

# Allow syncthing through firewall (private network only)
New-NetFirewallRule -DisplayName 'Syncthing - TCP' -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" -Profile Private -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22000
New-NetFirewallRule -DisplayName 'Syncthing - UDP' -Program "$env:USERPROFILE\apps\syncthing\syncthing.exe" -Profile Private -Direction Inbound -Action Allow -Protocol UDP -LocalPort 22000,21027

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
