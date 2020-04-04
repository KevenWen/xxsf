#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include Functions.ahk

^NumpadDot::
        ;runwait "4399PreRongZi_phy.ahk" "2" "hou" "2" "2"    
        ;runwait "4399PreRongZi_phy.ahk" "6" "song" "1" "3"
        runwait "4399PreRongZi_phy.ahk" "4" "supper" "4" "1"        
        runwait "4399PreRongZi_phy.ahk" "1" "long" "2" "2"    
        runwait "4399PreRongZi_phy.ahk" "3" "yun" "1" "3"
return

; 3-yun, 1-long, 2-hou, 4-supper, 6-02/song	
^NumpadAdd::      ;Yun
    sleep 1000
    run "C:\ChangZhi\LDPlayer\dnconsole.exe" launchex --index 0 --packagename "com.wydsf2.ewan"    
return

^NumpadSub::
    runwait "4399Shopping_Pan.ahk" "song"
return

