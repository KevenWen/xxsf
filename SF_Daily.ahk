#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include Functions.ahk
;ResizeWindow()
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper

CoordMode, Pixel, window  
CoordMode, Mouse, window

SetTimer, Task202004, 1000  ;run every 1 secs
Return

Task202004:

    FormatTime, TimeToMeet,,HHmmss
/*  FormatTime, DayToMeet,,d

    IniRead, RongZi00, config.ini, April, RongZi00

    ;TimeToMeet = 235958

    If (TimeToMeet = 200300) ; Bussniss war started
    {        
        runwait "ShangZhanReport.ahk"
    }
*/
    If (TimeToMeet = 235458) ; Rong zi task, and also shopping / zhuanpan / openshangji
        runwait "RongZiTask.ahk" 

    /*
    ;Task for every days    
    If (TimeToMeet = 002500 ) ; Rong zi task for 01-06
    {
        runwait "4399ZhuRongZi.ahk" "ZR" "L" 
        runwait "4399TouLie.ahk" "black" "launch" "L"
        ;runwait "4399ShareTo.ahk" "II"    
    } 

    If (TimeToMeet = 063000) ; TouLie from black list
        runwait "4399TouLie.ahk" "black" "launch" "XL"     

    If (TimeToMeet = 123000) ; TouLie from black list
        runwait "4399TouLie.ahk" "black" "launch" "XL"     
   */
Return

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper, order by money count
^Numpad1::     ;02/song
    run %4399GamePath% -action:opengame -gid:1 -gaid:20
return
^Numpad2::     ;Long
    run %4399GamePath% -action:opengame -gid:1 -gaid:25 
return
^Numpad3::      ;Yun
    run %4399GamePath% -action:opengame -gid:1 -gaid:24 
return
^Numpad4::    ;88888
    run %4399GamePath% -action:opengame -gid:4 -gaid:30 
return
^Numpad5::    ;SF27_Supper
    run %4399GamePath% -action:opengame -gid:1 -gaid:27 
return

^Numpad6::     ;06
    run %4399GamePath% -action:opengame -gid:1 -gaid:35 
    ;run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
return
^Numpad0::     ;01
    run %4399GamePath% -action:opengame -gid:1 -gaid:19
return
^Numpad7::     ;03
    run %4399GamePath% -action:opengame -gid:1 -gaid:21
return
^Numpad8::     ;04
    run %4399GamePath% -action:opengame -gid:1 -gaid:22 
return
^Numpad9::     ;05
    run %4399GamePath% -action:opengame -gid:1 -gaid:23 
return
^NumpadMult::     ;SF27_Hou
    run %4399GamePath% -action:opengame -gid:1 -gaid:26 
return
^NumpadDiv::    ;xhhz
    run %4399GamePath% -action:opengame -gid:1 -gaid:18
return

F12::ExitApp ;stop the script