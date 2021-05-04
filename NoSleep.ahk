#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
;#NoTrayIcon				; No system tray icon
#SingleInstance force

#Include, Functions.ahk

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
F4::                        ; Press F4 then keep clicking 42 times.
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click42, 10
    } else {
        SetTImer, Timer_click42, Off
    }
return

F3::                    ; Press F3 then keep clicking 16 times, usually for get land.
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click16, 10
    } else {
        SetTImer, Timer_click16, Off
    }
return

F2::                    ; Press F2 then keep clicking 3 times, usually for get land.
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click3, 10
    } else {
        SetTImer, Timer_click3, Off
    }
return

F1::                    ; Press F2 then keep clicking times according to the window name.
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click_specify, 10
    } else {
        SetTImer, Timer_click_specify, Off
    }
return

Timer_click42:
    click    
    countN+=1
    if (countN > 41)
    {
        toggle := !toggle
        SetTImer, Timer_click42, Off
    }      
return

Timer_click16:
    click    
    countN+=1
    if (countN > 15)
    {
        toggle := !toggle
        SetTImer, Timer_click16, Off
    }      
return

Timer_click3:
    click    
    countN+=1
    if (countN > 2)
    {
        toggle := !toggle
        SetTImer, Timer_click3, Off
    }      
return

Timer_click_specify:
    click    
    countN+=1
    num := Getzhushu()
    if (countN > num-1)
    {
        toggle := !toggle
        SetTImer, Timer_click_specify, Off
    }      
return