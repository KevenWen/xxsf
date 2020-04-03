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
		Winmove,%winName%,,933,19,600,959		
		CloseAnySubWindow()
		sleep 200
	}	

	LogToFile("LaunchQHGame done")
	sleep 200
Return

Dican()
{
	CloseAnySubWindow()
	click 131, 925
	PixelColorExist("0xFFFEF5",400, 182,1000)
	sleep 100
	loop 2
	{
		Mousemove,570, 840
		send {LButton down}
		Mousemove,570, 300,3
		sleep 100	
		send {LButton up}
		click 570, 840
		sleep 400
	}
	CaptureScreen()
	loop 25
	{
		CloseAnySubWindow()
		ImageSearch, Px, Py, 113, 429, 504, 817, % A_ScriptDir . "\\blockofyellow.bmp"
		if (ErrorLevel = 2)  ;Execption when conduct the search
			throw "ImageSearch not work, please check." 		
		else if (ErrorLevel = 1) ;Image not found 
		{
			Mousemove,570, 824
			send {LButton down}
			Mousemove,570, 500,2
			send {LButton up}
			click 570, 824
			sleep 200
		}
		else if (ErrorLevel = 0) and !PixelColorExist("0x706B59",455, 284,10) ;Image found and not on the first line
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
	if PixelColorExist("0xFFFEF5",190, 480,1000) 
	{
		Mousemove,265, 465 ;金币23
		click, 23 
		sleep 100
		Mousemove,265, 530 ;金币17
		click, 17
		sleep 100
		Mousemove,433, 530 ;资源卡6
		click, 6
		sleep 100
		Mousemove,350, 594 ;5份钻石注决策资源
		click, 5		
		CaptureScreen()	
		sleep 100
		click 376, 723	;确认注入
		sleep 100
		if PixelColorExist("0xFBFBFB",478, 396,300) ;确认注入提示框
			click 305, 611 ;点击确定
		else
			throw "Exception while DiCcanJinzhu, not found OK button"
	}
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
