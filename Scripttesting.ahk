﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include 4399UserTask.ahk
#include QHuserTask.ahk
#include LDGame.ahk
#include YQXGame.ahk
#include 6322Game.ahk
#include g4399ch.ahk
#include .\Lib\Chrome.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window
;msgbox, % mod(A_YDay,4)

; wb := ComObject("InternetExplorer.Application")
; wb.Visible := True
; wb.Navigate("Google.com")
; ;wb := IEGet()
; wb.Document.All.q.Value := "site:autohotkey.com tutorial"

;  exitapp

; password = Kalle
; password := Recoding(password)
; MsgBox, % password
; password := Recoding(password)
; MsgBox, % password
; ExitApp

; Recoding(Password)
; {
;    Loop, Parse, Password
;     Pass2 .=Chr(Asc(A_LoopField)^0x1004)
;    Return Pass2 
; }


; MsgBox("abcd")
run "E:\AhkScriptManager-master\Compiler\Ahk2Exe.exe"  /in "TaskUI.ahk" /out TaskUI.exe /icon "./img/home.ico"
run "E:\AhkScriptManager-master\Compiler\Ahk2Exe.exe"  /in "NoSleep.ahk" /out NoSleep.exe /icon "./img/i0.ico"
exitapp
;s := new 4399UserTask("song")

loop 5
{
    b := new QHUser("boy",0)
    WinActivate,boy
    sleep 500
    if !PixelColorExist("0xF4452A",166, 773,10)        
    {
        click 565, 382
        sleep 500        
    }
    click 166, 773
    sleep 3200
    ToolTip, startsearch....................., 10, 10
    PixelSearch, Px, Py, 105, 246, 517, 622, 0xC71A13, 3, Fast RGB
    ToolTip,, 10, 10
    if ErrorLevel
    {
        ;LogToFile("Red color is not found in in 120, 268, 474, 605")
        LogToFile("Red color is not found in 105, 246, 517, 6225")
        click 480, 256
        sleep 500
        continue        
    }
    else
    { 
        LogToFile("Find red color in x,y: " . Px . "," . Py)
        MouseMove, Px, Py

        if (Px < 230) and (Px > 140)
        {
            click 480, 256
            sleep 500
            continue
        }

        if (Px < 415) and (Px > 350)
        {
            click 480, 256
            sleep 500
            continue
        }

    }
/*
    click 463, 261
    sleep 500
    s.CloseGame()
    continue
*/
    sleep 2000
    CaptureScreen()
    Loop
    {
        if A_Index > 10
            break

        if !PixelColorExist("0xFBFBFB",479, 255,50)
        {
            b.CloseSpeSubWindow(1)
            sleep 300
        }
        else
            Break
        
        sleep 200
    }
    ;click 463, 259
}


    ;msgbox, % mod(A_YDay-1,2)
    ;run "E:\AhkScriptManager-master\Compiler\Ahk2Exe.exe"  /in "TaskUI.ahk" /out TaskUI.exe /icon "./img/i1.ico"
    ;run "E:\AhkScriptManager-master\Compiler\Ahk2Exe.exe"  /in "NoSleep.ahk" /out NoSleep.exe /icon "./img/i0.ico"
    ExitApp

SetTitleMatchMode 2

	baseURL  := "http://www.4399.com/flash/198091.htm#"
    URL4 := ["http://www.4399.com/flash/198091.htm#happy"
            ,"http://www.4399.com/flash/198091.htm#song"
            ,"http://www.4399.com/flash/198091.htm#sf06"
            ,"http://www.4399.com/flash/198091.htm#long"
            ,"http://www.4399.com/flash/198091.htm#yun"]
    URLs := ["http://www.4399.com/flash/198091.htm#happy"
            ,"http://www.4399.com/flash/198091.htm#song"
            ,"http://www.4399.com/flash/198091.htm#sf06"
            ,"http://www.4399.com/flash/198091.htm#long"
            ,"http://www.4399.com/flash/198091.htm#yun"
            ,"http://m.qunhei.com/game/login.html?gid=3626?88888"
            ,"http://m.qunhei.com/game/login.html?gid=3626?dq"
            ,"http://m.qunhei.com/game/login.html?gid=3626?boy"
            ,"http://m.qunhei.com/game/login.html?gid=3626?steve"]    
    URLss := ["http://m.qunhei.com/game/login.html?gid=3626?88888"
            ,"http://m.qunhei.com/game/login.html?gid=3626?dq"
            ,"http://m.qunhei.com/game/login.html?gid=3626?boy"
            ,"http://m.qunhei.com/game/login.html?gid=3626?steve"]    

    if (Chromes := Chrome.FindInstances())
    {
        ;MsgBox, chrome_is_Exist, please_close_first.
        ;ExitApp        
        ChromeInst := {"base": Chrome, "DebugPort": Chromes.MinIndex()}
    }
    else
    {
        ChromeInst := new chrome("E:\AhkScriptManager-master\ChromeData\U4399",URLss,"--user-data-dir=E:\AhkScriptManager-master\ChromeData")
        sleep 5000
    } 
    
    ifWinExist, 小小首富
    {
        CoordMode, Pixel, window  
        CoordMode, Mouse, window   

        WinActivate, 小小首富
        sleep 200
        ;Winset, AlwaysOnTop, On, 小小首富 
        ;WinGetPos, X, Y, W, H, 小小首富
        ;MsgBox,% X . Y . W . H
        MouseMove, 329, 563
        sleep 300	
        PixelColorExist("0x80C90D",329, 563,8000)			
        WinGetPos, X, Y, W, H, 小小首富	
        if not (W=609 and H=1006)
            Winmove,小小首富,,829,12,609,1006   
    }
    else
        throw "chrome not exit!"
        
    Winset, AlwaysOnTop, Off, 小小首富 

    ;exitapp
    sf06 := ChromeInst.GetPageByURL("sf06","contains") 
    /*
    if !IsObject(sf06)
    {
        p := ChromeInst.GetPage()
        p.Call("Target.createTarget", {url : "http://www.4399.com/flash/198091.htm#sf06" })
        p.Disconnect()
        sf06 := ChromeInst.GetPageByURL("sf06","contains")
        sf06.WaitForLoad()
        sleep 2000
    }
    */
    song  := ChromeInst.GetPageByURL("song","contains")
    long  := ChromeInst.GetPageByURL("long","contains")
    happy := ChromeInst.GetPageByURL("happy","contains") 
    yun   := ChromeInst.GetPageByURL("yun","contains")
    eight := ChromeInst.GetPageByURL("88888","contains")
    dq    := ChromeInst.GetPageByURL("dq","contains")      
    boy   := ChromeInst.GetPageByURL("boy","contains")      
    steve := ChromeInst.GetPageByURL("steve","contains")          

    started4399 := 0
    startedQH := 0
    Loop
    {
        for index,value in ["sf06","song","happy","long","yun"]
        {
            if (IsObject(%value%) and %value%.Connected and started4399 < 5)
            {
                %value%.call("Page.bringToFront")
                sleep 500                              
                if %value%.Login4399(value)
                {
                    %value%.Disconnected()
                    started4399 ++
                }
            }
            else
                Continue
        }

        for index,value in ["eight","dq","boy","steve"]
        {
            if (IsObject(%value%) and %value%.Connected and startedQH < 4)
            {
                %value%.call("Page.bringToFront")
                sleep 500                              
                if %value%.LoginQH(value)
                {
                    %value%.Disconnected()
                    startedQH ++
                }
            }
            else
                Continue              
        } 
        sleep 1000         
        if (started > 4 or A_Index > 20)
            Break
    }


ExitApp


  ;  run "E:\AhkScriptManager-master\Compiler\Ahk2Exe.exe"  /in "TaskUI.ahk" /out TaskUI.exe /icon "./img/i1.ico"
    ExitApp
    For index,value in ["sf01","sf03","sf04","sf05","yun","long","song"]
    {
        %value% := new 4399UserTask(value,0)
        %value%.ZhuZi(2)
    }

    For index,value in ["supper","sf06","song"]
        new 4399UserTask(value,0).ZhuZi(3)
    
    new QHUser("88888",0).ZhuZi(3)      

    For index,value in ["supper","yun","long","song","sf06"]
        new 4399UserTask(value).ZhuZi(1)

    For index,value in ["sf01","sf03","sf04","sf05","yun","long"]
        new 4399UserTask(value).ZhuZi(2)
    For index,value in ["sf01","sf03","sf04","sf05"]
        new 4399UserTask(value).RongZi(2)        
    
    new LDGame(0)
    new YQXGame(0)
    new 6322Game(0)

F7::Pause   ;pause the script
F8::ExitApp ;stop the script



