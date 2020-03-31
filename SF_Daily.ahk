﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include Functions.ahk
;ResizeWindow()
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper

CoordMode, Pixel, window  
CoordMode, Mouse, window

SetTimer, Task202004, 1000  ;run every 1 secs
Return

Task202004:

    FormatTime, TimeToMeet,,HHmmss
    FormatTime, DayToMeet,,d
    isRongZi00 := 0      ; Rong Zi at exactly 00:00
    isRongZi02 := 0      ; RongZi one by one
    isRZ02OpenSJ := 0    ; RongZi delay 2 minutes and before this time need open shang Ji   
    onlyOpenShangJi := 0 ; No need Rong zi but need open shangJi
    isNotRongZiday := 0  ; No rong zi task

    if DayToMeet in 1,5,9,13,17,21,25,29
        isRongZi00 := 1
    if DayToMeet in 3,7,11,15,19,23,27
        isRongZi02 := 1
    if DayToMeet in 31,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
        isNotRongZiday := 1         
    if DayToMeet in 19
        isRZ02OpenSJ := 1         
    if DayToMeet in 12,26
        onlyOpenShangJi := 1

    ;isRongZi02 := 1 
    ;TimeToMeet = 235959
    
    ;Task for Rong Zi days
    if isRongZi00 = 1  ;DayToMeet in 1,5,9,13,17,21,25,29
    {

        /*
            ; 18-xhhz, 20-02, 24-yun, 25-long,26-hou, 27-supper
            ; Phy 肉沫茄子-5; 02/song-4; long-2; hou-1;
            ; --manual yun-1; 茄子肉沫-2
            ; home  supper-4; xhhz-5 ;xxsf/8888-3;

            runwait "4399PrepareRongZi.ahk" "27" "xiaoxiaoshoufu" "4"
            runwait "QHPrepareRongZi.ahk" "3"
            Exitapp
        */
        If (TimeToMeet = 224000) ; Double check
            CaptureScreenAll()	

        If (TimeToMeet = 233000) ; Double check
            CaptureScreenAll()	

        If (TimeToMeet = 235000) ; Rong zi task prepare for xhhz
            runwait "4399PrepareRongZi.ahk" "18" "xhhz" "5"

        If (TimeToMeet = 235400) ; Check if the remote Desktop is still open, if not and login failed, send alert.
        {
            CaptureScreenAll()
            sleep 1000            
            if !FixRDPConn()
                SendAlertEmail()
        }
        
        If (TimeToMeet = 235959) ; Rong zi task, and also shopping / zhuanpan / openshangji
        {
            runwait "RongZiTask.ahk" 
            runwait "4399TouLie.ahk" "lieshou" "launch" "S"
            runwait "QHLandBusiness.ahk"
            runwait "4399LandBusiness.ahk" "XXXL"
        }

    }
    ;Task for delay Rong Zi days
    if isRongZi02 = 1  ;DayToMeet in 3,7,11,15,19,23,27
    {
        If (TimeToMeet = 220000) ; Double check
            CaptureScreenAll()	

        If (TimeToMeet = 224000) ; Double check
            CaptureScreenAll()	

        If (TimeToMeet = 235400) ; Check if the remote desktop is opened, if not send alert.
        {
            CaptureScreenAll()
            sleep 1000
            if !FixRDPConn()
                SendAlertEmail()
        }

        If (TimeToMeet = 235959 ) ; Rong zi task, and also shopping / zhuanpan / openshangji
        {
            sleep 2000
            if isRZ02OpenSJ = 1
                runwait "4399OpenShangJi.ahk"

            runwait "QHLandBusiness.ahk"
            runwait "4399LandBusiness.ahk" "H"

            Loop 20                  ;Make sure we are start delayed from 2 mins
            {
                FormatTime, MinToMeet,,mm
                if MinToMeet > 01
                    Break
                sleep 5000
            }
            runwait "RongZiTask02.ahk" 
            runwait "4399LandBusiness.ahk" "XXL"
            runwait "4399TouLie.ahk" "lieshou" "launch" "S"
        }
    }
    ;Task for no Rong Zi days
    if isNotRongZiday = 1  ;DayToMeet in 31,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
    {
        If (TimeToMeet = 235959 ) ; Rong zi task, and also openshangji if needed.
        {
            sleep 2000
            if onlyOpenShangJi = 1
               runwait "4399OpenShangJi.ahk"  

            runwait "QHLandBusiness.ahk"   
            runwait "4399LandBusiness.ahk" "XXXL"
            runwait "4399TouLie.ahk" "lieshou" "launch" "SS"
        }

    }

    ;Task for every days
    If (TimeToMeet = 062000) ; TouLie from black list
        runwait "4399TouLie.ahk" "black" "launch" "XL"     

    If (TimeToMeet = 123000) ; TouLie from black list
        runwait "4399TouLie.ahk" "black" "launch" "XL"     

    If (TimeToMeet = 200400) ; Bussniss war started
    {        
        runwait "ShangZhanReport.ahk"
    }

    If (TimeToMeet = 001500 ) ; Rong zi task for 01-06
    {
        runwait "4399ZhuRongZi.ahk" "ZR" "L" 
        runwait "4399TouLie.ahk" "black" "launch" "L"     
    }    
Return

global toggle := 0
F9::
    global countN = 0
    toggle := !toggle
    if (toggle){        
        SetTimer, Timer_click, 10
    } else {
        SetTImer, Timer_click, Off
    }
return

Timer_click:
    click    
    countN+=1
    if (countN > 36)
    {
        toggle := !toggle
        SetTImer, Timer_click, Off
    }      
return

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper, order by money count
^Numpad1::     ;02/song
    run %4399GamePath% -action:opengame -gid:1 -gaid:20
return
^Numpad2::     ;Long
    run %4399GamePath% -action:opengame -gid:1 -gaid:25 
return
^Numpad3::      ;Yun
    run %4399GamePath% -action:opengame -gid:1 -gaid:24 
return
^Numpad4::    ;88888
    run %4399GamePath% -action:opengame -gid:4 -gaid:30 
return
^Numpad5::    ;SF27_Supper
    run %4399GamePath% -action:opengame -gid:1 -gaid:27 
return

^Numpad6::     ;06
    run %4399GamePath% -action:opengame -gid:1 -gaid:35 
    ;run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
return
^Numpad0::     ;01
    run %4399GamePath% -action:opengame -gid:1 -gaid:19
return
^Numpad7::     ;03
    run %4399GamePath% -action:opengame -gid:1 -gaid:21
return
^Numpad8::     ;04
    run %4399GamePath% -action:opengame -gid:1 -gaid:32 
return
^Numpad9::     ;05
    run %4399GamePath% -action:opengame -gid:1 -gaid:23 
return
^NumpadMult::     ;SF27_Hou
    run %4399GamePath% -action:opengame -gid:1 -gaid:26 
return
^NumpadDiv::    ;xhhz
    run %4399GamePath% -action:opengame -gid:1 -gaid:18
return

F12::ExitApp ;stop the script