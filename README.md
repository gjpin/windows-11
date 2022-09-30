# Windows 11 setup

## Firewall
- Block all inbound connections on Public networks (no exceptions)
- Block IPs from [WindowsSpyBlocker](https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt) list

## Hosts
- Add hosts file to Windows Defender exclusion list
- Add addresses from [WindowsSpyBlocker](https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt) list

## Restricted traffic (through local group policy)
- Apply [Windows Restricted Traffic Limited Functionality Baseline](https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services), with exceptions for security/updates

## Microsoft Edge (through local group policy)
- Enhance default security and privacy
- Disable unwanted features
- Install extensions from Chrome store

## Misc
- Remove preinstalled apps using winget and Remove-AppxPackage
- Install applications
- Disable bing search, chat/widget icons, etc
- More changes, mostly contained in user policies file

## Syncthing
- Automated installation of Syncthing
- Autostart through tasks scheduler
- Auto update through tasks scheduler

## VSCode
- Install VSCode
- Import custom settings
- Install Powershell and Remote WSL extensions