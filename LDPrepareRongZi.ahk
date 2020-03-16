#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include LDFunctions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

if (A_Args[1] = "" or not A_Args[2]="")
    ExitApp

winTitle := "ldxxsf"   ;Title need change after launch
RZCom := A_Args[1]      ;Which company

logfilename := % "E:\\AhkScriptManager-master\\log\\LDPrepareRongZi" . winTitle . A_now  . ".txt"

LogToFile("Log started, LDPrepareRongZi.ahk ")
LogToFile("winTitle := " winTitle)
LogToFile("RZCom := " RZCom)

global HB := ["43, 979","123, 979","203, 979","283, 979","363, 979","423, 979"]             ; home buttons
global SB := ["100, 250","210,250","330,260","450,250"]                                     ; shanghui buttons
global BC := ["130, 420","380, 420","280, 585","180, 740","400, 740"]                       ; 5个企业 coordinates
global PopWin := {okbtn: "300, 630", clobtn: "496, 247"}                                    ; Pop out window button positions
global RZWin := {rzarea: "188, 602", yesbtn: "330, 602", chezibtn: "440, 602"}               ; RongZi window positions
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times

loop 3  ;Try 3 times
{
    Try    
    {
        IfWinNotExist, %wintitle%
        {
            LaunchLDGame()
            ExitApp
        }

        IfWinExist, %wintitle%
        {
            WinActivate %wintitle%            
            sleep, % s["short"]

            if PixelColorExist("0xB0B0B0",500,250,100) ;Already prepared 
            {
                LogToFile("Already prepared!")
                ExitApp	 
            }
            
            sendinput {p}
            ;runwait "C:\ChangZhi\LDPlayer\ld.exe" -s 0 input keyevent KEYCODE_P,, Hide
            ;runwait "C:\ChangZhi\LDPlayer\ld.exe" -s 0 input tap 460 572,, Hide
            ;Send {p}
            ExitApp
            sleep 8000
        ;runwait "C:\ChangZhi\LDPlayer\ld.exe" -s 0 input keyevent P,, Hide

        }
    }
    catch e
    {
        LogToFile("Opps exception happens! times: " A_index e)	
        CaptureScreen()    
        WinClose, %wintitle%
        Continue        
    }

    if !PixelColorExist("0xFBFBFB",474, 395,100) ;Double check
    {
        LogToFile("Double check failed!")	
        CaptureScreen()    
        WinClose, %wintitle%
        Continue
    }
    else
    {
        LogToFile("PrepareRongZi done for:" winTitle)
        Break
    }    
}

sleep, % s["longer"]
LogToFile("Log ended.")    
ExitApp

;Functions:


F10::Pause   ;pause the script
F11::ExitApp ;stop the script
;Functions:
