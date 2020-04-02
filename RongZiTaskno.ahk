#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

FormatTime, DayToMeet,,d
IniRead, shangjiday, config.ini, April, shangjiday

; btn1 肉沫茄子 btn2 - btn4 4399, btn_2 - btn_4 4399 weekly order button,前一个窗口刚好挡住下一个的确认两个字。
global Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn_2: "798, 692", btn3: "522, 633", btn_3: "522, 692", btn4: "253, 622", btn_4: "253, 692"} 
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}

IfWinExist ahk_exe mstsc.exe
{
    WinActivate ahk_exe mstsc.exe
    sleep 200
    CaptureScreen()	
    sleep 200

    ;LDplayer
    click, % Arrayphy["btn1"]
    sleep, % s["short"]
    click, % Arrayphy["btn1"]
    sleep, % s["short"]    
    sendinput {D}
} 

if IsItemInList(DayToMeet-1,shangjiday,",")
    runwait "4399OpenShangJi.ahk"

runwait "QHLandBusiness.ahk"   
runwait "4399LandBusiness.ahk" "XXXL"
runwait "4399TouLie.ahk" "lieshou" "launch" "SS"