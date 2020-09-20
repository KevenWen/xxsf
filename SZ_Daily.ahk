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
        
        ;UploadNetDisk()
        ExitApp
    }

return

;<========================================= Sub Tasks 0 ================================================>

Rongzi_0:

    ;------------------ Prepare game ---------------------
    L := new LDGame(0)
    N := new 6322Game(0)  
    D := new QHUser("dq",0)
    E := new QHUser("eight",0)
    
    song := new 4399UserTask("song",0)
    long := new 4399UserTask("long",0)
    sf06 := new 4399UserTask("sf06",0)
    yun := new 4399UserTask("yun",0)
    supper := new 4399UserTask("supper",0)
    
    For index,value in  ["long","yun","song","sf06","supper"]
        %value%.PrepareRongZi(index)

    WaitForTime(000000)
    ;-------------------- ClickRongZiOK --------------------

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.RongZi(index)

    if mod(A_YDay-118,7) = 0
        supper.OpenBusinessSkill()

    if mod(A_YDay-118,7) = 0
        supper.OpenBusinessSkill()

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.CloseGame()

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    For index,value in ["N","L","E","D"]
        %value%.GetLand()

    WaitForTime(000230,0)   ;Make sure we are start after 00:02, start even if later than 02
    ;--------------------- Tasks ------------------------

    For index,value in ["N","L","E","D"]
        %value%.RongZi()

    winClose dq    
    winClose eight

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    WinClose LDPlayer
    WinClose 6322Player

Return

;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;------------------ Prepare game ---------------------

    L := new LDGame(0)
    N := new 6322Game(0)
    Y := new YQXGame(0)         
    S := new QHUser("steve",0)
    D := new QHUser("dq",0)
    E := new QHUser("eight",0)        
    B := new QHUser("boy",0)   

    WaitForTime(000001)   ;Make sure we are start after 00:00
    ;--------------------- Tasks ------------------------
    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()
    For index,value in ["Y","S","B","N","L","E","D"]
        %value%.GetLand()

    winClose dq
    winClose eight
    winClose steve
    winClose boy

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    WinClose YQXPlayer
    WinClose LDPlayer
    WinClose 6322Player

    LogtoFile("Verification done.")

Return

;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;-------------------- Prepare game -----------------------
    
    L := new LDGame(0)
    N := new 6322Game(0) 
    Y := new YQXGame(0)       
    S := new QHUser("steve",0)
    D := new QHUser("dq",0)
    B := new QHUser("boy",0) 
    H := new 4399user("happy",0)

    song := new 4399UserTask("song",0)
    long := new 4399UserTask("long",0)
    sf06 := new 4399UserTask("sf06",0)
    yun := new 4399UserTask("yun",0)
    supper := new 4399UserTask("supper",0)

    WaitForTime(000000)
    ;-------------------- ClickRongZiOK --------------------

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.RongZi(index)

    WaitForTime(000001)   ;Make sure we are start after 00:00:01

    ;-------------------- Tasks ---------------------
    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    if mod(A_YDay-118,7) = 0
        L.OpenBusinessSkill()

    if mod(A_YDay-118,7) = 0
        supper.OpenBusinessSkill()

    if mod(A_YDay-118,7) = 0
        supper.OpenBusinessSkill()

    For index,value in ["S","Y","B","D","L","E","N"]
        %value%.GetLand()

    WaitForTime(000230,0)   ;Make sure we are start after 00:02, start even if later than 02

    For index,value in ["Y","L","N","E"]
        %value%.RongZi()
    S.RongZi(1)
    D.RongZi(3) 

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.RongZi(index)

    sleep 1000  
    WinClose steve
    WinClose dq

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")
 
    WinClose YQXPlayer
    WinClose LDPlayer
    WinClose 6322Player

Return

;<========================================= HotKeys ================================================>

^NumpadDot::
    CaptureScreen()
return

F12::ExitApp ;stop the script