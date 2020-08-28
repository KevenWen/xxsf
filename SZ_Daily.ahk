﻿#NoEnv 
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

SetTimer, Task2020, 1000  ;run every 1 secs
Return

Task2020:

    FormatTime, TimeToMeet,,HHmmss

    ;TimeToMeet = 235459

    If (TimeToMeet = 235459)
    {
        if mod(A_YDay,2) > 0     ;not a RongZi day
            Gosub, Rongzi_N
        else
            Gosub, Rongzi_2           ;RongZi one by one, delay 2 minutes at 00:02
        
        UploadNetDisk()
        ExitApp
    }

return

;<========================================= Sub Tasks 0 ================================================>

Rongzi_0:
;Nothing to do now
Return

;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;------------------ Prepare game ---------------------

    L := new LDGame(0)
    N := new 6322Game(0)
    Y := new YQXGame(0)         
    S := new QHUser("steve",0)
    D := new QHUser("dq",0)
    E := new QHUser("88888",0)        
    B := new QHUser("boy",0)   
    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000001)   ;Make sure we are start after 00:00
    ;--------------------- Tasks ------------------------
    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()
    For index,value in ["B","S","Y","N","L","E","D"]
        %value%.GetLand()
    winClose steve
    winClose dq    
    winClose 88888 
    winClose boy    

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    WinClose YQXPlayer
    WinClose LDPlayer
    WinClose 6322Player

    GameRecordingOff()
    LogtoFile("Verification done.")

Return

;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;-------------------- Prepare game -----------------------
    
    L := new LDGame(0)
    N := new 6322Game(0)      
    S := new QHUser("steve",0)
    D := new QHUser("dq",0)
    E := new QHUser("88888",0)             
    Y := new YQXGame(0)


    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000001)   ;Make sure we are start after 00:00:01

    ;-------------------- Tasks ---------------------
    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    For index,value in ["S","Y","D","L","E","N"]
        %value%.GetLand()

    WaitForTime(000230,0)   ;Make sure we are start after 00:02, start even if later than 02

    For index,value in ["Y","L","N","E"]
        %value%.RongZi()
    S.RongZi(1)
    D.RongZi(3) 

    sleep 1000  
    WinClose steve
    WinClose dq

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")

    if mod(A_YDay-118,7) = 0
    {
        IniRead, _SJ, % UserIni,LDPlayer,SJ,0
        if _SJ < 1
            L.OpenBusinessSkill()
    }
 
    WinClose YQXPlayer
    WinClose LDPlayer
    WinClose 6322Player

    GameRecordingOff()
    sleep 5000
    WinClose 360游戏大厅

Return

;<========================================= HotKeys ================================================>

^NumpadDot::
    CaptureScreen()
return

F12::ExitApp ;stop the script