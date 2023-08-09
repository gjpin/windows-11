# Original: https://github.com/lust4life/display-resolution

[Flags()] enum CDSFlags {
    Dynamically = 0
    UpdateRegistry = 0x01
    Test = 0x02
    FullScreen = 0x04
    Global = 0x08
    SetPrimary = 0x10
    Reset = 0x40000000
    NoReset = 0x10000000
}

<#
.LINK
https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-changedisplaysettingsa#parameters
#>
function Set-DisplayResolutionFrequency {
    param (
        [Parameter(Mandatory = $true, Position = 0)] 
        [int] 
        $Width, 

        [Parameter(Mandatory = $true, Position = 1)] 
        [int] 
        $Height,

        [Parameter(Mandatory = $true, Position = 2)] 
        [int] 
        $Frequency,

        [CDSFlags]
        $Flag = [CDSFlags]::Dynamically
    )
    
    [cds.Helper]::ChangeDisplaySettings($width, $height, $frequency, $flag)
}

function Get-DisplayResolutionFrequency {
    [cds.Helper]::GetDisplaySettings()
}

$cds = Get-Content $PSScriptRoot/CDS.cs -Raw
Add-Type -TypeDefinition $cds