
function Update-FwRules {
    # WindowsSpyBlocker
    $ips = ((Invoke-WebRequest -URI "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt").Content -split '\r?\n').Trim()
    $ips = $ips | Where-Object { $_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$" }
    Set-NetFirewallRule -DisplayName "WindowsSpyBlocker" `
        -LocalAddress Any -RemoteAddress $ips `
        -Enabled True -Action Block -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Winget
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Microsoft.DesktopAppInstaller_*x64__8wekyb3d8bbwe -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $wingetPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Winget" `
        -Program "$wingetPath\winget.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Windows Terminal
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter microsoft.windowsterminal_*_x64__8wekyb3d8bbwe -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $wingetPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Windows Terminal" `
        -Program "$wingetPath\windowsterminal.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Powershell
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Microsoft.Powershell_*x64__8wekyb3d8bbwe -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $powershellPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Powershell" `
        -Program "$powershellPath\pwsh.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # WSL
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter MicrosoftCorporationII.WindowsSubsystemForLinux_*_x64__8wekyb3d8bbwe -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $wslPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "WSL" `
        -Program "$wslPath\wsl.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Github Desktop
    $VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\GitHubDesktop" -Filter app-* -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $githubPath = "$env:USERPROFILE\AppData\Local\GitHubDesktop\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Github Desktop" `
        -Program "$githubPath\GitHubDesktop.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    Set-NetFirewallRule -DisplayName "Github Desktop - LFS" `
        -Program "$githubPath\resources\app\git\mingw64\libexec\git-core\git-lfs.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    Set-NetFirewallRule -DisplayName "Github Desktop - Remote HTTPS" `
        -Program "$githubPath\resources\app\git\mingw64\bin\git-remote-https.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    Set-NetFirewallRule -DisplayName "Github Desktop - Update" `
        -Program "$env:USERPROFILE\AppData\Local\GitHubDesktop\Update.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Insomnia
    $VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\insomnia" -Filter app-* -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $insomniaPath = "$env:USERPROFILE\AppData\Local\insomnia\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Insomnia" `
        -Program "$insomniaPath\Insomnia.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    Set-NetFirewallRule -DisplayName "Insomnia - Update" `
        -Program "$insomniaPath\Update.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Discord
    $VersionFolders = Get-ChildItem -Directory -Path "$env:USERPROFILE\AppData\Local\Discord" -Filter app-* -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $discordPath = "$env:USERPROFILE\AppData\Local\Discord\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Discord" `
        -Program "$discordPath\Discord.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Edge WebView
    $VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files (x86)\Microsoft\EdgeWebView\Application" -Filter "???.*" -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $edgewebviewPath = "C:\Program Files (x86)\Microsoft\EdgeWebView\Application\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Edge WebView" `
        -Program "$edgewebviewPath\msedgewebview2.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Unity
    $VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files\Unity\Hub\Editor" -Filter "????.*" -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $unityPath = "C:\Program Files\Unity\Hub\Editor\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Unity Editor" `
        -Program "$unityPath\Editor\Unity.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    $VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files\Unity\Hub\Editor" -Filter "????.*" -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $unityPath = "C:\Program Files\Unity\Hub\Editor\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Unity Editor - Package manager" `
        -Program "$unityPath\Editor\Data\Resources\PackageManager\Server\UnityPackageManager.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Battle.Net
    $VersionFolders = Get-ChildItem -Directory -Path "C:\ProgramData\Battle.net\Agent" -Filter "Agent.*" -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $battleNetAgentPath = "C:\ProgramData\Battle.net\Agent\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Battle.Net agent" `
        -Program "$battleNetAgentPath\Agent.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # My Dell
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Dellinc.Mydell_*_x64__htrsf667h5kn2 -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $mydellPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "My Dell" `
        -Program "$mydellPath\mydell.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter Dellinc.Mydell_*_x64__htrsf667h5kn2 -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $mydellPath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "My Dell - Updater" `
        -Program "$mydellPath\bridge\fusnbroker.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Epic Games Launcher - Lords of the Fallen
    $VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files\Epic Games\lordsofthefallen" -Filter *1* -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $lotfPath = "C:\Program Files\Epic Games\lordsofthefallen\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Epic Games Launcher - Lord of the Fallen 1" `
        -Program "$lotfPath\lotf2\binaries\win64\lotf2-win64-shipping.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    $VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files\Epic Games\lordsofthefallen" -Filter *1* -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $lotfPath = "C:\Program Files\Epic Games\lordsofthefallen\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Epic Games Launcher - Lord of the Fallen 2" `
        -Program "$lotfPath\lotf2.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    $VersionFolders = Get-ChildItem -Directory -Path "C:\Program Files\Epic Games\lordsofthefallen" -Filter *1* -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $lotfPath = "C:\Program Files\Epic Games\lordsofthefallen\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Epic Games Launcher - Lord of the Fallen 3" `
        -Program "$lotfPath\start_protected_game.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # Microsoft Store
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\WindowsApps" -Filter microsoft.windowsstore_*_x64__8wekyb3d8bbwe -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $storePath = "$env:ProgramFiles\WindowsApps\$VersionFolder"
    Set-NetFirewallRule -DisplayName "Microsoft Store" `
        -Program "$storePath\winstore.app.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # JDK 21 - Microsoft
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Microsoft" -Filter jdk-21.*-hotspot -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $java21Path = "$env:ProgramFiles\Microsoft\$VersionFolder"
    Set-NetFirewallRule -DisplayName "JDK 21 - Microsoft (javaw.exe)" `
        -Program "$java21Path\bin\javaw.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Microsoft" -Filter jdk-21.*-hotspot -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $java21Path = "$env:ProgramFiles\Microsoft\$VersionFolder"
    Set-NetFirewallRule -DisplayName "JDK 21 - Microsoft (java.exe)" `
        -Program "$java21Path\bin\java.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    # JDK 21 - Temurin
    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Eclipse Adoptium" -Filter jdk-21.*-hotspot -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $java21Path = "$env:ProgramFiles\Eclipse Adoptium\$VersionFolder"
    Set-NetFirewallRule -DisplayName "JDK 21 - Eclipse Adoptium (javaw.exe)" `
        -Program "$java21Path\bin\javaw.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    $VersionFolders = Get-ChildItem -Directory -Path "$env:ProgramFiles\Eclipse Adoptium" -Filter jdk-21.*-hotspot -Name
    $VersionFolder = $VersionFolders | Sort-Object | Select-Object -Last 1
    $java21Path = "$env:ProgramFiles\Eclipse Adoptium\$VersionFolder"
    Set-NetFirewallRule -DisplayName "JDK 21 - Eclipse Adoptium (java.exe)" `
        -Program "$java21Path\bin\java.exe" `
        -Enabled True -Action Allow -Direction Outbound -PolicyStore "$env:COMPUTERNAME"

    gpupdate /force
}