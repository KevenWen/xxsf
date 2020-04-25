﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include 4399UserTask.ahk
#include QHuserTask.ahk
#include RDPGame.ahk

; Phy 肉沫茄子-5; supper-4; hou-2; long-3;
; phy2 yun-1; xxsf/8888-5; 
; home  02/song-2; xhhz-4;

CoordMode, Pixel, window  
CoordMode, Mouse, window

FormatTime, DayToMeet,,d
IniRead, shangjiday, config.ini, April, shangjiday
IniRead, RongZi00, config.ini, April, RongZi00
IniRead, RongZi02, config.ini, April, RongZi02

if IsItemInList(DayToMeet,RongZi00)          ;RongZi at 00:00
    Gosub, Rongzi_0
else if IsItemInList(DayToMeet,RongZi02)     ;RongZi one by one, delay 2 minutes, at 00:02
    Gosub, Rongzi_2
else
    Gosub, Rongzi_N                          ;not a RongZi day

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
    For index,value in  ["supper","hou","xhhz","xxsf"]
    {
        IniRead, _RC, % UserIni, % value, RC,0        
        if _RC < 1
        {
           if value = xxsf
               new QHUser().RongZi(4)
            else 
               new 4399UserTask(value,0).RongZi(index)              
        }
    }
    WinClose,xxsf
    WinClose,supper    

    ;---------------------- ZhuanPan -----------------------
    new 4399UserTask("hou",0).ZhuanPan(5)
    new 4399UserTask("xhhz",0).ZhuanPan(5)

    ;----------------------- Hunter ------------------------
    For index,value in  ["hou","xhhz"]
        new 4399UserTask(value,0).Hunter(1)

    ;---------------------- Getland ------------------------

    For index,value in  ["xhhz","hou","supper"]
       new 4399UserTask(value).Getland()
    new QHUser().Getland()
    
    ;--------------------  Verification --------------------
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

    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;---------------------- Prepare ------------------------
    For index,value in  ["supper","yun","long","xhhz","song","xxsf"]
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

    ;---------------------- GetLand ------------------------

    new QHUser().Getland()
    For index,value in  ["supper","yun","long","xhhz","song"]
       new 4399UserTask(value).Getland()

   ;------------------- Verification ---------------------
    For index,value in  ["supper","yun","long","xhhz","song","xxsf"]
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
    ;---------------------- Hunter ------------------------

    For index,value in ["xhhz","long","song"]
        new 4399UserTask(value).Hunter(1)

    WinClose 360游戏大厅
    ;if IsItemInList(DayToMeet,shangjiday)
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

    Loop 600    ;Make sure we are start delayed from 2 mins
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

    Loop 600    ;Make sure we are start delayed from 2 mins
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
    For index,value in  ["supper","hou","xhhz","xxsf"]
    {
        IniRead, _RC, % UserIni, % value, RC,0
        IniRead, _DC, % UserIni, % value, DC,0              
        if _RC < 1
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

   ;------------------- Verification ---------------------
/*
    if RemoteBak()
    {
        For index,value in  ["song","yun","long"]
        {
            IniRead, _RZ, %UserIniRemote%, %value%, RZ
            if not _RZ
            new 4399UserTask(value).RongZi(index+2)  

            IniRead, _DC, %UserIniRemote%, %value%, DC
            if not _RZ
            new 4399UserTask(value).Getland()  
        }
    }
*/
   ;---------------------- Hunter ------------------------

    for index,value in  ["hou","xhhz","song","long"]
        new 4399UserTask(value).Hunter(1)

    WinClose 360游戏大厅
Return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script



