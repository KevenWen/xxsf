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

;Gosub, Rongzi_0  ;for testing only
shangjiday := % mod(A_YDay-117,7)=0 ? 1:0

SetTimer, Task2020, 1000  ;run every 1 secs
Return

Task2020:

    FormatTime, TimeToMeet,,HHmmss

    ;TimeToMeet = 235459

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

    new LDGame(0)
    For index,value in ["yun","song","long"]
        new 4399UserTask(value,0).PrepareRongZi(index+1)
    FileDelete % UserIni
    FileDelete % UserIniRemote   
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
    LogtoFile("Start to do verification 1...")
    For index,value in  ["song","yun","long"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value,0).RongZi(index+1)              
    }
    
    IniRead, _RZ, % UserIni,LDPlayer,RZ,0
    if _RZ < 1
        new LDGame(0).RongZi()
    LogtoFile("Verification 1 done.")    
    ;-------------------- ZhuanPan ----------------------

    new 4399UserTask("song",0).ZhuanPan(6,0)

    ;-------------------- Hunter ------------------------

    For index,value in ["song","long"]
        new 4399UserTask(value,0).Hunter(1)

    ;-------------------- GetLand -----------------------

    new LDGame(0).GetLand()
    For index,value in ["yun","song","long"]
        new 4399UserTask(value).GetLand()

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification 2...")
    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()
    else
        new LDGame()

    For index,value in  ["yun","song","long"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()
    }
    LogtoFile("Verification 2 done.")

    Sleep 120000
    LogtoFile("Start to do remote verification...")
    For index,value in  ["supper","xhhz","hou"]
    {
        IniRead, _RZ, % UserIniRemote, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value).RongZi(index)

        IniRead, _DC, % UserIniRemote, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()    
    } 
    LogtoFile("Remote verification done.")


    WinClose 360游戏大厅
Return

;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;------------------ Prepare game ---------------------
	;IniWrite, 0, % UserIni,LDPlayer,SJ
    IniWrite, 0, % UserIni,LDPlayer,DC
    FileDelete % UserIniRemote       
    Loop 600                           ;Start from 00 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }

    ;--------------------- Tasks ------------------------
    ;new LDGame(0).OpenBusSkill()
    new LDGame(0).GetLand()

    ;-------------------  Verification ------------------
    ;IniRead, _SJ, % UserIni,LDPlayer,SJ,0
    ;if _SJ < 1
    ;    new LDGame(0).OpenBusinessSkill()
    LogtoFile("Start to do verification...")
    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()
    else
        new LDGame()

    Sleep 300000
    LogtoFile("Start to do remote verification...")
    For index,value in  ["supper","yun","long","song","xhhz","sf06"]
    {
        IniRead, _DC, % UserIniRemote, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()
    } 

    LogtoFile("Verification done.")

Return

;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;-------------------- Prepare game -----------------------
    FileDelete % UserIniRemote
    FileDelete % UserIni
    FileAppend,,% UserIni
    
    new LDGame(0)
    For index,value in ["yun","song","long"]
        new 4399UserTask(value,0)

    Loop 600    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }

    ;-------------------- GetLand ---------------------
    For index,value in ["yun","song","long"]
        new 4399UserTask(value,0).Getland()

    new LDGame(0).GetLand()

    Loop 600    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet > 01
            Break
        sleep 1000
    }

    ;--------------------  RongZi -----------------------
    For index,value in ["yun","song","long"]
        new 4399UserTask(value).RongZi(index+1)
    
    new LDGame(0).RongZi()
    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")

    IniRead, _RZ, % UserIni,LDPlayer,RZ,0
    if _RZ < 1
        new LDGame(0).RongZi()
    
    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()
    else
        new LDGame()

    For index,value in  ["yun","song","long"]
    {
        IniRead, _DC, % UserIni, % value, DC,0   
        IniRead, _RZ, % UserIni, % value, RZ,0

        if _RZ < 1  
            new 4399UserTask(value).RongZi(index+1)      
        if _DC < 1
            new 4399UserTask(value).Getland()
    }

    Sleep 300000
    LogtoFile("Start to do remote verification...")
    For index,value in  ["supper","xhhz","hou"]
    {
        IniRead, _RZ, % UserIniRemote, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value).RongZi(index)

        IniRead, _DC, % UserIniRemote, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()    
    } 

    LogtoFile("Verification done.")
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
   run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
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