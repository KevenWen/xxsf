#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
;#NoTrayIcon				; No system tray icon
#SingleInstance force

; ==================================== Void Computer sleep =================================

SetTimer,KeepAwake,227000         ;run every 227 secs
return
 
KeepAwake:
{
     MouseMove,0,0,0,R ; mouse pointer stays in place but sends a mouse event
}
return

; ====================================== click events =======================================

global toggle := 0
F4::                        ; Press F4 then keep clicking 36 times.
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click37, 10
    } else {
        SetTImer, Timer_click37, Off
    }
return

F3::                    ; Press F3 then keep clicking 12 times, usually for get land.
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click12, 10
    } else {
        SetTImer, Timer_click12, Off
    }
return


Timer_click37:
    click    
    countN+=1
    if (countN > 39)
    {
        toggle := !toggle
        SetTImer, Timer_click37, Off
    }      
return

Timer_click12:
    click    
    countN+=1
    if (countN > 11)
    {
        toggle := !toggle
        SetTImer, Timer_click12, Off
    }      
return