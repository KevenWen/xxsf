#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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


; btn1 肉沫茄子 btn2 - btn4 4399, btn_2 - btn_4 4399 weekly order button,前一个窗口刚好挡住下一个的确认两个字。
global Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn_2: "798, 692", btn3: "522, 633", btn_3: "522, 692", btn4: "253, 622", btn_4: "253, 692"} 
Arrayhome := {okbtn: "324, 602", okbtnxxsf: "320, 610", kejicomp: "690,519", clobtn: "480, 266", clobtnxxsf: "500, 264"}
s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}

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

    For index,value in  ["song","hou","xhhz"]
        new 4399UserTask(value,0).PrepareRongZi(index)

    new QHUser(0).PrepareRongZi(4)

    Loop 600    ;Make sure we are start after 00:00, total 10 mins
        {
            FormatTime, MinToMeet,,mm
            if MinToMeet = 00
                Break
            sleep 1000
        }

    new RDPGame().RDP_0()

    new QHUser().ClickRongZiOK()

    For index,value in  ["song","hou","xhhz"]
        new 4399UserTask(value,0).ClickRongZiOK()

    new 4399UserTask("song",0).ZhuanPan(3)

    For index,value in  ["song","hou","xhhz"]
        new 4399UserTask(value).Hunter(1)

    new QHUser().Getland()

    For index,value in  ["supper","xhhz","yun","long","song","hou"]
       new 4399UserTask(value).Getland()

    For index,value in  ["sf01","sf03","sf04","sf05","sf06"]
       new 4399UserTask(value).Hunter(1)
    
    WinClose 360游戏大厅
Return
;<========================================= Sub Tasks N ================================================>
; 19-01, 21-03, 22-04,23-05,35-06, 
; 18-xhhz, 20-02/song,24-yun, 25-long, 27-supper, 26-hou
Rongzi_N:
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

    new QHUser().Getland()
    For index,value in  ["supper","yun","long","xhhz","song"]
       new 4399UserTask(value).Getland()

    for index,value in ["xhhz","long","song","sf01","sf03","sf04","sf05","sf06"]
        new 4399UserTask(value).Hunter(1)

    WinClose 360游戏大厅
    ;if IsItemInList(DayToMeet,shangjiday)
    ;    supper.OpenBusSkill()
Return
;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:

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

   new QHUser(0).Getland()

   For index,value in  ["supper","xhhz","hou"]
        new 4399UserTask(value,0).GetLand()

   If IsItemInList(DayToMeet,shangjiday)
       new 4399UserTask("supper",0).OpenBusSkill()

    Loop 600    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet > 01
            Break
        sleep 1000
    }

    ;new RDPGame().RDP_2()
    For index,value in  ["supper","xhhz","hou"]
        new 4399UserTask(value).RongZi(index) 

    new QHUser().RongZi(4)

   ;For index,value in  ["song","yun","long"]
    ;    new 4399UserTask(value).GetLand()

    for index,value in  ["hou","xhhz","song","long","sf01","sf03","sf04","sf05","sf06"]
        new 4399UserTask(value).Hunter(1)

    WinClose 360游戏大厅
Return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script



