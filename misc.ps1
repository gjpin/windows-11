################################################
##### Development
################################################

# Install Python 3.12
winget install -e --id Python.Python.3.12

# Install JDK Temurin 21
winget install -e --id EclipseAdoptium.Temurin.21.JDK # or Microsoft.OpenJDK.21

# Install Android Studio
winget install -e --id Google.AndroidStudio

# Add Android platform tools and emulator to path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\AppData\Local\Android\Sdk\platform-tools", "Machine")
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\AppData\Local\Android\Sdk\emulator", "Machine")

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