#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include 4399UserTask.ahk
#include RDPGame.ahk
#include QHuserTask.ahk
#include LDGame.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window
/*
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
; 8-yun, 7-long, 9-hou, 10-supper, 2-02/song	

["supper","yun","xhhz","long","song"]
["xhhz","song","sf01","sf03","sf04","sf05","sf06"]

new 4399UserTask("long",0).Shopping("2-1").Hunter(0).ZhuZi(2).RongZi(5)
    .Getland().GetTianTi().ZhuanPan(7).ShangZhanReport().CalcRongZi()
    .ClickRongZiOK().PrepareRongZi(3).OpenBusSkill()

*/


    new QHUser(0).ZhuZi(3)

  ExitApp
  
    For index,value in ["supper","yun","long","song","sf06"]
        new 4399UserTask(value).ZhuZi(2)

    For index,value in ["supper","yun","long","song"]
        new 4399UserTask(value).ZhuZi(1)

    For index,value in ["sf01","sf03","sf04","sf05","sf06"]
        new 4399UserTask(value).ZhuZi(2)
    For index,value in ["sf01","sf03","sf04","sf05","sf06"]
        new 4399UserTask(value).RongZi(2)        
    
    new QHUser(0).ZhuZi(3)

F10::Pause   ;pause the script
F11::ExitApp ;stop the script



