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

sleep 100
Gosub, Rongzi_0                        ;not a RongZi day

ExitApp
;<========================================= Sub Tasks 0 ================================================>


Rongzi_0:

  new 4399UserTask("long",0).CalcRongZi()

  ExitApp

/*
Loop 300    ;Make sure we are start after 00:00, total 10 mins
{
    FormatTime, MinToMeet,,mm
    if MinToMeet > 19
        Break
    sleep 2000
}
["supper","yun","xhhz","long","song"]
["xhhz","song","sf01","sf03","sf04","sf05","sf06"]

new 4399UserTask("long",0).Shopping("2-1").Hunter(0).ZhuZi(2).RongZi(5)
    .Getland().GetTianTi().ZhuanPan(7).ShangZhanReport().CalcRongZi()
    .ClickRongZiOK().PrepareRongZi(3).OpenBusSkill()

*/
    ;RongZiOKEmu()
    ;For index,value in  ["supper","yun","long"]
    ;For index,value in  ["sf01","sf03","sf04"]   

F10::Pause   ;pause the script
F11::ExitApp ;stop the script



