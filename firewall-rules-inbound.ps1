# References:
# https://github.com/metablaster/WindowsFirewallRuleset

# Steam
New-NetFirewallRule -DisplayName "Steam - Remote Play (UDP)" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\Steam.exe" `
    -Protocol UDP -LocalPort 27031-27036 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - Remote Play (TCP)" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\Steam.exe" `
    -Protocol TCP -LocalPort 27036 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR (32 bit)" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win32\vrstartup.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR (64 bit)" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win64\vrstartup.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Home" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\steamtours.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Home Tools" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\steamtourscfg.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Server (32 bit)" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win32\vrserver.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Steam - VR Server (64 bit)" -Group "User Applications" `
    -Program "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win64\vrserver.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Syncthing
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
    -Program "C:\Program Files\Sunshine\sunshine.exe" `
    -Protocol TCP -LocalPort 47984, 47989, 47990, 48010 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Sunshine - UDP" -Group "User Applications" `
    -Program "C:\Program Files\Sunshine\sunshine.exe" `
    -Protocol UDP -LocalPort 47998, 47999, 48000, 48002 `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Oculus
New-NetFirewallRule -DisplayName "Oculus - Client" -Group "User Applications" `
    -Program "C:\Program Files\Oculus\Support\oculus-client\OculusClient.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Redir" -Group "User Applications" `
    -Program "C:\Program Files\Oculus\Support\oculus-runtime\OVRRedir.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Server" -Group "User Applications" `
    -Program "C:\Program Files\Oculus\Support\oculus-runtime\OVRServer_x64.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Service Launcher" -Group "User Applications" `
    -Program "C:\Program Files\Oculus\Support\oculus-runtime\OVRServiceLauncher.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

New-NetFirewallRule -DisplayName "Oculus - Dash" -Group "User Applications" `
    -Program "C:\Program Files\Oculus\Support\oculus-dash\dash\bin\OculusDash.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Virtual Desktop
New-NetFirewallRule -DisplayName "Virtual Desktop - Streamer" -Group "User Applications" `
    -Program "C:\Program Files\virtual desktop streamer\VirtualDesktop.Streamer.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Podman
New-NetFirewallRule -DisplayName "Podman" -Group "User Applications" `
    -Program "C:\Program Files\redhat\podman\podman.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Tailscale
New-NetFirewallRule -DisplayName "Tailscale - Wireguard" -Group "User Applications" `
    -Program "C:\Program Files\Tailscale\tailscaled.exe" `
    -Enabled True -Action Allow -Direction Inbound -PolicyStore "$env:COMPUTERNAME"

# Update group policy settings
gpupdate /force