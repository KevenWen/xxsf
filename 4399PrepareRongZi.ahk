#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
;RongZi: 肉沫茄子-5;  supper-4;  xxsf/8888-3; 02/song-2; yun-1;
;long-5;  xhhz-2;  hou-4; 茄子肉沫-1

; Phy 肉沫茄子-5; supper-4; hou-2; long-5;
; phy2 yun-1; xxsf/8888-3; 
; home  02/song-2; xhhz-4;

;Run command like:
;runwait "4399PrepareRongZi.ahk" "27" "supper" "4" "Y"
;runwait "4399PrepareRongZi.ahk" "27" "supper" "4" "Nocz_Y"

if (A_Args[1] = "" or A_Args[2]="" or A_Args[3]="")
    ExitApp

seq := A_Args[1]        ;launch sequnes
winTitle := A_Args[2]   ;Title need change after launch
RZCom := A_Args[3]      ;Which company
OnlyZZ = % (A_Args[4]="") ? "N" : A_Args[4]  ;Only need Zhu Zi, do not need cezhi, Nocz_Y or Y,Nocz_Y stand for no chezi

logfilename := % logPath . "\\4399PrepareRongZi" . winTitle . A_now  . ".txt"

LogToFile("Log started, 4933PrepareRongZi.ahk ")
LogToFile("seq := " seq)
LogToFile("winTitle := " winTitle)
LogToFile("RZCom := " RZCom)
global HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
global SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons
global BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                       ; 5个企业 coordinates
global TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                       ; Tooltip positions
global PopWin := {okbtn: "324, 602", clobtn: "480, 266"}           ; button positions
global RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times

loop 3  ;Try 3 times
{
    Try    
    {
        IfWinNotExist, %wintitle%
        {
            Launch4399Game(seq,winTitle)
            LogToFile("Started game.")
        }

        IfWinExist, %wintitle%
        {
            WinActivate %wintitle%
            Winmove,%wintitle%,,829,23,600,959
            sleep, % s["short"]
            CloseAnySubWindow()
            LogToFile("Game window Found.")
            click % HB[5]
            sleep, % s["short"]
            click % SB[4]
            PixelColorExist("0x91B65A",478, 345,2000)
            if not (OnlyZZ = "Nocz_Y")
            {
                CheZi()
                LogToFile("CheZi done.")
                sleep, % s["long"]
            }
            PreRongZi(RZCom)
            LogToFile("RZCom done.")
            sleep, % s["mid"]
        }
    }
    catch e
    {
        LogToFile("Opps exception happens! times: " A_index e)	
        CaptureScreen()    
        WinClose, %wintitle%
        Continue        
    }

    if !PixelColorExist("0xFBFBFB",462, 396,100) ;Double check
    {
        LogToFile("Double check failed!")	
        CaptureScreen()    
        WinClose, %wintitle%
        Continue
    }

    if (OnlyZZ = "Y" or OnlyZZ = "Nocz_Y") ; if need click ok, click ok then exit, Nocz_Y stand for no chezi.
        {
            LogToFile("Need click RongZiOK.") 
            gosub RongZiOK 
        }
    
    LogToFile("PrepareRongZi done for:" winTitle)
    Break
}

sleep, % s["long"]
LogToFile("Log ended.")
WinSet, AlwaysOnTop, off, %wintitle%    
ExitApp

;Functions:
PreRongZi(RZCom)
{
    click, % BC[RZCom]
    sleep, % s["long"]
    ; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
   ; TTCo := StrSplit(PopWin["rzarea"],",")
    mousemove, 200, 574
    sleep, % s["short"]
    if (A_Args[1] = 25)
        click,38
    else if (A_Args[1] = 24)
        click,40
    else if (A_Args[1] = 20)
        click,38   
    else if (A_Args[1] = 18)
        click,39
    else if (A_Args[1] = 27)
        click,40        
    else if (A_Args[1] = 26)
        click,38        
    else if (A_Args[1] = 19)
        click,16
    else if A_Args[1] in 21,22,23,35
        click,15
    else ExitApp
    sleep, % s["mid"]
    if !PixelColorExist("0xFFFFFF",254, 399,10) ;存在没有更多金币提示，problem here!
        Throw, "Not enough money warnning exist!"    

    sleep, % s["mid"]
    click % RZWin["yesbtn"]
}

RongZiOK:
{
    click % PopWin["okbtn"]
    sleep, % s["mid"]
    if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
        click % PopWin["clobtn"]
    
    CaptureScreen()   
    WinClose, %wintitle%
    LogToFile("Clicked RongZiOK.")	
}

CheZi()
{
    Loop 5
    {
        click % BC[A_index]
        sleep, % s["long"]
        if PixelColorExist("0xFBFBFB",480, 269,1000)   
        and PixelColorExist("0xFDFBF0",212, 573,10) 
        and PixelColorExist("0xFFFEF5",230, 574,10)     ;窗口打开，没有融资，带有0，且只有两个字符
        {
            click % PopWin["clobtn"]
            sleep, % s["long"]
            Continue 1
        }
        Else
        {
            LogToFile("Find cezi chuankou in " A_index)	
            click % RZWin["chezibtn"]
            sleep, % s["long"]
            click % PopWin["okbtn"] 
            sleep, % s["longer"]
            click % PopWin["clobtn"]
            LogToFile("Cezi done in " A_index)	
            sleep, % s["longer"]
            break 1
        }
    }
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script