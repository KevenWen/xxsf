#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include Functions.ahk


SetTimer, Task202004, 1000  ;run every 1 secs
Return

Task202004:

    FormatTime, TimeToMeet,,HHmmss

    ;TimeToMeet = 235959

    If (TimeToMeet = 235959) ; Bussniss war started
    {        
        sleep 8000
        WinClose, yun
        winclose, supper

        runwait "4399Shopping_Pan.ahk" "hou"
        runwait "4399Shopping_Pan.ahk" "long"

        WinClose, long
        winclose, hou
        ExitApp
    }

return
/*
^NumpadDot::
        ;runwait "4399PreRongZi_phy.ahk" "9" "hou" "3" "2"    
        ;runwait "4399PreRongZi_phy.ahk" "6" "song" "1" "3"
        runwait "4399PreRongZi_phy.ahk" "10" "supper" "4" "1"        
        runwait "4399PreRongZi_phy.ahk" "7" "long" "2" "2"    
        runwait "4399PreRongZi_phy.ahk" "8" "yun" "1" "3"
return

; 8-yun, 7-long, 9-hou, 10-supper, 2-02/song	
^NumpadAdd::      ;Yun
    sleep 1000
    run "C:\ChangZhi\LDPlayer\dnconsole.exe" launchex --index 0 --packagename "com.wydsf2.ewan"    
return

*/
;https://www.autohotkey.com/boards/viewtopic.php?f=7&t=41332

