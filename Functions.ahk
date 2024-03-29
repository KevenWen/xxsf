﻿#SingleInstance, Force
SetBatchLines, -1
;SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.

global 4399GamePath = ""
global LDGamePath = ""
global LDExePath = ""
global gifskipath = ""
global emailPSFilePath = ""
global logPath = ""
global i_viewpath = ""
global recorderpath = ""
global logArchivePath = ""
global UserIni = ""
global UserIniRemote = ""
global BaiduNetDiskPath = ""

global idTable := {}
global numTable := {}


IniRead, logPath, config.ini, path, logPath
IniRead, logArchivePath, config.ini, path, logArchivePath
IniRead, emailPSFilePath, config.ini, path, emailPSFilePath
IniRead, LDGamePath, config.ini, path, LDGamePath
IniRead, LDExePath, config.ini, path, LDExePath
IniRead, 4399GamePath, config.ini, path, 4399GamePath
IniRead, gifskipath, config.ini, path, gifskipath
IniRead, i_viewpath, config.ini, path, i_viewpath
IniRead, recorderpath, config.ini, path, recorderpath
IniRead, BaiduNetDiskPath, config.ini, path, BaiduNetDiskPath
IniRead, UserIni, config.ini, path, UserIni
IniRead, UserIniRemote, config.ini, path, UserIniRemote

IniRead, content, config.ini, users/num                 ;取用户信息，显示于taskui界面上
Loop, Parse, Content, `n, `r
{

    ; ignore all commented lines
    If RegExMatch(A_LoopField, "^\s*;")
        Continue

    ; split the line into $Key and $Value
    RegEx := "^(?P<Key>[^=]*?)=(?P<Value>.*)"
    If RegExMatch(A_LoopField, RegEx, $)
    {
        IDZS := StrSplit($Value,"/")
        idTable[$Key] := IDZS[1]
        numTable[$Key] := IDZS[2]
    }
}

global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times

global	HB := ["70, 910","145, 910","225, 910","305, 910","380, 910","445, 910"]            ; home buttons
global	SB := ["120, 260","200,260","280,260","360,260"]                                            ; shanghui buttons
global	BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                              ; 5个企业 coordinates
global	TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                              ; Tooltip positions
global	PopWin := {okbtn: "324, 608", clobtn: "480, 266",qhclobtn: "500, 266",zhuziok: "507, 320"}  ; button positions
global	RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}                      ; 融资的按钮
global  StockPos := ["155, 415","310, 415","460, 415"]                       		                ; 注资的三个框
global	OpenSJList := ["403, 330","403, 444","403, 675","403, 753"]
global	OpenSJListLD := ["420, 325","420, 450","420, 720","420, 810"]
global  LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
global  Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn_2: "798, 692", btn3: "522, 633"        ; RDP click OK buttons
        , btn_3: "522, 692", btn4: "253, 622", btn_4: "253, 692"}       ; btn1 肉沫茄子 btn2 - btn4 4399,前一个窗口刚好挡住下一个的确认两个字。

PixelColorExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor = p_DesiredColor )
        {
            sleep 50
            Return 1            
        }    
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}

PixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor != p_DesiredColor )
        {
            sleep 100
            Return 1            
        } 
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}

WaitPixelColor(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=1000) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB
        If ( ErrorLevel )
            throw, % "WaitPixelColor conduct has error, desired color: " . p_DesiredColor
        If ( l_OutputColor = p_DesiredColor )
        {
            sleep 100
            Return 1            
        } 
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
        {
            Mousemove %p_PosX%, %p_PosY%
            throw, % "WaitPixelColor has error, desired color: " . p_DesiredColor . ", now color: " . l_OutputColor
        }

    }
}

WaitPixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB
        If ( ErrorLevel ) ;Not found 
			throw, % "WaitPixelColorNotExist conduct has error, desired color:" . p_DesiredColor
        If ( l_OutputColor = p_DesiredColor ) ;Still found
            sleep 50 ;same
		Else
			break	;not same
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut) ;Timeout
  			throw, "WaitPixelColorNotExist has error, desired color:" . p_DesiredColor
    }
}

WaitPixelColorAndClick(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10,wtime=100) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
        If ( ErrorLevel )
            Return 1
        If ( l_OutputColor = p_DesiredColor )
			{
			Mousemove %p_PosX%, %p_PosY%
			sleep 50	
			click
			sleep %wtime% 
			Return 0
			}
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 2 
    }
}

WaitPixelColorAndClickThrowErr(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=1000) 
{
    l_Start := A_TickCount	
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
        If ( ErrorLevel )
				Throw, % "WaitPixelColorAndClickErrorLevel conduct, desired color:" . p_DesiredColor

        If ( %l_OutputColor% = %p_DesiredColor% )
            {
				Mousemove %p_PosX%, %p_PosY%
				sleep 50	
				click 
				return
			}
		Else
			sleep 20

        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
				Throw, % "WaitPixelColorAndClickTimeOut, desired color:" . p_DesiredColor
    }
}

CaptureScreen()
{
    if !FileExist(i_viewpath)
        return
	try
	{
        ifWinExist,IrfanView            ;If run too often, may have load exe error
            WinClose, IrfanView
        Process, Exist, i_view64.exe ; check to see if iTeleportConnect is running
        If (ErrorLevel = 0) ; If it is not running
        {
            FormatTime, Dayfolder,, yyyyMMdd
            path := % A_ScriptDir . "\\log\\" . Dayfolder . "Screens\\" . A_now . ".png"
            Run, % i_viewpath . " /capture=3" . " /convert=" . path		
            LogToFile("Screen")
        }
        Else ; If it is running, ErrorLevel equals the process id for the target program (Printkey). Then do nothing.
        {
            WinClose, IrfanView       
            throw "i_viewpath still running."
        }
	}
	catch e
	{
		;Ignore the error here.
		LogToFile("Screen captured failed: " . e)
        WinClose, IrfanView        
	}
}

CaptureScreenAll()
{
    if !FileExist(i_viewpath)
        return
	try
	{
        FormatTime, Dayfolder,, yyyyMMdd
		path := % logPath . "\\" . Dayfolder . "Fullscreens\\" . A_now . ".png"
		Run, % i_viewpath . " /capture=0" . " /convert=" . path
        LogToFile("Full Screen")
	}
	catch e
	{
		;Ignore the error here.
		LogToFile("Full Screen captured failed: " . e)
	}

}

MadeGif(named="unknown")
{
	try
	{
		FormatTime, Dayfolder,, yyyyMMdd
        path := % logPath . "\\" . Dayfolder . "Screens\\"
		FileMove,  % logPath . "\\gif_output\\*.gif", % logPath . "\\Arch_gif", 1
		name := % logPath . "\\gif_output\\" . named . "_" . A_now . ".gif"
		Runwait, % gifskipath . " " . path . "\\*.png --quality 90 -W 400 -H 640 --fps 1 -o " . name . " --fast"
		;FileMove, % logPath . "\\*.png", % logArchivePath . "\\Arch", 1
	}
	catch e
	{
		;Ignore the error here.
		LogToFile("MadeGif exception: " . e)
	}
}

GameRecordingOn()
{
    if !FileExist(recorderpath)     ;if not installed game recorder, do nothing.
        return
	try
	{
        Run, % recorderpath
        loop
        {
            IfWinActive, ahk_class TfrmMain
                break
            if A_index > 10
                throw, "Run game recorder time out!"
            sleep 1000
        }
        sleep 200
        send {F9}
        sleep 200
        WinMinimize, ahk_class TfrmMain ;minimize the TfrmMain window
        LogToFile("Game Recording On.")
	}
	catch e
	{
		;Ignore the error here.
        CaptureScreen()
        sleep 200
		LogToFile("Game recording turn on failed: " . e)
	}
}

GameRecordingOff()
{
    Process, Exist, gamerecorder.exe ; check to see if gamerecorder.exe is running
    If (ErrorLevel = 0) ; If it is not running
        LogToFile("Turn Recording Off but not find related window.")
    Else ; If it is running, ErrorLevel equals the process id for the target program (Printkey). Then do nothing.
    {
        send {F11}
        sleep 2000
        Process, Close, gamerecorder.exe
        LogToFile("Game Recording Off.")
    }
}

SendAlertEmail()
{
	Run "powershell.exe" -ExecutionPolicy Bypass -File %emailPSFilePath%
}

SendSlackEmail()
{
	;run "E:\AhkScriptManager-master\libblat.exe" -body "See Attached file" -attach "C:\Users\kwen\Downloads\output.txt" -subject "New SR was raised in the last xx hours" -to "q4q3m9g3r6f7u1d1@quest.slack.com" -server relay.quest.com -f SRNotification@quest.com
	run "E:\AhkScriptManager-master\lib\blat.exe" -body "testing" -subject "New SR was raised in the last xx hours" -to "keven.wen@quest.com" -server relay.quest.com -f SRNotification@quest.com
}

LogToFile(TextToLog)
{
    try{
    FormatTime, CurrentDateTime,, HH:mm:ss
    FormatTime, Dayfolder,, yyyyMMdd
    if TextToLog = ""
        FileAppend, % "`n", % A_ScriptDir . "\\log\\" . Dayfolder .  "_log.txt"
    Else
        FileAppend, % CurrentDateTime . ": " . TextToLog . "`n", % A_ScriptDir . "\\log\\" . Dayfolder .  "_log.txt"
    }
    catch e {
        ;Nothing need do here
    }
}

IsItemInList(item, list, delim="")			;Return if a var in the list, mainly use to read days from config.ini
{
   delim := (delim = "") ? "," : delim
   Loop, Parse, list, %delim%
   {
      if (A_LoopField = item)
         return true
   }
   return false
}

RongZiOKEmu()
{
    For index,value in  ["song","hou","xhhz","supper","long","yun"]
    {
        IfWinExist %value%
        {
            WinActivate %value%
            sleep, % s["short"]
            click % PopWin["okbtn"]
            sleep, % s["short"]
            click % PopWin["okbtn"]
        }   
    }
}
UploadNetDisk()
{
    if !FileExist(BaiduNetDiskPath)
    return
    Run, % BaiduNetDiskPath
    sleep 600000
    Process, close, baidunetdisk.exe
}

Launch4399GamePri(windowname,Sequ)
{
    IfWinExist %windowname%
    {
        WinActivate %windowname%
        Return
    }

    run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
    Loop
    {
        sleep 1000
        WinGetActiveTitle, Title
        if InStr(Title, "xiaoxiao")
        {
            WinSetTitle,%Title%,, %windowname%
            Winmove,%windowname%,,829,23,600,959
            ToolTip, % "Game Opened for sequ: " . Sequ, 0,0
            sleep 1000
            ToolTip
            return	
        }
        if (A_index > 8)
        {
            MsgBox, "No active windows named xiaoxiaoshoufu. " 
            return
        }        
    }		
}

LaunchQHGamePri(windowname,Sequ)
{
    IfWinExist %windowname%
    {
        WinActivate %windowname%
        Return
    }

    run %4399GamePath% -action:opengame -gid:4 -gaid:%Sequ%
    Loop
    {
        sleep 1000
        WinGetActiveTitle, Title
        if InStr(Title, "xxsf")
        {
            WinSetTitle,%Title%,, %windowname%
            Winmove,%windowname%,,829,23,600,959
            ToolTip, % "Game Opened for sequ: " . Sequ, 0,0
            sleep 1000
            ToolTip
            return	
        }
        if (A_index > 8)
        {
        MsgBox, "The active windows is not named xxsf" 
        return
        }        
    }    
}

	LaunchLDGames()
	{
		;qieziroumo
		run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan"
        sleep 3000
        WinWait, LDPlayer
        ; Move the window found by WinWait to the upper-left corner of the screen.
        WinMove, 12,9
        sleep 1000 
		;duwoxing
		run %LDGamePath% launchex --index 1 --packagename "com.dh.flash.game.minigame"
        WinWait, YQXPlayer
        WinMove, 360,9
        sleep 1000
		;yuqianxuan
		run %LDGamePath% launchex --index 2 --packagename "com.tantanyou.sf"
        WinWait, 6322Player
        WinMove, 1300,9
        sleep 1000
		;6322
		run %LDGamePath% launchex --index 3 --packagename "com.dh.flash.game.minigame"
        WinWait, RealYQXPlayer
        WinMove, 817,9
        sleep 1000
	}

Getzhushu()
{
    WinGetActiveTitle, titlename
    if numTable[titlename] = ""
        return 16						;默认最低16注
    else
        return numTable[titlename]		;配置在ini文件里的注数
}

FTPUpload(srv, usr, pwd, lfile, rfile)
{
    static a := "AHK-FTP-UL"
    if !(m := DllCall("LoadLibrary", "str", "wininet.dll", "ptr")) || !(h := DllCall("wininet\InternetOpen", "ptr", &a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr"))
        return 0
    if (f := DllCall("wininet\InternetConnect", "ptr", h, "ptr", &srv, "ushort", 21, "ptr", &usr, "ptr", &pwd, "uint", 1, "uint", 0x08000000, "uptr", 0, "ptr")) {
        if !(DllCall("wininet\FtpPutFile", "ptr", f, "ptr", &lfile, "ptr", &rfile, "uint", 0, "uptr", 0))
            return 0, DllCall("wininet\InternetCloseHandle", "ptr", h) && DllCall("FreeLibrary", "ptr", m)
        DllCall("wininet\InternetCloseHandle", "ptr", f)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", h) && DllCall("FreeLibrary", "ptr", m)
    return 1
}

FTPDownload(srv, usr, pwd, rfile, lfile)
{
    static a := "AHK-FTP-DL"
    if !(m := DllCall("LoadLibrary", "str", "wininet.dll", "ptr")) || !(h := DllCall("wininet\InternetOpen", "ptr", &a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr"))
        return 0
    if (f := DllCall("wininet\InternetConnect", "ptr", h, "ptr", &srv, "ushort", 21, "ptr", &usr, "ptr", &pwd, "uint", 1, "uint", 0x08000000, "uptr", 0, "ptr")) {
        if !(DllCall("wininet\FtpGetFile", "ptr", f, "ptr", &rfile, "ptr", &lfile, "int", 0, "uint", 0, "uint", 0, "uptr", 0))
            return 0, DllCall("wininet\InternetCloseHandle", "ptr", h) && DllCall("FreeLibrary", "ptr", m)
        DllCall("wininet\InternetCloseHandle", "ptr", f)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", h) && DllCall("FreeLibrary", "ptr", m)
    return 1
}

; <========================  FTP  ===========================>

	iniFileSync(){
		try{
			LogToFile("Start to check remote task.")			
			FTPUpload("10.154.10.6", "", "", UserIni, "SF.ini")
            LogToFile("FTPUpload done.")
			loop 60
			{
				FTPDownload("10.154.10.6", "", "", "SP.ini", UserIniRemote) 
				if FileExist(UserIniRemote)
				{
                    LogToFile("UserIniRemote found, FTPDownload done, loop times: " . A_index)
                    break
                }
				sleep 1000
			}
            Return 1
		}
		Catch e{
		LogToFile("excetion while check remote task: " . e)
		}
	}

; <========================  Time  ===========================>

    WaitForTime(eTime, plusday=1) { 
    eTime := A_YYYY A_MM A_DD SubStr(eTime, 1 ,2) SubStr(eTime, 3 ,2) (SubStr(eTime, 5, 2) ? SubStr(eTime, 5, 2) : "00")
    if (A_Now > eTime and plusday)  ; if eTime is past, set for tomorrow at eTime
        eTime += 1, day
    TimeToSleep := eTime
    TimeToSleep -= A_Now, seconds
    Sleep, % TimeToSleep * 1000    
    FormatTime, current, A_Now, HHmmss ; optional - comment out if you don't need the current time returned
    Return, current
    }

    WaitTime(eTime, plusday=1) { 
    eTime := A_YYYY A_MM A_DD SubStr(eTime, 1 ,2) SubStr(eTime, 3 ,2) (SubStr(eTime, 5, 2) ? SubStr(eTime, 5, 2) : "00")
    if (A_Now > eTime and plusday)  ; if eTime is past, set for tomorrow at eTime
        eTime += 1, day
    TimeToSleep := eTime
    TimeToSleep -= A_Now, seconds
    Return, TimeToSleep
    }