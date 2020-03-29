#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include QHFunctions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

logfilename := % "E:\\AhkScriptManager-master\\log\\LandBusiness" . A_now . ".txt"
LogToFile("Log file started...")
LogToFile("Params: " . A_Args[1])

global winName := "xxsf"

Try 
{
	Gosub, PrepareGame
	SendMode Event
	Dican()
	SendMode Input	
}
Catch e
{
	CaptureScreen()	
	LogToFile(e)
}
CaptureScreen()	
;WinClose, %winName%
sleep 200

WinSet, AlwaysOnTop, off, %winName%	
LogToFile("Footer text to appear at the very end of your log, which you are done with.")
MadeGif("LandBusiness")
WinClose, % winName
sleep 200
WinClose 360游戏大厅
ExitApp

PrepareGame:
	IfWinNotExist, %winName%
	{
		LaunchQHGame()
	}
	Else
	{
		WinActivate, %winName%
		Winmove,%winName%,,933,19,628,937		
		CloseAnySubWindow()
		sleep 200
	}	

	LogToFile("LaunchQHGame done")
	sleep 200
Return

Dican()
{
	CloseAnySubWindow()
	click 131, 899
	sleep 1000
	Mousemove,600, 825
	send {LButton down}
	Mousemove,600, 95,2
	send {LButton up}
	sleep 120
	click 600, 825
	sleep 400
	CaptureScreen()	
	loop 25
	{
		CloseAnySubWindow()
		ImageSearch, Px, Py, 113, 429, 504, 817, % A_ScriptDir . "\\blockofyellow.bmp"
		if (ErrorLevel = 2)  ;Execption when conduct the search
			throw "ImageSearch not work, please check." 
		else if (ErrorLevel = 1) ;Image not found 
		{
			Mousemove,600, 825
			send {LButton down}
			Mousemove,600, 375,2
			send {LButton up}
			click 600, 825
			sleep 200
		}
		else if (ErrorLevel = 0) ;Image found
		{
			LogToFile("Image found when loop times: " . A_Index)
			CaptureScreen()	
			click %Px%, %Py%
			sleep 200
			DiCcanJinzhu()
			sleep 200
			CaptureScreen()	
			LogToFile("Land business done, num is " . num)
			break
		}
		sleep 200		
	}
}

DiCcanJinzhu()
{
	if PixelColorExist("0xFFFEF5",207, 470,1000) 
	{
		Mousemove,275, 455 ;金币23
		click, 23 
		sleep 100
		Mousemove,275, 520 ;金币17
		click, 17
		sleep 100
		Mousemove,433, 516 ;资源卡6
		click, 6
		sleep 100
		Mousemove,360, 577 ;5份钻石注决策资源
		click, 5		
		CaptureScreen()	
		sleep 100
		click 390, 707	;确认注入
		sleep 100
		if PixelColorExist("0xFBFBFB",490, 391,300) ;确认注入提示框
			click 320, 597 ;点击确定
		else
			throw "Exception while DiCcanJinzhu, not found OK button"
	}
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
