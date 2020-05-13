#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#include LDGame.ahk
#include YQXGame.ahk
/*
new 4399UserTask("long",0).Shopping("2-1").Hunter(0).ZhuZi(2).RongZi(5)
    .Getland().GetTianTi().ZhuanPan(7).ShangZhanReport().CalcRongZi()
    .ClickRongZiOK().PrepareRongZi(3).OpenBusinessSkill()
*/

;Gosub, Rongzi_0  ;for testing only
shangjiday := % mod(A_YDay-117,7)=0 ? 1:0
#persistent

/*
TargetTime = 1400  ; run at 2pm, which is 1400.

StringLeft, TargetDateTime, A_Now, 8  ; Put just YYYYMMDD into the variable.
TargetDateTime = %TargetDateTime%%TargetTime%
TimeUntilTarget = %TargetDateTime%
TimeUntilTarget -= %A_Now%, seconds
if TimeUntilTarget < 0
{
     [color=red]MsgBox The target time is already past![/color]
     ExitApp
}
TimeUntilTarget *= 1000 ; Convert to milliseconds.
SetTimer, Timer1, %TimeUntilTarget%
return

Timer1:
SetTimer, Timer1, off  ; i.e. perform this subroutine only once.
; In case you want to be warned before it happens, in case it changes the
; active window or otherwise disrupts what the user is working on:
SplashTexton,,, It's about to happen.
Sleep, 3000
SplashTextOff
; And here perform whatever action you wanted scheduled:
; ...
return
*/


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

    new LDGame(0)    
    new YQXGame(0)       
    For index,value in ["hou","song"]
        new 4399UserTask(value,0).PrepareRongZi(index+2)
    FileDelete % UserIni
    FileDelete % UserIniRemote   
    FileAppend,,% UserIni               

    WaitForTime(000001)   ;Make sure we are start after 00:00

    ;-------------------- ClickRongZiOK -----------------
    new LDGame(0).ClickRongZiOK()   
    new YQXGame(0).ClickRongZiOK()   
    if mod(A_YDay-118,7) = 0
        new LDGame(0).OpenBusinessSkill()
 
    For index,value in ["hou","song"]
        new 4399UserTask(value,0).ClickRongZiOK()

    ;-------------------  Verification 1 -------------------
    sleep 1000
    LogtoFile("Start to do verification 1...")

    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1 and mod(A_YDay-118,7) = 0
            new LDGame(0).OpenBusinessSkill() 
    }

    For index,value in ["hou","song"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value,0).RongZi(index+2)              
    }

    IniRead, _RZ, % UserIni,LDPlayer,RZ,0
    if _RZ < 1
        new LDGame(0).RongZi()

    IniRead, _RZ, % UserIni,YQXPlayer,RZ,0
    if _RZ < 1
        new YQXGame(0).RongZi()
    LogtoFile("Verification 1 done.")    
    ;-------------------- ZhuanPan ----------------------
    ;new 4399UserTask("hou",0).ZhuanPan(4)
    new YQXGame(0).ZhuanPan(8)
    new 4399UserTask("hou").ZhuanPan(3,0)
    new 4399UserTask("hou",0).ZhuanPan(1,1)
    ;-------------------- Hunter ------------------------

    For index,value in ["hou","song"]
        new 4399UserTask(value,0).Hunter(1)

    ;-------------------- GetLand -----------------------

    new LDGame().GetLand()
    new YQXGame().GetLand()
    
    For index,value in ["hou","song"]
        new 4399UserTask(value).GetLand()

    ;-------------------  Verification 2 ------------------
    sleep 1000
    LogtoFile("Start to do verification 2...")

    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()

    IniRead, _DC, % UserIni,YQXPlayer,DC,0
    if _DC < 1
        new YQXGame().GetLand()

    For index,value in  ["hou","song"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()
    }
    LogtoFile("Verification 2 done.")

    Sleep 180000
    LogtoFile("Start to do remote verification...")
    For index,value in  ["supper","xhhz","sf06"]
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
    FileDelete % UserIniRemote
    FileDelete % UserIni
    FileAppend,,% UserIni  

    new LDGame(0)
    new YQXGame(0)   

    WaitForTime(0000)   ;Make sure we are start after 00:00

    ;--------------------- Tasks ------------------------
    if mod(A_YDay-118,7) = 0
        new LDGame(0).OpenBusinessSkill()

    new LDGame().GetLand()
    new YQXGame().GetLand()    

    ;-------------------  Verification ------------------
    sleep 1000
    LogtoFile("Start to do verification...")
    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1
            new LDGame().OpenBusinessSkill()
    }

    IniRead, _DC, % UserIni,LDlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()

    IniRead, _DC, % UserIni,YQXPlayer,DC,0
    if _DC < 1
        new YQXGame().GetLand()

    Sleep 1200000
    LogtoFile("Start to do remote verification...")
    For index,value in  ["supper","song","xhhz","sf06"]
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
    new YQXGame(0)       
    For index,value in ["sf06","song"]
        new 4399UserTask(value,0)


    WaitForTime(000001)   ;Make sure we are start after 00:00:01

    ;-------------------- Tasks ---------------------
    if mod(A_YDay-118,7) = 0
        Ldgame.OpenBusinessSkill()

    For index,value in ["sf06","song"]
        new 4399UserTask(value,0).Getland()

    new LDGame(0).GetLand()
    new YQXGame(0).GetLand()

    WaitForTime(0002,0)   ;Make sure we are start after 00:02, start even if later than 02

     For index,value in ["sf06","song"]
        new 4399UserTask(value).RongZi(index+1)
    
    new LDGame(0).RongZi()
    new YQXGame(0).RongZi()
    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")

    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1
            new LDGame(0).OpenBusinessSkill()
    }
    IniRead, _RZ, % UserIni,LDPlayer,RZ,0
    if _RZ < 1
        new LDGame(0).RongZi()
    
    IniRead, _DC, % UserIni,LDPlayer,DC,0
    if _DC < 1
        new LDGame().GetLand()
    else
        winclose LDPlayer

    IniRead, _RZ, % UserIni,YQXPlayer,RZ,0
    if _RZ < 1
        new YQXGame(0).RongZi()
    
    IniRead, _DC, % UserIni,YQXPlayer,DC,0
    if _DC < 1
        new YQXGame().GetLand()
    else
        winclose YQXPlayer

    For index,value in  ["sf06","song"]
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