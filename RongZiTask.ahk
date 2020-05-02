#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include 4399UserTask.ahk
#include QHuserTask.ahk
#include RDPGame.ahk
;#include Socket.ahk

; Phy 肉沫茄子-5; supper-4; hou-2; long-3;
; phy2 yun-1; xxsf/8888-5; 
; home  02/song-2; xhhz-4;

CoordMode, Pixel, window  
CoordMode, Mouse, window
/*
myTcp := new SocketTCP()
myTcp.connect(["10.154.10.6", 1377])
myTcp.sendText("long")
response := StrSplit(myTcp.recvText(2048), ",")
MsgBox, % response[1]
MsgBox, % response[2]
MsgBox, % response[3]
myTcp.disconnect()
*/

shangjiday := % mod(A_YDay-117,7)=0 ? 1:0 
if mod(A_YDay,4)=0            ;RongZi at 00:00
    Gosub, Rongzi_0
else if mod(A_YDay,2) > 0     ;not a RongZi day
    Gosub, Rongzi_N
else
    Gosub, Rongzi_2           ;RongZi one by one, delay 2 minutes at 00:02

UploadNetDisk()
ExitApp

;<===================The sub tasks==========================>

;<========================================= Sub Tasks 0 ================================================>


Rongzi_0:

    FileDelete % UserIni
    FileAppend,,% UserIni

    For index,value in  ["supper","hou","xhhz"]
        new 4399UserTask(value,0).PrepareRongZi(index)

    new QHUser(0).PrepareRongZi(4)

    Loop 600    ;Make sure we are start after 00:00, total 10 mins
        {
            FormatTime, MinToMeet,,mm
            if MinToMeet = 00
                Break
            sleep 1000
        }

    ;-------------------- ClickRongZiOK --------------------
    new QHUser(0).ClickRongZiOK()
    For index,value in  ["supper","xhhz","hou"]
        new 4399UserTask(value,0).ClickRongZiOK()

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification 1...")
    For index,value in  ["supper","hou","xhhz","xxsf"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0        
        if _RZ < 1
        {
           if value = xxsf
               new QHUser().RongZi(4)
            else 
               new 4399UserTask(value,0).RongZi(index)              
        }
    }
    LogtoFile("Verification 1 done.")
    iniFileSync()        
    WinClose,xxsf
    WinClose,supper
    WinClose,hou

    ;---------------------- ZhuanPan -----------------------
    new 4399UserTask("hou",0).ZhuanPan(4)

    ;----------------------- Hunter ------------------------
    For index,value in  ["hou","xhhz"]
        new 4399UserTask(value,0).Hunter(1)

    ;---------------------- Getland ------------------------

    For index,value in  ["xhhz","hou","supper"]
       new 4399UserTask(value).Getland()
    new QHUser().Getland()
    
    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification 2...")
    For index,value in  ["supper","hou","xhhz","xxsf"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
        {
           if value = xxsf
               new QHUser().Getland()
            else 
               new 4399UserTask(value).Getland()              
        }
    }
    LogtoFile("Verification 2 done.")
    
    iniFileSync()
    LogtoFile("Start to do remote verification...")
    For index,value in  ["long","song","yun"]
    {
        IniRead, _RZ, % UserIniRemote, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value).RongZi(index+2)

        IniRead, _DC, % UserIniRemote, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()    
    } 
    LogtoFile("Remote verification done.")

    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;---------------------- Prepare ------------------------
    For index,value in  ["supper","yun","long","xhhz","song","xxsf","sf06"]
		IniWrite, 0, % UserIni, %value%,DC

    new QHUser(0)
    For index,value in  ["supper","yun","long"]
       new 4399UserTask(value,0)

    Loop 600    ;Make sure we are start after 00:00, total 10 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }

    ;---------------------- Tasks ------------------------
    new QHUser().Getland()
    For index,value in  ["supper","yun","long","xhhz","song","sf06"]
       new 4399UserTask(value).Getland()

    ;new 4399UserTask("supper",0).OpenBusSkill()
    ;new 4399UserTask("supper").ZhuanPan(3,0)

   ;------------------- Verification ---------------------
    LogtoFile("Start to do verification...")
    For index,value in  ["supper","yun","long","xhhz","song","xxsf","sf06"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
        {
           if value = xxsf
               new QHUser().Getland()
            else 
               new 4399UserTask(value).Getland()              
        }
    }

    iniFileSync()
    LogtoFile("Verification done.")    
    ;---------------------- Hunter ------------------------

    For index,value in ["xhhz","long","song","sf06"]
        new 4399UserTask(value).Hunter(1)

    WinClose 360游戏大厅
    ;if shangjiday
    ;    supper.OpenBusSkill()
Return
;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;---------------------- Prepare ------------------------
    FileDelete % UserIni
    FileAppend,,% UserIni

    new QHUser(0)
    For index,value in  ["supper","xhhz","hou"]
            new 4399UserTask(value,0)

    Loop 600    ;Make sure we are start at 00 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 1000
    }
    sleep 1000
   ;---------------------- Getland ------------------------

   new QHUser(0).Getland()
   For index,value in  ["supper","xhhz","hou"]
        new 4399UserTask(value,0).GetLand()

   ;---------------------- Waiting ------------------------

    Loop 600    ;Make sure we are start RongZi delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet > 01
            Break
        sleep 1000
    }

   ;---------------------- RongZi ------------------------

    For index,value in  ["supper","xhhz","hou"]
        new 4399UserTask(value).RongZi(index) 

    new QHUser().RongZi(4)

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")
    For index,value in  ["supper","hou","xhhz","xxsf"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0
        IniRead, _DC, % UserIni, % value, DC,0              
        if _RZ < 1
        {
           if value = xxsf
               new QHUser().RongZi(4)
            else 
               new 4399UserTask(value).RongZi(index)              
        }   
        if _DC < 1
        {
           if value = xxsf
               new QHUser().Getland()
            else 
               new 4399UserTask(value).Getland()              
        }
    }
    LogtoFile("Verification done.")
    
    iniFileSync()
    LogtoFile("Start to do remote verification...")
    For index,value in  ["long","song","yun"]
    {
        IniRead, _RZ, % UserIniRemote, % value, RZ,0        
        if _RZ < 1  
            new 4399UserTask(value).RongZi(index+2)

        IniRead, _DC, % UserIniRemote, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()    
    } 
    LogtoFile("Remote verification done.")

   ;---------------------- Hunter ------------------------

    for index,value in  ["hou","xhhz","song","long"]
        new 4399UserTask(value).Hunter(1)

    WinClose 360游戏大厅
Return

F10::Pause   ;pause the script
F11::
    ;myTcp.disconnect()
    ;myTcp := ""
    ExitApp ;stop the script
Return


