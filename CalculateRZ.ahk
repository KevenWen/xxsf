#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include Functions.ahk

;ResizeWindow()

CoordMode, Pixel, window  
CoordMode, Mouse, window

logfilename := % logPath . "\\CalculateRZ" . A_now  . ".txt"

LogToFile("Log started, CalculateRZ.ahk")


global HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
global SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons
global BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                       ; 企业 coordinates
global TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                       ; Tooltip positions
global Arrayhome := {okbtn: "324, 602", kejicomp: "690,519", clobtn: "480, 266"}            ; button positions
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times
global Bvals := ["1621 353 1701 370","1624 379 1697 396","1626 457 1665 472"]               ; 企业加成的三个值的coordinates
global Totalpercent := 0        ;所在商会所有企业总加成
global Totalcount := 0          ;所在商会融资总注数
global TotalpercentAll := 0     ;本服所有企业总加成
global TotalcountAll := 0       ;本服融资总注数
global CloseAtEnd := 0          ;whether close the script, if started by this script then close it.

IfWinNotExist, xiaoxiaoshoufu
{
    Launch4399Game(25,"xiaoxiaoshoufu")
    CloseAtEnd := 1
}

IfWinExist xiaoxiaoshoufu
{
    WinActivate xiaoxiaoshoufu
	Winmove,xiaoxiaoshoufu,,829,23,600,959
    sleep, % s["short"]
    click % HB[5]
    sleep, % s["short"]
    click % SB[4]
    sleep, % s["long"]
    gosub CalandShow4399
    sleep, % s["short"]
    ToolTip, % "Total:" . "`r`n"
    . "+" . Round(TotalpercentAll) . "% / " . TotalcountAll . ", " . Round(TotalpercentAll / TotalcountAll,4) . "`r`n"    
    . "+" . Round(Totalpercent) . "% / " . Totalcount . ", " . Round(Totalpercent / Totalcount,4) . "`r`n"
    , 223, 337, 6
    sleep, % s["long"]
    CaptureScreen()
    sleep, % s["longest"]
    CaptureScreen()
}

if (CloseAtEnd = 1)
{
    WinClose, %winName%
    sleep, % s["long"]
    WinClose, 360游戏大厅
    FileMove, % logPath . "\\*.png", % logPath . "\\rongzitrack",1
}    

LogToFile("CalculateRZ task done!")	
sleep, % s["longer"]
LogToFile("Log ended.")    
ExitApp

;Functions:
CalandShow4399:
loop 5
    {
        ;v22： 商会融资占股， 第二行数值， 百分比
        ;v21： 企业总赚钱速度加成， 第一行数值，百分比
        ;v23： 商会占有股份数， 第五行（最后一行）数值
        click, % BC[A_index]
        MouseMove, 0,0
        sleep, % s["longer"]

        RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1630 379 1694 396" "--clipboard",, Hide ;商会融资占股百分比
        sleep, % s["longer"]
        v22 := StrReplace(StrReplace(Clipboard, " "), "%")   ;remove the % and space
        v22 := StrReplace(StrReplace(v22,"O","0"),"o","0")   ;remove the O / o 
        LogToFile(v22)
  
        v22 /= 100.0
        LogToFile(v22)
        ;MsgBox, % v22
        if v22=0  ; 如果当前企业没有融资，跳过到下一个企业
        {
            click 486, 265
            sleep, % s["short"]
            Continue
        }

        RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1648 352 1675 369" "--clipboard",, Hide ;企业总赚钱速度加成
        sleep, % s["longer"]
        v21 := StrReplace(StrReplace(StrReplace(Clipboard, " "), "+"),"%")
        v21 := StrReplace(StrReplace(v21,"O","0"),"o","0") ;remove the O / o
        LogToFile(v21)
        v21 += 0.0
        LogToFile(v21)


        if PixelColorExist("0xFFFEF5",446, 441,10)          ;融资份数0
            RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1632 457 1659 470" "--clipboard",, Hide   ;商会占有股份
        else if PixelColorExist("0xFFFEF5",451, 442,10)     ;融资份数两位数
            RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1632 457 1664 470" "--clipboard",, Hide
        Else                                                ;融资份数三位数
            RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1632 457 1668 470" "--clipboard",,Hide

        sleep, % s["longer"]        
        v23 := StrReplace(Clipboard, " ")
        v23 := StrReplace(StrReplace(v23,"O","0"),"o","0") ;remove the O / o
        LogToFile(v23)
        v23 += 0.0
        CurrentTotal := Round(v23 / v22)    
        Totalcount += Round(v23)
        Totalpercent += (v21 * v22)
        TotalcountAll += CurrentTotal
        TotalpercentAll += v21        

        click 486, 265
        sleep, % s["short"]
        TTCo := StrSplit(TT[A_index],",")
        ToolTip, % "+" . Round(v21) . "% / " . CurrentTotal . "`r`n"  ; The total number and percent
        . "+" . Round(v21 * v22) . "% / " . Round(v23) . ", " . Round(v21 * v22 / v23,4) . "`r`n"   ; How much we takes    
        . "+-38: +" . Round(v21 * (v23 + 38.0) / (CurrentTotal + 38.0) - v21 * v22,1) . "%, -"  ; If add / remove 38, waht's the change
        . ((v23 < 38.0)?Round(v21 * v22):Round(v21 * v22 - v21 * (v23 - 38.0) / (CurrentTotal - 38.0),1)) . "%" ;if the value minus big than current value,just show current
        , TTCo[1], TTCo[2]
        , A_index
    }
return
