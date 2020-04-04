#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

if (A_Args[1] = "" or A_Args[2]="" or A_Args[3]="" or A_Args[4]="")
    ExitApp

; 3-yun, 1-long, 2-hou, 4-supper, 6-02/song		
seq := A_Args[1]        ;launch sequnes
winTitle := A_Args[2]   ;Title need change after launch
RZCom := A_Args[3]      ;Which company
;Order := A_Args[4]      ;Window order in the screen

if (A_Args[4] = 1)
    Order := [2,6]
else if (A_Args[4] =2)
    Order := [272,6]
else if (A_Args[4] = 3)
    Order := [545,6]
else
    ExitApp

loop 3  ;Try 3 times
{
    Try    
    {
        IfWinNotExist, %wintitle%
        {
            Launch4399Game(seq,winTitle)
        }

        IfWinExist, %wintitle%
        {
            WinActivate %wintitle%
            Winmove,%wintitle%,,Order[1],Order[2],600,959
            sleep, % s["short"]
            click % HB[5]
            sleep, % s["short"]
            click % SB[4]
            sleep, % s["longer"]
            gosub CheZi
            sleep, % s["short"]
            PreRongZi(RZCom)
            sleep, % s["long"]
        }
    }
    catch e
    {
        CaptureScreen()    
        WinClose, %wintitle%
        Continue        
    }

    if !PixelColorExist("0xFBFBFB",462, 396,100) ;Double check
    {
        CaptureScreen()    
        WinClose, %wintitle%
        Continue
    }
    else
    {
        Break
    }    
}

ExitApp

;Functions:
PreRongZi(RZCom)
{
    click, % BC[RZCom]
    sleep, % s["long"]
    ; 3-yun, 1-long, 2-hou, 4-supper, 6-02/song		
   ; TTCo := StrSplit(PopWin["rzarea"],",")
    mousemove, 200, 574
    sleep, % s["short"]
    if (A_Args[1] = 3)
        click,39
    else if (A_Args[1] = 1)
        click,38
    else if (A_Args[1] = 4)
        click,40
    else if (A_Args[1] = 6)
        click,37
    else if (A_Args[1] = 2)
        click,37
    else ExitApp
    sleep, % s["mid"]
    if !PixelColorExist("0xFFFFFF",254, 399,10) ;存在没有更多金币提示，problem here!
        Throw, "Not enough money warnning exist!"

    sleep, % s["long"]
    click % RZWin["yesbtn"]    
}

CheZi:
Loop 5
{
    click % BC[A_index]
    sleep, % s["long"]
    if PixelColorExist("0xFBFBFB",480, 269,1000)   
    and PixelColorExist("0xFFFEF5",212, 573,10) 
    and PixelColorExist("0xFFFEF5",230, 574,10)     ;窗口打开，没有融资，带有0，且只有两个字符
    {
        click % PopWin["clobtn"]
        sleep, % s["long"]
        Continue
    }
    Else
    {
        click % RZWin["chezibtn"]
        sleep, % s["long"]
        click % PopWin["okbtn"] 
        sleep, % s["longer"]
        click % PopWin["clobtn"]
        sleep, % s["longer"]
        Break   
    }
}
Return