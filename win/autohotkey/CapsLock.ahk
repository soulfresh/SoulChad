#Requires AutoHotkey v2.0

~*RShift::
~*LShift::
{
    if (GetKeyState("Ctrl", "P") && GetKeyState("LShift", "P") && GetKeyState("RShift", "P")) {
        SetCapsLockState(!GetKeyState("CapsLock", "T"))
        KeyWait("LShift")
        KeyWait("RShift")
    }
}