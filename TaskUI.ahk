﻿; Generated by AutoGUI 2.6.2
#SingleInstance Force
#NoEnv
#include 4399UserTask.ahk
#include QHUserTask.ahk
#include LDGame.ahk
#include YQXGame.ahk
#include 6322Game.ahk

SetWorkingDir %A_ScriptDir%
SetBatchLines -1

;=========================== GUI Components ========================================

Gui Add, Text, x25 y20 w124 h25 +0x200, % "任务选项" A_YDay " Mod " Mod(A_YDay,4)

Gui Add, Text, vExecTime x25 y55 w210 h23 +0x200, 执行时间（如000001, 留空立即执行)：
Gui Add, Edit, vTimeStart x230 y55 w100 h21 +Number


Gui Add, CheckBox, visGFiance x25 y88 w50 h23, 融资
Gui Add, ComboBox, vFianceSeq xp+50 w30, 1|2|3|4|5
Gui Add, CheckBox, visPlayTurnTable xp+60 y88 w60 h23, 转盘x10
Gui Add, ComboBox, vTurnTableTime xp+60 w30, 0|1|2|3|4|5|6|7
Gui Add, CheckBox, vTimespeed xp+35 h23, 转前买加速
Gui Add, CheckBox, vLoginagain xp+83 h23, 之前重登


Gui Add, CheckBox, visGInjection x25 yp+31 w45, 注资
Gui Add, ComboBox, vInjectionSeq xp+50 w30, 1|2|3
Gui Add, CheckBox, visShopping xp+60 yp+5 w55, 商店买
Gui Add, ComboBox, vShoppingAt xp+55 yp+0 w40, 1-1|1-2|1-3|1-4|2-1|2-2|2-3|2-4
Gui Add, CheckBox, visHunter xp+50 w81, 黑名单偷猎
Gui Add, CheckBox, visLand xp+83 w81, 地产入驻


Gui Add, CheckBox, visCaiTuan x25 yp+29, 财团收钱
Gui Add, CheckBox, visShare xp+110 , 分享20钻石
Gui Add, CheckBox, visCard xp+105 , 刷拼图
Gui Add, CheckBox, visOpenBS xp+83, 开商技

Gui Add, CheckBox, visCalRZ x25 yp+29, 融资计算

Gui Add, ListView, vUlist x420 y25 w145 h345 gMyListView, UserTitle..|ID|Num
for key,num in numTable
        LV_Add("", key,idTable[key],num)


Gui Add, Text, cRed vTips x25 y240 w164 h23 +0x200,

Gui Add, CheckBox, visRecordingOn x25 y+m, 开启录屏
Gui Add, CheckBox, visClose x+M, 任务完成关闭窗口

Gui Add, Button, x23 yp+29 gOpenLog, 查看日志文件...  
Gui Add, Button, x+M gOpenPic, 查看商品列表...  
Gui Add, Button, x+M gOpenSpy, 打开WinSpy...  
Gui Add, Button, x+M gOpenNoSleep, 运行NoSleep...

Gui Add, Button, x23 yp+32 gRunVSCode, 打开VS_Code....
Gui Add, Button, x+M gRunSF, 执行SF_Daily.....
Gui Add, Button, x+M gRunSP, 执行SP_Daily.
Gui Add, Button, x+M gRunSZ, 执行SZ_Daily..

Gui Add, Button, vBtnCreateTask x22 y380 w115 h41 gCreateTask, 创建任务
Gui Add, Button, x+M  w108 h42 gReloading, 重置任务(F12)
Gui Add, Button, vBtnPauseTask x+M  w117 h40 gGuiPause, 暂停任务(F7恢复)
Gui Add, Button, x+M  w117 h40 gGuiClose, 关闭(F8)


GuiControl, Disable, BtnPauseTask

Menu, Tray, Icon, % A_ScriptDir . "\img\i1.ico"
Gui Show, w588 h460, Tasks

run % A_ScriptDir . "\NoSleep.exe"
Return

;=========================== Create Task  ========================================

CreateTask:

;--------------------------- Get the control values -----------------------------

    ControlGet, SelectedUsersC, List,Count Selected, SysListView321, Tasks

    GuiControlGet, TimeStart 

    GuiControlGet, isRongZiSelected,, isGFiance
    GuiControlGet, RongziWhich,, FianceSeq

    GuiControlGet, isPlayTurnTableSelected,, isPlayTurnTable
    GuiControlGet, TurnTableTimes,, TurnTableTime
    GuiControlGet, isbuyTimespeed,, Timespeed
    GuiControlGet, isLoginagain,, Loginagain

    GuiControlGet, isZhuZiSelected,, isGInjection
    GuiControlGet, zhuziWhich,, InjectionSeq
    GuiControlGet, isShoppingSelected,, isShopping
    GuiControlGet, ShoppingAtWhich,, ShoppingAt
    GuiControlGet, isHunterSelected,, isHunter            
    GuiControlGet, isLandSelected,, isLand    

    GuiControlGet, isCaiTuanSelected,, isCaiTuan
    GuiControlGet, isShareSelected,, isShare
    GuiControlGet, isCardSelected,, isCard
    GuiControlGet, isOpenBSSelected,, isOpenBS

    GuiControlGet, isCalRZSelected,, isCalRZ

    GuiControlGet, isRecordingOnSelected,, isRecordingOn            
    GuiControlGet, isClose,, isClose

;------------------------------ Verification -------------------------------------

    if (isZhuZiSelected and zhuziWhich = "")
    {
        MsgBox, Please select a zhuzi sequence!
        Return
    }

    if (isRongZiSelected and RongziWhich = "")
    {
        MsgBox, Please select a RongZi sequence!
        Return
    }

    if (isPlayTurnTableSelected and TurnTableTimes = "")
    {
        MsgBox, Please select Turn Table Times!
        Return
    }

    if (isShoppingSelected and ShoppingAtWhich = "")
    {
        MsgBox, Please select which to buy!
        Return
    }

    if (SelectedUsersC < 1)
    {
        MsgBox, Please select at least one user!
        Return
    }

;------------------------------ Button Control -------------------------------------

    GuiControl, Disable, BtnCreateTask
    GuiControl, Enable, BtnPauseTask
    GuiControl, Disable, TimeStart

;------------------------------ Execution Time Control ------------------------------

    if !(TimeStart = "")
    {
        TimeNow := A_Hour A_Min A_Sec
        while !(TimeStart = TimeNow)
        {
            TimeNow := A_Hour A_Min A_Sec
            GuiControl,, Tips, % "执行倒计时：" 
            . Floor(WaitTime(TimeStart)/60) . " 分 " . Round(mod(WaitTime(TimeStart),60),0) . " 秒"
            sleep 1000
        }
    }

;------------------------------ Recording Control -------------------------------------

    if isRecordingOnSelected
        GameRecordingOn()

;------------------------------ Loop the selected users --------------------------------

    ControlGet, SelectedUsers, List,Selected, SysListView321, Tasks
    {
        Loop, Parse, SelectedUsers, `n  ; Rows are delimited by linefeeds (`n).
        {
            U := StrSplit(A_LoopField, A_Tab)
            if (U[1] = "88888" or U[1] = "steve" or U[1] = "dq" or U[1] = "boy")
                user := new QHUser(U[1],isClose)
            else if (U[1] = "LDGame")
                user := new LDGame(isClose)
            else if (U[1] = "YQXGame")
                user := new YQXGame(isClose)
            else if (U[1] = "6322Game")
                user := new 6322Game(isClose)
            Else    
                user := new 4399UserTask(U[1],isClose)

;------------------------------ Execute the selected task --------------------------------

            if isRongZiSelected
                user.Rongzi(RongziWhich)

            if isOpenBSSelected
                user.OpenBusinessSkill()

            if isPlayTurnTableSelected
            {
                if isLoginagain
                {                    
                    if (user.ReloadGame() = 0)
                        Continue
                }                    
                user.ZhuanPan(TurnTableTimes,isbuyTimespeed)                
            }

            if isHunterSelected
                user.Hunter(0)

            if isLandSelected
                user.GetLand()

            if isZhuZiSelected
                user.Zhuzi(zhuziWhich)

            if isShoppingSelected
                user.Shopping(ShoppingAtWhich)

            if isCaiTuanSelected
                user.GetCaiTuan()

            if isCalRZSelected
                user.CalcRongZi()

            if isShareSelected
                user.GetCard(2)

            if isCardSelected
                user.GetCard(300)

            user := ""
        }
    }

;------------------------------ End Recording --------------------------------

    if isRecordingOnSelected
        GameRecordingOff()

;----------------------------- Reset some controls -----------------------------

    GuiControl,, Tips,
    GuiControl,, TimeStart,
    GuiControl,Enable, TimeStart
    GuiControl,Enable, BtnCreateTask
    GuiControl,Disable, BtnStopTask
    GuiControl,Disable, BtnPauseTask

Return

;=================================================== Control events ====================================================

MyListView:                             ;双击用户列表，登陆用户，并修改窗口名称
if (A_GuiEvent = "DoubleClick")
{
    LV_GetText(userName, A_EventInfo,1)  ; Get the text from the row's first field.
    LV_GetText(gameID, A_EventInfo,2)    ; Get the text from the row's second field.
    if (userName = "eight" or userName = "steve" or userName = "dq" or userName = "boy")
        LaunchQHGamePri(userName,gameID)
    else if (userName = "LDGame")
        new LDGame(0)
    else if (userName = "YQXGame")
        new YQXGame(0)
    else if (userName = "6322Game")
        new 6322Game(0)
    else if (userName = "all")
    {
        LaunchLDGames()
        
        new QHUser("eight",0)
        new QHUser("boy",0)
        new QHUser("dq",0)
        new QHUser("steve",0)
        new 4399UserTask("song",0)
        new 4399UserTask("long",0)
        new 4399UserTask("sf06",0)
        new 4399UserTask("yun",0)
        new 4399UserTask("supper",0)
    } 
    else if (userName = "allzz")
    {
        LaunchLDGames()
        
        new QHUser("eight",0)
        new QHUser("boy",0)
        new QHUser("dq",0)
        new QHUser("steve",0)
        new 4399UserTask("song",0)
        new 4399UserTask("long",0)
        new 4399UserTask("sf06",0)
        new 4399UserTask("yun",0)
        new 4399UserTask("supper",0)
        new 4399UserTask("xxhz",0)
    }     
    else if (userName = "allld")
    {
        LaunchLDGames()
    }             
    else if (userName = "allqh")
    {        
        new QHUser("eight",0)
        new QHUser("boy",0)
        new QHUser("dq",0)
        new QHUser("steve",0)
    }
    else if (userName = "all4399")
    {
        new 4399UserTask("song",0)
        new 4399UserTask("long",0)
        new 4399UserTask("sf06",0)
        new 4399UserTask("yun",0)
        new 4399UserTask("supper",0)
    }        
    else if (userName = "allclose")
    {
        WinClose, ahk_exe 360Game.exe
        WinClose, eight
        WinClose, xxsf
        WinClose, boy
        WinClose, steve
        WinClose, dq

        WinClose, song
        WinClose, long
        WinClose, sf06
        WinClose, yun
        WinClose, supper
        WinClose, xxhz

        WinClose, LDPlayer
        WinClose, YQXPlayer
        WinClose, 6322Player
        WinClose, RealYQXPlayer

    }   
    Else
        Launch4399GamePri(userName,gameID)
}
return

OpenLog:                                    ;打开日志文件
    FormatTime, Dayfolder,, yyyyMMdd        
    run % A_ScriptDir . "\log\"
    sleep 500
    run % A_ScriptDir . "\log\" . Dayfolder .  "_log.txt"
return

OpenPic:                                    ;打开商店列表
    run % A_ScriptDir . "\img\ShoppingList.png"
return

OpenSpy:
    run % A_ScriptDir . "\Lib\WindowSpy.ahk"
return

OpenNoSleep:
    run % A_ScriptDir . "\NoSleep.exe"
return

RunVSCode:
    run "C:\Users\keven\AppData\Local\Programs\Microsoft VS Code\Code.exe"
return

RunSF:
    run % A_ScriptDir . "\SF_Daily.ahk"
return

RunSP:
    run % A_ScriptDir . "\SP_Daily.ahk"
return

RunSZ:
    run % A_ScriptDir . "\SZ_Daily.ahk"
return

GuiPause:
    Pause   
return

GuiEscape:
GuiClose:
    ExitApp

Reloading:
    Reload
return

F7::Pause   ;pause the script
F8::ExitApp ;stop the script
F12::Reload ;Reload the script
