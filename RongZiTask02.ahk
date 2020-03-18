#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#Include log.ahk
#include Functions.ahk

;ResizeWindow()

; Phy 肉沫茄子-5; supper-4; hou-2; long-3;
; phy2 yun-1; xxsf/8888-5; 
; home  02/song-2; xhhz-4;

CoordMode, Pixel, window  
CoordMode, Mouse, window

logfilename := % "E:\\AhkScriptManager-master\\log\\RongZiTask" . A_now  . ".txt"

LogToFile("Log started, RongZiTask.ahk")
global HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
global SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons
global Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn3: "522, 633", btn4: "253, 622"} ; btn1 肉沫茄子 btn2 - btn4 4399, 前一个窗口刚好挡住下一个的确认两个字。
global Arrayhome := {okbtn: "324, 602", okbtnxxsf: "316, 596", kejicomp: "690,519", clobtn: "480, 266", clobtnxxsf: "511, 259", mebtn:"145, 780"}
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}

;WinActivate ahk_exe mstsc.exe
;WinSetTitle, ahk_exe mstsc.exe,, phy


; 18-xhhz, 20-02,24-yun, 25-long,26-hou, 27-supper    
GetRongZiList() ;check if anyone RongZi already.
sleep 20000

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
    sendinput {y}
    ;click 792, 656

    ;Supper
    sleep 200
    click % Arrayphy["btn2"]
    sleep, % s["short"]
    click % Arrayphy["btn2"]
    sleep, % s["short"]

    ;Long
    click % Arrayphy["btn3"]
    sleep, % s["short"]
    click % Arrayphy["btn3"]
    sleep, % s["short"]

    ;Song
    click % Arrayphy["btn4"]
    sleep, % s["short"]
    click % Arrayphy["btn4"]
    sleep, % s["short"]

    LogToFile("Phy Com Clicked OK")
    WinSet, AlwaysOnTop, off, ahk_exe mstsc.exe
} 

runwait "4399PrepareRongZi.ahk" "24" "xiaoxiaoshoufu" "3" "Nocz_Y" ;yun
LogToFile("RongZiTask02.ahk for 24")

runwait "QHPrepareRongZi.ahk" "2" "Nocz_Y"
LogToFile("QHPrepareRongZi.ahk for 2")

runwait "4399PrepareRongZi.ahk" "26" "hou" "1" "Nocz_Y"
LogToFile("RongZiTask02.ahk for 26")

runwait "4399PrepareRongZi.ahk" "18" "xhhz" "4" "Nocz_Y"
LogToFile("RongZiTask02.ahk for 18")

;runwait "4399PrepareRongZi.ahk" "20" "song" "5" "Nocz_Y"
;LogToFile("RongZiTask02.ahk for 20")
;runwait "4399PrepareRongZi.ahk" "25" "long" "2" "Nocz_Y"
;LogToFile("RongZiTask02.ahk for 25")
;runwait "C:\ChangZhi\LDPlayer\ld.exe" -s 0 input tap 450 970  ; LDPlayer "5"
;runwait "4399PrepareRongZi.ahk" "27" "xiaoxiaoshoufu" "4" "Nocz_Y"
;LogToFile("RongZiTask02.ahk for 27")
;winclose ahk_exe dnplayer.exe



/*
IfWinExist xiaoxiaoshoufu
{
    WinActivate xiaoxiaoshoufu
    ;WinSet, AlwaysOnTop, On, xiaoxiaoshoufu
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    sleep, % s["long"]
    click % Arrayhome["okbtn"]
    LogToFile("xiaoxiaoshoufu Clicked OK")
    if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
        click % Arrayhome["clobtn"]
    winclose, xxsf
    sleep, % s["short"]
    winclose, xhhz
    sleep, % s["short"]
    CaptureScreen()	
    sleep, % s["short"]
}

*/
winclose, xiaoxiaoshoufu
LogToFile("RongZiTask done!")	
sleep, % s["longer"]
LogToFile("End of log.")    
ExitApp

;Functions:
GetRongZiList()
{    
    CoordMode, Pixel, window  
    CoordMode, Mouse, window

    IfWinExist, xiaoxiaoshoufu
    {
        WinActivate xiaoxiaoshoufu
        sleep, % s["long"]
        click % HB[5]
        sleep, % s["long"]
        click % SB[4]
        sleep, % s["long"]
        click 139, 781
        sleep, % s["short"]
        click 139, 781
        sleep, % s["long"]
        CaptureScreen()
        sleep, % s["long"]	
        click 482, 270
    }
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script