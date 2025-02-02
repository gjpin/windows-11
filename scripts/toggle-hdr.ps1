Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);
    public static void PressKeys() {
        keybd_event(0x12, 0, 0, 0); // Alt Down
        keybd_event(0x5B, 0, 0, 0); // Left Win Down
        keybd_event(0x42, 0, 0, 0); // B Down

        keybd_event(0x42, 0, 2, 0); // B Up
        keybd_event(0x5B, 0, 2, 0); // Left Win Up
        keybd_event(0x12, 0, 2, 0); // Alt Up
    }
}
"@ -PassThru | ForEach-Object { $_.GetMethod("PressKeys").Invoke($null, $null) }
