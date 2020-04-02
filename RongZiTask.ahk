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

logfilename := % logPath . "\\RongZiTask" . A_now  . ".txt"

LogToFile("Log started, RongZiTask.ahk")
; btn1 肉沫茄子 btn2 - btn4 4399, btn_2 - btn_4 4399 weekly order button,前一个窗口刚好挡住下一个的确认两个字。
global Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn_2: "798, 692", btn3: "522, 633", btn_3: "522, 692", btn4: "253, 622", btn_4: "253, 692"} 
Arrayhome := {okbtn: "324, 602", okbtnxxsf: "320, 610", kejicomp: "690,519", clobtn: "480, 266", clobtnxxsf: "500, 264"}
s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}

;WinActivate ahk_exe mstsc.exe
;WinSetTitle, ahk_exe mstsc.exe,, phy

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
    sendinput {D}

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

    LogToFile("Phy Com Clicked OK")
    WinSet, AlwaysOnTop, off, ahk_exe mstsc.exe
} 

IfWinExist xxsf
{
    WinActivate xxsf
    ;WinSet, AlwaysOnTop, On, xiaoxiaoshoufu
    sleep, % s["short"]
    click % Arrayhome["okbtnxxsf"]
    sleep, % s["short"]
    LogToFile("xxsf Clicked OK")
} 

IfWinExist xhhz
{
    WinActivate xhhz
    ;WinSet, AlwaysOnTop, On, xiaoxiaoshoufu
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    sleep, % s["short"]
    LogToFile("xhhz Clicked OK")
}

IfWinExist song
{
    WinActivate song
    ;WinSet, AlwaysOnTop, On, xiaoxiaoshoufu
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    sleep, % s["short"]
    LogToFile("xhhz Clicked OK")
} 

IfWinExist xiaoxiaoshoufu
{
    WinActivate xiaoxiaoshoufu
    ;WinSet, AlwaysOnTop, On, xiaoxiaoshoufu
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    sleep, % s["short"]
    click % Arrayhome["okbtn"]
    LogToFile("xiaoxiaoshoufu Clicked OK")
    CaptureScreenAll()	
    if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
        click % Arrayhome["clobtn"]
    
    ;winclose, xxsf     ;Won't close, waiting for land bussiness done.
    sleep, % s["short"]
    winclose, xhhz
    winclose, song
    winclose, xiaoxiaoshoufu
    sleep, % s["short"]
    ;runwait "4399OpenShangJi.ahk"
    ;CaptureScreen()	
    runwait "4399Shopping_Pan.ahk"
    sleep, % s["short"]
}
winclose, xiaoxiaoshoufu
LogToFile("RongZiTask done!")	
sleep, % s["short"]
LogToFile("End of log.")    
ExitApp

F10::Pause   ;pause the script
F11::ExitApp ;stop the script



