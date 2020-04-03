#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
;#NoTrayIcon				; No system tray icon
#SingleInstance force

SetTimer,KeepAwake,227000         ;run every 4 minutes
return
 
KeepAwake:
{
     MouseMove,0,0,0,R ; mouse pointer stays in place but sends a mouse event
}
return

global toggle := 0
F9::
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click, 10
    } else {
        SetTImer, Timer_click, Off
    }
return

Timer_click:
    click    
    countN+=1
    if (countN > 36)
    {
        toggle := !toggle
        SetTImer, Timer_click, Off
    }      
return