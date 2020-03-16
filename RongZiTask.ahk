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

Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn3: "522, 633", btn4: "253, 622"} ; btn1 肉沫茄子 btn2 - btn4 4399, 前一个窗口刚好挡住下一个的确认两个字。
Arrayhome := {okbtn: "324, 602", okbtnxxsf: "316, 596", kejicomp: "690,519", clobtn: "480, 266", clobtnxxsf: "511, 259"}
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

IfWinExist xxsf
{
    WinActivate xxsf
    ;WinSet, AlwaysOnTop, On, xiaoxiaoshoufu
    sleep, % s["short"]
    click % Arrayhome["okbtnxxsf"]
    sleep, % s["short"]
    ;if PixelColorExist("0xFFFEF5", 407,420,500) ;close the sub window if the first window closed
        ;click % Arrayhome["clobtnxxsf"]
      ; winclose, xxsf

    LogToFile("xxsf Clicked OK")
    ;ExitApp
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
    /*
    if PixelColorExist("0xFFFEF5", 401, 419,500) ;close the sub window if the first window closed
        ;click % Arrayhome["clobtn"]
        winclose, xhhz
    */
    LogToFile("xhhz Clicked OK")
} 

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

    ;sleep, % s["mid"]
    ;RZCloseSubWindowAndRefresh() 
    ;LogToFile("xiaoxiaoshoufu Clicked OK and 5 lines ready")    
    sleep, % s["short"]
    ;runwait "4399OpenShangJi.ahk"
    CaptureScreen()	
    runwait "4399Shopping_Pan.ahk"
    sleep, % s["short"]
}
winclose, xiaoxiaoshoufu
LogToFile("RongZiTask done!")	
sleep, % s["longer"]
LogToFile("End of log.")    
ExitApp

;Functions:
RZCloseSubWindowAndRefresh() 
{
	WaitPixelColorAndClick("0xFBFBFB", 481, 267,1000)
    sleep, % s["short"]
	loop 2
	{
		click 396, 396
        sleep, % s["mid"]
		WaitPixelColorAndClick("0xFBFBFB", 481, 267,2000)
        sleep, % s["short"]
		if PixelColorNotExist("0xCDCDCD",156, 514,500) ;Youle
			and PixelColorNotExist("0xABA9A5",166, 737,500) ;NengYuan
			and PixelColorNotExist("0xCCCCCC",252, 631,500) ;JingRong
			and PixelColorNotExist("0x7DAECA",321, 734,500) ;JiuDian
			and PixelColorNotExist("0xCCCCCC",362, 483,500) ;KeJi
			break	
		
		sleep 800
	}
}



