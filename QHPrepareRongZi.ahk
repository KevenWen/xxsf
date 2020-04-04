#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include QHFunctions.ahk

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
;RongZi: 肉沫茄子-5;  supper-4;  xxsf/8888-3; 02/song-2; yun-1;
;long-5;  xhhz-2;  hou-4; 茄子肉沫-1

; Phy 肉沫茄子-5; supper-4; hou-2; long-5;
; phy2 yun-1; xxsf/8888-3; 
; home  02/song-2; xhhz-4;

;Run command like:
;runwait "QHPrepareRongZi.ahk" "3" "Y"
;runwait "QHPrepareRongZi.ahk" "3" "Nocz_Y"

CoordMode, Pixel, window  
CoordMode, Mouse, window

if (A_Args[1] = "") ;Only need one argument to determine which company.
    ExitApp

winTitle := "xxsf"   ;Title need change after launch
RZCom := A_Args[1]      ;Which company
OnlyZZ = % (A_Args[2]="") ? "N" : A_Args[2]  ;Only need Zhu Zi, do not need cezhi, Nocz_Y or Y,Nocz_Y stand for no chezi

global HB := ["48, 909","130, 909","215, 909","300, 909","387, 909","465, 909"]             ; home buttons
global SB := ["75, 260","190,260","300,260","410,260"]                                      ; shanghui buttons
global BC := ["170, 420","420, 400","310, 560","220, 690","410, 690"]                       ; 5个企业 coordinates
global PopWin := {okbtn: "324, 602", clobtn: "507, 257"}                                    ; Pop out window button positions
global RZWin := {rzarea: "225, 570", yesbtn: "360, 570", chezibtn: "450, 570"}              ; RongZi window positions
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times

loop 3  ;Try 3 times
{
    Try    
    {
        IfWinNotExist, %wintitle%
        {
            LaunchqhGame()
        }

        IfWinExist, %wintitle%
        {
            WinActivate %wintitle%
            Winmove,%wintitle%,,933,19,600,959
            sleep, % s["short"]
            CloseAnySubWindow()
            sleep, % s["short"]          
            click % HB[5]
            sleep, % s["short"]
            click % SB[4]
            PixelColorExist("0x91B65A",478, 345,2000)
            if not (OnlyZZ = "Nocz_Y")
              CheZi()
            sleep, % s["long"]
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

    if !PixelColorExist("0xFBFBFB",480, 395,100) ;Double check
    {
        CaptureScreen()    
        WinClose, %wintitle%
        Continue
    }

    if (OnlyZZ = "Y" or OnlyZZ = "Nocz_Y") ; if need click ok, click ok then exit, Nocz_Y stand for no chezi.
        gosub RongZiOK 

    Break
 
}

sleep, % s["longer"]
WinSet, AlwaysOnTop, off, xxsf    
ExitApp

;Functions:
PreRongZi(RZCom)
{
    click, % BC[RZCom]
    sleep, % s["long"]
    ; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
   ; TTCo := StrSplit(PopWin["rzarea"],",")
    mousemove, 239, 570
    sleep, % s["short"]
    click,40
    sleep, % s["mid"]
    
    if !PixelColorExist("0xFFFFFF",121, 358,10) ;存在没有更多金币提示，problem here!
        Throw, "Not enough money warnning exist!"

    click % RZWin["yesbtn"]    
}

CheZi()
{
    Loop 5
    {
        click % BC[A_index]
        sleep, % s["long"]
        if PixelColorExist("0xFBFBFB",500, 265,1000)   
        and PixelColorExist("0xFFFEF5",216, 585,20) 
        and PixelColorExist("0xFFFEF5",235, 586,20)     ;窗口打开，没有融资，带有0，且只有两个字符
        {
            click % PopWin["clobtn"]
            sleep, % s["long"]
            Continue 1
        }
        Else
        {
            click % RZWin["chezibtn"]
            sleep, % s["long"]
            click % PopWin["okbtn"] 
            sleep, % s["longer"]
            click % PopWin["clobtn"]
            sleep, % s["longer"]
            Break 1 
        }
    }
}

RongZiOK:
{
    click % PopWin["okbtn"]
    sleep 500
    if PixelColorExist("0xFFFEF5",407, 444,5000) ;close the sub window if the first window closed
        click % PopWin["clobtn"]
    
    CaptureScreen()
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script