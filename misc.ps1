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