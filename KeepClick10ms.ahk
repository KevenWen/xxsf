#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
;#NoTrayIcon				; No system tray icon
#SingleInstance force

toggle := 0
F9::
    toggle := !toggle
    if (toggle) {
        SetTimer, Timer_click, 100
    } else {
        SetTImer, Timer_click, Off
    }
return

Timer_click:
    click    
return