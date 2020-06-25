#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#include QHuserTask.ahk
/*
new 4399UserTask("long",0).Shopping("2-1").Hunter(0).ZhuZi(2).RongZi(5)
    .Getland().GetTianTi().ZhuanPan(7).ShangZhanReport().CalcRongZi()
    .PrepareRongZi(3).OpenBusinessSkill()
*/

;Gosub, Rongzi_0  ;for testing only
Menu, Tray, Icon, % A_ScriptDir . "\img\sz.ico"

SetTimer, Task2020, 1000  ;run every 1 secs
Return

Task2020:

    FormatTime, TimeToMeet,,HHmmss

    If (TimeToMeet = 235459)
    {
        if mod(A_YDay,4)=0            ;RongZi at 00:00
            Gosub, Rongzi_0
        else if mod(A_YDay,2) > 0     ;not a RongZi day
            Gosub, Rongzi_N
        else
            Gosub, Rongzi_2           ;RongZi one by one, delay 2 minutes at 00:02
        
        ExitApp
    }

return

;<========================================= Sub Tasks 0 ================================================>

Rongzi_0:

    FileDelete % UserIni
    FileAppend,,% UserIni               


    new 4399UserTask("xhhz",0)
    new 4399UserTask("song",0)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000000)
    ;-------------------- ClickRongZiOK -----------------
    new 4399UserTask("song",0).RongZi(3) 
    new 4399UserTask("xhhz",0).RongZi(4) 

    ;-------------------- ZhuanPan ----------------------
    ;new 4399UserTask("song",0).ReloadGame()    
    new 4399UserTask("song",0).ZhuanPan(2,1)
    new 4399UserTask("xhhz",0).ZhuanPan(2,1)
    ;-------------------- GetLand and hunter ------------------------

    new 4399UserTask("xhhz").GetLand()
    new 4399UserTask("song").GetLand()    
  
    GameRecordingOff()
    LogtoFile("Rongzi_0 done.")    
    WinClose 360游戏大厅
Return

;<========================================= Sub Tasks N ================================================>

Rongzi_N:
    LogtoFile("Rongzi_N done.")
    WinClose 360游戏大厅

Return

;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    LogtoFile("Rongzi_2 done.")
    WinClose 360游戏大厅
Return

;<========================================= HotKeys ================================================>

F12::ExitApp ;stop the script