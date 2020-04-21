#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk
#Include QHUserTask.ahk
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper

SetTimer, Task202004, 1000  ;run every 1 secs
Return

Task202004:

    FormatTime, TimeToMeet,,HHmmss
    ;TimeToMeet = 235458

    If (TimeToMeet = 235458) ; Rong zi task, and also shopping / zhuanpan / openshangji
        runwait "RongZiTask.ahk"

    ;Task for every days

    If (TimeToMeet = 002500)  ; xiao hao zhuzi / Hunter
    {
        For index,value in  ["sf01","sf03","sf04","sf05","sf06"]
        {
            %value% := new 4399UserTask(value,0).ZhuZi(2)
            %value%.Hunter(1)
            %value% := ""
        }
    }

    If (TimeToMeet = 065000) or (TimeToMeet = 140000)  ; TouLie from black list
    {
        For index,value in  ["song","sf01","sf03","sf04","sf05","sf06"]
            new 4399UserTask(value).Hunter(0)
        UploadNetDisk()
    }  
    If (TimeToMeet = 202800) ; Bussniss war started  
        new 4399UserTask("long",0).ShangZhanReport()    

    If (TimeToMeet > 002000) and (TimeToMeet < 235000)  ; TianTi Task
    {
        FormatTime, Secs,,ss
        FormatTime, Mins,,mm
        If (mod(Mins,7) = 0) and (Secs = 33) 
        {
            For index,value in  ["supper","long","song"]
                new 4399UserTask(value,0).GetTianTi()
        }
    }      

Return

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper, order by money count
^Numpad1::     ;02/song
    new 4399UserTask("song",0)
return
^Numpad2::     ;Long
    new 4399UserTask("long",0)
return
^Numpad3::      ;Yun
    new 4399UserTask("yun",0)
return
^Numpad4::    ;88888
    new QHUser(0)
return
^Numpad5::    ;SF27_Supper
    new 4399UserTask("supper",0)
return

^Numpad6::     ;06
    new 4399UserTask("sf06",0)
    ;run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
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
^NumpadMult::     ;SF27_Hou
    new 4399UserTask("hou",0)
return
^NumpadDiv::    ;xhhz
    new 4399UserTask("xhhz",0)
return

^NumpadDot::    ;Screenshot
    CaptureScreen()
return

F12::ExitApp ;stop the script