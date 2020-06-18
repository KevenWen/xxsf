#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#Include QHUserTask.ahk
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
Menu, Tray, Icon, % A_ScriptDir . "\img\home.ico"

SetTimer, Task2020, 1000  ;run every 1 secs
Return

Task2020:

    FormatTime, TimeToMeet,,HHmmss
    ;TimeToMeet = 235458

    If (TimeToMeet = 235458) ; Rong zi task, and also shopping / zhuanpan / openshangji
        runwait "RongZiTask.ahk"

    ;Task for every days

    If (TimeToMeet = 002500)  ; xiao hao zhuzi / Hunter
    {
        For index,value in  ["sf05","long","yun"]
        {
            %value% := new 4399UserTask(value)
            sleep 5000
            if mod(A_YDay,2) > 0                         
                ;%value%.RongZi(mod(index,5)+1)
                %value%.RongZi(3)
            %value%.Hunter(1)
            %value% := ""
        }
    }

    If (TimeToMeet = 065000) or (TimeToMeet = 140000)  ; TouLie from black list
    {
        For index,value in  ["sf01","sf03","sf04","sf05"]
            new 4399UserTask(value).Hunter(0)
        UploadNetDisk()
    }  

    If (TimeToMeet = 202800) ; Bussniss war started  
        new 4399UserTask("supper",0).ShangZhanReport()    

/*
    If (TimeToMeet > 002000) and (TimeToMeet < 202000)  ; TianTi Task
    {
        FormatTime, Secs,,ss
        FormatTime, Mins,,mm
        If (mod(Mins,7) = 0) and (Secs = 33) 
        {
            For index,value in  ["supper","song"]
                new 4399UserTask(value,0).GetTianTi()
        }
    }      
*/
Return

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper, order by money count
^Numpad1::     ;02/song
    Launch4399GamePri("song",20)
return
^Numpad2::     ;Long
    Launch4399GamePri("long",25)
return
^Numpad3::      ;Yun
    Launch4399GamePri("yun",24)
return
^Numpad4::    ;88888
    ;new QHUser("88888",0)
return
^Numpad5::    ;SF27_Supper
    Launch4399GamePri("supper",27)
return

^Numpad6::     ;06
    Launch4399GamePri("sf06",35)
    ;run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
return
^Numpad0::     ;01
    Launch4399GamePri("sf01",19)
return
^Numpad7::     ;03
    Launch4399GamePri("sf03",21)
return
^Numpad8::     ;04
    Launch4399GamePri("sf04",22)
return
^Numpad9::     ;05
    Launch4399GamePri("sf05",23)
return
^NumpadMult::     ;SF27_Hou
    Launch4399GamePri("hou",26)
return
^NumpadDiv::    ;xhhz
    Launch4399GamePri("xhhz",18)
return

^NumpadDot::    ;Screenshot
    CaptureScreen()
return

F12::ExitApp ;stop the script