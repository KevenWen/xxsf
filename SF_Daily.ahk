#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#Include QHUserTask.ahk
Menu, Tray, Icon, % A_ScriptDir . "\img\home.ico"

SetTimer, Task2020, 1000  ;run every 1 secs
Return

Task2020:

    FormatTime, TimeToMeet,,HHmmss
    TimeToMeet = 235458

    If (TimeToMeet = 235458) ; Rong zi task, and also shopping / zhuanpan / openshangji
    {
        if mod(A_YDay,4)=0            ;RongZi at 00:00
            Gosub, Rongzi_0
        else if mod(A_YDay,2) > 0     ;not a RongZi day
            Gosub, Rongzi_N
        else
            Gosub, Rongzi_2           ;RongZi one by one, delay 2 minutes at 00:02

        ;UploadNetDisk()

        new 4399UserTask("xhhz",0).Getland()
        if mod(A_YDay,2) > 0
            new 4399UserTask("xhhz",0).RongZi(3)
        new 4399UserTask("xhhz").Hunter(1)        
    }

    If (TimeToMeet = 003000)  ; TouLie from black list
    {
        For index,value in  ["sf01","sf03","sf04","sf05"]
            new 4399UserTask(value).Hunter(0)
    }  

    If (TimeToMeet = 202800) ; Bussniss war started  
        new 4399UserTask("supper",0).ShangZhanReport()    

Return

;<========================================= Sub Tasks 0 ================================================>


Rongzi_0:

    FileDelete % UserIni 
    FileAppend,,% UserIni

    song := new 4399UserTask("song",0)
    long := new 4399UserTask("long",0)
    sf06 := new 4399UserTask("sf06",0)
    yun := new 4399UserTask("yun",0)
    supper := new 4399UserTask("supper",0)
    
    For index,value in  ["long","yun","song","sf06","supper"]
        %value%.PrepareRongZi(index)

    WaitForTime(235955)
    GameRecordingOn()
    WaitForTime(000000)
    ;-------------------- ClickRongZiOK --------------------

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.RongZi(index)

    if mod(A_YDay-118,7) = 0
        new 4399UserTask("supper",0).OpenBusinessSkill()

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.CloseGame()

    ;---------------------- ZhuanPan -----------------------
    ;new 4399UserTask("xhhz",0).ZhuanPan(6,0)
    ;----------------------- Hunter ------------------------
    ;---------------------- Getland ------------------------    
    ;--------------------  Verification --------------------

    GameRecordingOff()
    sleep 5000
    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    WaitForTime(000001) 
    GameRecordingOn()   
    ;---------------------- Tasks ------------------------

    if mod(A_YDay-118,7) = 0
        new 4399UserTask("supper").OpenBusinessSkill()    
    
    GameRecordingOff()
    Sleep 5000
    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;---------------------- Prepare ------------------------

    song := new 4399UserTask("song",0)
    long := new 4399UserTask("long",0)
    sf06 := new 4399UserTask("sf06",0)
    yun := new 4399UserTask("yun",0)
    supper := new 4399UserTask("supper",0)

    WaitForTime(235955)
    GameRecordingOn()
    WaitForTime(000001)  
   ;---------------------- Getland ------------------------

    if mod(A_YDay-118,7) = 0
        supper.OpenBusinessSkill()
   ;---------------------- Waiting ------------------------

    WaitForTime(000230,0)   ;Make sure we are start after 00:02, start even if later than 02

   ;---------------------- RongZi ------------------------

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.RongZi(index)

    For index,value in ["long","yun","song","sf06","supper"]
        %value%.CloseGame()

    ;--------------------  Verification --------------------

    GameRecordingOff()
    sleep 5000
    WinClose 360游戏大厅
Return



^NumpadDot::    ;Screenshot
    CaptureScreen()
return

F12::ExitApp ;stop the script