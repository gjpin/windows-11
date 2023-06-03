# Get latest syncthing version number
$url = 'https://github.com/syncthing/syncthing/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$response.Dispose()
$latestVersion = $realTagUrl.split('/')[-1]

# Get installed syncthing version number
$installedVersion = (& "$env:USERPROFILE\apps\syncthing\syncthing.exe" --version).Split(" ") -match "^v(\d+\.)?(\d+\.)?(\*|\d+)$"

# If versions do not match, remove current version and install latest version
if ($latestVersion -ne $installedVersion) {

    # Kill Syncthing process
    taskkill /f /im syncthing.exe

    # Download latest syncthing version
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

    # Remove installed version
    Remove-Item "$env:USERPROFILE\apps\syncthing" -Recurse

    # Extract zip
    Expand-Archive `
        -LiteralPath "$env:USERPROFILE\apps\$filename" `
        -DestinationPath "$env:USERPROFILE\apps"

    # Remove syncthing zip
    Remove-Item "$env:USERPROFILE\apps\$filename"

    # Rename syncthing folder
    Get-ChildItem "$env:USERPROFILE\apps\syncthing-windows-amd64-v*" | Rename-Item -NewName "syncthing"

    # Restart syncthing
    Start-ScheduledTask -TaskName "Syncthing"

} else {
    Exit
}