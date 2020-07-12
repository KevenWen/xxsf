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
    ;TimeToMeet = 235458

    If (TimeToMeet = 235458) ; Rong zi task, and also shopping / zhuanpan / openshangji
    {
        if mod(A_YDay,4)=0            ;RongZi at 00:00
            Gosub, Rongzi_0
        else if mod(A_YDay,2) > 0     ;not a RongZi day
            Gosub, Rongzi_N
        else
            Gosub, Rongzi_2           ;RongZi one by one, delay 2 minutes at 00:02

        UploadNetDisk()

        if mod(A_YDay,2) > 0
        {
            For index,value in  ["long","yun"]
            {
                %value% := new 4399UserTask(value)
                sleep 5000
                %value%.RongZi(3)
                %value% := ""
            }
        }
    }

    If (TimeToMeet = 065000)  ; TouLie from black list
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

    For index,value in  ["supper","xhhz","song","hou"]
        new 4399UserTask(value,0).PrepareRongZi(index)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000000)
    ;-------------------- ClickRongZiOK --------------------

    For index,value in  ["supper","xhhz","song","hou"]
        new 4399UserTask(value,0).RongZi(index)

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification 1...")
    For index,value in  ["supper","xhhz","song","hou"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0        
        if _RZ < 1
            new 4399UserTask(value,0).RongZi(index)
    }

    LogtoFile("Verification 1 done.")
    if mod(A_YDay-118,7) = 0
        new 4399UserTask("supper").OpenBusinessSkill()
    WinClose supper
    winclose song

    ;---------------------- ZhuanPan -----------------------

    ;new 4399UserTask("xhhz",0).ReloadGame()    
    new 4399UserTask("xhhz",0).ZhuanPan(1,1)    
    new 4399UserTask("hou",0).ZhuanPan(3,0)  

    ;----------------------- Hunter ------------------------
    For index,value in  ["xhhz","hou"]
        new 4399UserTask(value,0).Hunter(1)

    ;---------------------- Getland ------------------------

    For index,value in  ["xhhz","hou","supper","song"]
       new 4399UserTask(value).Getland()
    
    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification 2...")
    For index,value in  ["xhhz","song","supper"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value).Getland()
    }
    LogtoFile("Verification 2 done.")

    GameRecordingOff()
    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks N ================================================>

Rongzi_N:

    ;---------------------- Prepare ------------------------
    FileDelete % UserIni
    FileAppend,,% UserIni

    For index,value in  ["supper","xhhz","song","sf06"]
       new 4399UserTask(value,0)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000001)    
    ;---------------------- Tasks ------------------------

    For index,value in  ["supper","xhhz","song","sf06"]
       new 4399UserTask(value,0).Getland()

    if mod(A_YDay-118,7) = 0
        new 4399UserTask("supper").OpenBusinessSkill()    

   ;------------------- Verification ---------------------
    LogtoFile("Start to do verification...")
    For index,value in  ["supper","xhhz","song","sf06"]
    {
        IniRead, _DC, % UserIni, % value, DC,0        
        if _DC < 1
            new 4399UserTask(value,0).Getland()
    }
    WinClose supper
    LogtoFile("Verification done.")    
    ;---------------------- Hunter ------------------------

    For index,value in ["xhhz","sf06"]
        new 4399UserTask(value).Hunter(1)
    
    GameRecordingOff()
    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

    ;---------------------- Prepare ------------------------
    FileDelete % UserIni
    FileAppend,,% UserIni

    For index,value in  ["supper","xhhz","hou","song","sf06"]
        new 4399UserTask(value,0)

    WaitForTime(235945)
    GameRecordingOn()
    WaitForTime(000001)  
   ;---------------------- Getland ------------------------

    For index,value in  ["supper","xhhz","song","sf06","hou"]
        new 4399UserTask(value,0).GetLand()
    if mod(A_YDay-118,7) = 0
        new 4399UserTask("supper").OpenBusinessSkill()   
   ;---------------------- Waiting ------------------------

    WaitForTime(000230,0)   ;Make sure we are start after 00:02, start even if later than 02

   ;---------------------- RongZi ------------------------

    For index,value in  ["supper","xhhz","hou","song","sf06"]
        new 4399UserTask(value,0).RongZi(index) 

    WinClose supper
    winclose hou
    winclose song

   ;---------------------- Hunter ------------------------

    for index,value in  ["xhhz","sf06"]
        new 4399UserTask(value).Hunter(1)

    ;--------------------  Verification --------------------
    LogtoFile("Start to do verification...")
    For index,value in  ["supper","hou","xhhz","song","sf06"]
    {
        IniRead, _RZ, % UserIni, % value, RZ,0
        IniRead, _DC, % UserIni, % value, DC,0 

        if _RZ < 1
            new 4399UserTask(value).RongZi(index)
        if _DC < 1
            new 4399UserTask(value).Getland()
    }
    LogtoFile("Verification done.")

    GameRecordingOff()
    WinClose 360游戏大厅
Return



^NumpadDot::    ;Screenshot
    CaptureScreen()
return

F12::ExitApp ;stop the script