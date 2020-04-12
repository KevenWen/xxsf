#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include 4399UserTask.ahk
#include RDPGame.ahk
#include QHuserTask.ahk

; Phy 肉沫茄子-5; supper-4; hou-2; long-3;
; phy2 yun-1; xxsf/8888-5; 
; home  02/song-2; xhhz-4;

CoordMode, Pixel, window  
CoordMode, Mouse, window

; btn1 肉沫茄子 btn2 - btn4 4399, btn_2 - btn_4 4399 weekly order button,前一个窗口刚好挡住下一个的确认两个字。

sleep 1000
Gosub, Rongzi_0                        ;not a RongZi day

ExitApp

;<===================The sub tasks==========================>

;<========================================= Sub Tasks 0 ================================================>


Rongzi_0:

/*
["supper","yun","xhhz","long","song"]
["xhhz","song","sf01","sf03","sf04","sf05","sf06"]

*/
    For index,value in  ["sf06"]
        new 4399UserTask(value).ClickRongZiOK()

    ExitApp

    new QHUser().Getland()
    new 4399UserTask("supper").GetLand()

    For index,value in  ["supper","yun","long"]
        new 4399UserTask(value).GetLand()

    For index,value in  ["sf01","sf03","sf04","sf05","sf06"]
        new 4399UserTask(value).Hunter(1)
   
    For index,value in  ["sf01","sf03","sf04","sf05","sf06"]
        new 4399UserTask(value).ZhuZi(1)

    song := new 4399UserTask("song")
    sf04 := new 4399UserTask("sf04")

    For index,value in  ["supper","yun","long","song"]
        new 4399UserTask(value).ZhuZi(2)

    song := new 4399UserTask("song")
    supper := new 4399UserTask("supper")
    
    Loop 300    ;Make sure we are start after 00:00, total 10 mins
        {
            FormatTime, MinToMeet,,mm
            if MinToMeet < 50
                Break
            sleep 2000
        }

    rdp.RDP_0()

    ExitApp    
Return
;<========================================= Sub Tasks N ================================================>
; 19-01, 21-03, 22-04,23-05,35-06, 
; 18-xhhz, 20-02/song,24-yun, 25-long, 27-supper, 26-hou
Rongzi_N:
    supper := new 4399UserTask(supper_id,"supper")
    xhhz := new 4399UserTask(18,"xhhz")
    rdp := new RDPGame()

    Loop 300    ;Make sure we are start after 00:00, total 10 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet < 50
            Break
        sleep 2000
    }

	rdp.RDP_N()

    if IsItemInList(DayToMeet,shangjiday)
        new 4399UserTask(27,"supper").OpenBusSkill()

    runwait "QHLandBusiness.ahk"

    supper.GetLand()
    supper := ""
    xhhz.GetLand()

    long := new 4399UserTask(25,"long")
    long.GetLand()

    song := new 4399UserTask(20,"song")
    song.GetLand()
    
    long.Hunter(1)
    long := ""

    song.Hunter(1)
    song := ""

    xhhz.Hunter(1)
    xhhz := ""

Return
;<========================================= Sub Tasks 2 ================================================>

Rongzi_2:
    if IsItemInList(DayToMeet,shangjiday)
        runwait "4399OpenShangJi.ahk"

    runwait "QHLandBusiness.ahk"
    runwait "4399LandBusiness.ahk" "H"

    Loop 20    ;Make sure we are start delayed from 2 mins
    {
        FormatTime, MinToMeet,,mm
        if MinToMeet > 01
            Break
        sleep 5000
    }

    IfWinExist ahk_exe mstsc.exe
    {
        WinActivate ahk_exe mstsc.exe
        WinSet, AlwaysOnTop, On, ahk_exe mstsc.exe
        sleep 1000
        CaptureScreen()	
        sleep 200

        ;LDplayer
        click, % Arrayphy["btn1"]
        sleep, % s["short"]
        click, % Arrayphy["btn1"]
        sleep, % s["short"]    
        sendinput {Y}

        ;Supper
        if PixelColorExist("0xFFFFF3",798,633,10)
        {
            click % Arrayphy["btn_2"]
            sleep, % s["short"]
        }    
        click % Arrayphy["btn2"]
        sleep, % s["short"]
        click % Arrayphy["btn2"]
        sleep, % s["short"]

        ;Long
        if PixelColorExist("0xFFFFF3",522,633,10)
        {
            click % Arrayphy["btn_3"]
            sleep, % s["short"]
        }    
        click % Arrayphy["btn3"]
        sleep, % s["short"]
        click % Arrayphy["btn3"]
        sleep, % s["short"]

        ;Song
        if PixelColorExist("0xFFFFF3",253,633,10)
        {
            click % Arrayphy["btn_4"]
            sleep, % s["short"]
        }
        click % Arrayphy["btn4"]
        sleep, % s["short"]
        click % Arrayphy["btn4"]
        sleep, % s["short"]

        ;sendinput {^NumpadSub}
        
        WinSet, AlwaysOnTop, off, ahk_exe mstsc.exe
    } 
 
    runwait "QHPrepareRongZi.ahk" "3" "Nocz_Y"
    runwait "4399PrepareRongZi.ahk" "26" "hou" "1" "Nocz_Y"
    runwait "4399PrepareRongZi.ahk" "18" "xhhz" "4" "Nocz_Y"
    runwait "4399PrepareRongZi.ahk" "20" "song" "5" "Nocz_Y"

    runwait "4399LandBusiness.ahk" "XXL"
    runwait "4399TouLie.ahk" "lieshou" "launch" "S"    
    ;runwait "4399PrepareRongZi.ahk" "25" "long" "2" "Nocz_Y"
    ;runwait "C:\ChangZhi\LDPlayer\ld.exe" -s 0 input tap 450 970  ; LDPlayer "5"
    ;runwait "4399PrepareRongZi.ahk" "27" "xiaoxiaoshoufu" "4" "Nocz_Y"
    ;winclose ahk_exe dnplayer.exe

    winclose, xiaoxiaoshoufu
    WinClose 360游戏大厅
    ExitApp
Return


F10::Pause   ;pause the script
F11::ExitApp ;stop the script



