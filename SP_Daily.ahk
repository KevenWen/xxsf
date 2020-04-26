#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#include LDGame.ahk

/*
new 4399UserTask("long",0).Shopping("2-1").Hunter(0).ZhuZi(2).RongZi(5)
    .Getland().GetTianTi().ZhuanPan(7).ShangZhanReport().CalcRongZi()
    .ClickRongZiOK().PrepareRongZi(3).OpenBusSkill()
*/

IniRead, shangjiday, config.ini, April, shangjiday
IniRead, RongZi00, config.ini, April, RongZi00
IniRead, RongZi02, config.ini, April, RongZi02

SetTimer, Task202004, 1000  ;run every 1 secs
Return

Task202004:

    FormatTime, TimeToMeet,,HHmmss
    FormatTime, DayToMeet,,d

    ;TimeToMeet = 235459

    If (TimeToMeet = 235459)
    { 
        if IsItemInList(DayToMeet,RongZi00)          ;RongZi at 00:00
            Gosub, Rongzi_0
        else if IsItemInList(DayToMeet,RongZi02)     ;RongZi one by one, delay 2 minutes, at 00:02
            Gosub, Rongzi_2
        else
            Gosub, Rongzi_N                          ;not a RongZi day

        ExitApp
    }

return

;<========================================= Sub Tasks 0 ================================================>

Rongzi_0:

    ;For index,value in ["yun","song","long"]
    ;    new 4399UserTask(value,0).PrepareRongZi(index+2)
    FileDelete % UserIni
    FileAppend,,% UserIni
    Loop 600    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }
    ;-------------------- ClickRongZiOK -----------------

    new LDGame(0).ClickRongZiOK()    
    For index,value in ["song","yun","long"]
        new 4399UserTask(value,0).ClickRongZiOK()

    ;--------------------  Verification --------------------
    For index,value in  ["song","yun","long"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value,0).RongZi(index+2)              
    }
    ;-------------------- ZhuanPan ----------------------

    new 4399UserTask("song",0).ZhuanPan(3)
    new 4399UserTask("long",0).ZhuanPan(5,0)

    ;-------------------- Hunter ------------------------

    For index,value in ["song","long"]
        new 4399UserTask(value,0).Hunter(1)

    ;-------------------- GetLand -----------------------

    new LDGame().GetLand()
    For index,value in ["yun","song","long"]
        new 4399UserTask(value).GetLand()

    ;--------------------  Verification --------------------
    For index,value in  ["yun","song","long"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()
    }

    WinClose 360游戏大厅
Return

;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;------------------ Prepare game ---------------------
	IniWrite, 0, % UserIni,LDPlayer,SJ
    IniWrite, 0, % UserIni,LDPlayer,DC
    Loop 600                           ;Start from 00 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }

    ;--------------------- Tasks ------------------------
    new LDGame(0).OpenBusSkill()
    new LDGame(0).GetLand()

    ;-------------------  Verification ------------------
    IniRead, _SJ, % UserIni,LDPlayer,SJ,0
    if _SJ < 1
        new LDGame(0).OpenBusinessSkill()

    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()
    else
        new LDGame()
Return

;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;-------------------- Prepare game -----------------------
    FileDelete % UserIni
    FileAppend,,% UserIni
    For index,value in ["yun","song","long"]
        new 4399UserTask(value,0)

    Loop 600    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }

    ;-------------------- 4399 GetLand ---------------------
    For index,value in ["yun","song","long"]
        new 4399UserTask(value,0).Getland()

    Loop 600    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet > 01
            Break
        sleep 1000
    }

    ;-------------------- LDGames Tasks----------------------
    new LDGame(0).ClickRongZiOK()
    new LDGame().GetLand()

    ;-------------------- 4399 RongZi -----------------------
    For index,value in ["yun","song","long"]
        new 4399UserTask(value).RongZi(index+1)

    ;--------------------  Verification --------------------
    For index,value in  ["yun","song","long"]
    {
        IniRead, _DC, % UserIni, % value, DC,0   
        IniRead, _RZ, % UserIni, % value, RZ,0

        if _RZ < 1  
            new 4399UserTask(value,0).RongZi(index+2)      
        if _DC < 1
            new 4399UserTask(value).Getland()
    }

    WinClose 360游戏大厅
Return

;<========================================= HotKeys ================================================>
; 8-yun, 7-long, 9-hou, 10-supper, 2-02/song	

^NumpadDot::
    CaptureScreen()
return

^NumpadMult::
   For index,value in  ["song","yun","long"]
       new 4399UserTask(value,0)
return

^NumpadAdd::      ;LDPlayer
    run "C:\ChangZhi\LDPlayer\dnconsole.exe" launchex --index 0 --packagename "com.wydsf2.ewan"    
return

^Numpad1::     ;02/song
    Launch4399GamePri("song",2)
return
^Numpad2::     ;Long
    Launch4399GamePri("long",7)
return
^Numpad3::      ;Yun
    Launch4399GamePri("yun",8)
return
^Numpad4::    ;88888
    new QHUser(0)
return
^Numpad5::    ;SF27_Supper
    Launch4399GamePri("supper",10)
return

^Numpad6::     ;06
    new 4399UserTask("sf06",0)
    ;run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
return

^Numpad0::     ;01
    new 4399UserTask("sf01",0)
return
^Numpad7::     ;03
    new 4399UserTask("sf03",0)
return
^Numpad8::     ;04
    new 4399UserTask("sf04",0)
return
^Numpad9::     ;05
    new 4399UserTask("sf05",0)
return

F12::ExitApp ;stop the script