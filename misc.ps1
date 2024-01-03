################################################
##### Sunshine
################################################

# References:
# https://github.com/lust4life/display-resolution

# Helper script to set resolution/frequency
New-Item -Path $env:USERPROFILE\scripts\set-display-resolution-frequency -ItemType directory

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/set-display-resolution-frequency/main.psm1" `
    -OutFile "$env:USERPROFILE\scripts\set-display-resolution-frequency\main.psm1"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/scripts/set-display-resolution-frequency/CDS.cs" `
    -OutFile "$env:USERPROFILE\scripts\set-display-resolution-frequency\CDS.cs"

# Install Sunshine and ViGEmBus
winget install -e --source winget --id ViGEm.ViGEmBus
winget install -e --source winget --id LizardByte.Sunshine

# Import Sunshine configurations
New-Item -Path "C:\Program Files\Sunshine\config" -ItemType directory -ErrorAction SilentlyContinue

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/sunshine/apps.json" `
    -OutFile "C:\Program Files\Sunshine\config\apps.json"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/gjpin/windows-11/main/configs/sunshine/sunshine.conf" `
    -OutFile "C:\Program Files\Sunshine\config\sunshine.conf"