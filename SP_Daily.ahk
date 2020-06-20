#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#include QHuserTask.ahk
#include LDGame.ahk
#include YQXGame.ahk
#include 6322Game.ahk
/*
new 4399UserTask("long",0).Shopping("2-1").Hunter(0).ZhuZi(2).RongZi(5)
    .Getland().GetTianTi().ZhuanPan(7).ShangZhanReport().CalcRongZi()
    .PrepareRongZi(3).OpenBusinessSkill()
*/

;Gosub, Rongzi_0  ;for testing only
Menu, Tray, Icon, % A_ScriptDir . "\img\phy.ico"

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
        
        UploadNetDisk()
        ExitApp
    }

return

;<========================================= Sub Tasks 0 ================================================>

Rongzi_0:

    FileDelete % UserIni
    FileAppend,,% UserIni               

    new LDGame(0)    
    new YQXGame(0)
    new 6322Game(0)
    new QHUser("steve",0)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000000)
    ;-------------------- ClickRongZiOK -----------------
    new LDGame(0).RongZi() 
    
    if mod(A_YDay-118,7) = 0
        new LDGame(0).OpenBusinessSkill()
 
    ;LDGame 5, 6322 2, DQ 3, YQX 4, steve 1
    new 6322Game(0).RongZi() 
    new YQXGame(0).RongZi()
    new QHUser("steve",0).RongZi(3)

    ;-------------------  Verification 1 -------------------
    LogtoFile("Start to do verification 1...")

    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1 and mod(A_YDay-118,7) = 0
            new LDGame(0).OpenBusinessSkill() 
    }

    IniRead, _RZ, % UserIni,LDPlayer,RZ,0
    if _RZ < 1
        new LDGame(0).RongZi()

    IniRead, _RZ, % UserIni,YQXPlayer,RZ,0
    if _RZ < 1
        new YQXGame(0).RongZi()

    IniRead, _RZ, % UserIni,6322Player,RZ,0
    if _RZ < 1
        new 6322Game(0).RongZi()

    LogtoFile("Verification 1 done.")    
    ;-------------------- ZhuanPan ----------------------
    ;new QHUser("dq",0).ReloadGame()
    ;new QHUser("dq",0).ZhuanPan(3,1)
    new 6322Game(0).ZhuanPan(2,1)
    new YQXGame(0).ZhuanPan(1)

    ;-------------------- GetLand and hunter ------------------------

    new LDGame().GetLand()
    new YQXGame().GetLand()
    new 6322Game().GetLand()
    new QHUser("steve").GetLand()
  
    GameRecordingOff()
    WinClose 360游戏大厅
Return

;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;------------------ Prepare game ---------------------
    FileDelete % UserIni
    FileAppend,,% UserIni  

    L := new LDGame(0)
    Y := new YQXGame(0)  
    N := new 6322Game(0)       
    D := new QHUser("dq",0)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000001)   ;Make sure we are start after 00:00
    ;--------------------- Tasks ------------------------
    For index,value in ["Y","N","L","D"]
        %value%.GetLand()
    WinClose dq

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()
    ;-------------------  Verification ------------------
    sleep 1000
    LogtoFile("Start to do verification...")
    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1
            new LDGame().OpenBusinessSkill()
    }

    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()
    else
       WinClose LDPlayer

    IniRead, _DC, % UserIni,YQXPlayer,DC,0
    if _DC < 1
        new YQXGame().GetLand()
    else
       WinClose YQXPlayer

    IniRead, _DC, % UserIni,6322Player,DC,0
    if _DC < 1
        new 6322Game().GetLand()
    else
       WinClose 6322Player

    GameRecordingOff()
    LogtoFile("Verification done.")

Return

;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;-------------------- Prepare game -----------------------
    FileDelete % UserIni
    FileAppend,,% UserIni
    
    L := new LDGame(0)
    Y := new YQXGame(0)  
    N := new 6322Game(0)       
    D := new QHUser("dq",0)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000001)   ;Make sure we are start after 00:00:01

    ;-------------------- Tasks ---------------------

    For index,value in ["Y","N","L","D"]
        %value%.GetLand()

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    WaitForTime(000230,0)   ;Make sure we are start after 00:02, start even if later than 02

    For index,value in ["L","Y","N","D"]
        %value%.RongZi()
    WinClose dq

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")

    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1
            L.OpenBusinessSkill()
    }
    IniRead, _RZ, % UserIni,LDPlayer,RZ,0
    if _RZ < 1
        L.RongZi()
    
    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        L.GetLand()

    WinClose LDPlayer

    IniRead, _RZ, % UserIni,YQXPlayer,RZ,0
    if _RZ < 1
        Y.RongZi()
    
    IniRead, _DC, % UserIni,YQXPlayer,DC,0
    if _DC < 1
        Y.GetLand()

    WinClose YQXPlayer

    IniRead, _RZ, % UserIni,6322Player,RZ,0
    if _RZ < 1
        N.RongZi()
    
    IniRead, _DC, % UserIni,6322Player,DC,0
    if _DC < 1
        N.GetLand()

    WinClose 6322Player

    GameRecordingOff()

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