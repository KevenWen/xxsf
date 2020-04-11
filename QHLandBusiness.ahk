#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include QHFunctions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

global winName := "xxsf"

Try 
{
	Gosub, PrepareGame
	SendMode Event
	Dican()
	SendMode Input	
}
Catch e
	CaptureScreen()	

CaptureScreen()	
;WinClose, %winName%
sleep 200

WinSet, AlwaysOnTop, off, %winName%	
;MadeGif("LandBusiness")
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
Return

Dican()
{
	CloseAnySubWindow()
	click 131, 925
	PixelColorExist("0xFFFEF5",400, 182,1000)
	sleep 100
	SendMode Event
	loop 2
	{
		Mousemove,570, 840
		send {LButton down}
		Mousemove,570, 300,6
		sleep 100	
		send {LButton up}
		click 570, 840
		sleep 200
	}
	CaptureScreen()
	loop 15
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
			CaptureScreen()	
			click %Px%, %Py%
			sleep 200
			if PixelColorExist("0xFFFEF5",190, 480,1000) 
			{
				click,265, 465, 23 ;金币23
				sleep 100
				click,265, 530, 17 ;金币17
				sleep 100
				click,433, 530, 3 ;资源卡6
				sleep 100
				click,350, 594, 5  ;5份钻石注决策资源
				CaptureScreen()	
				sleep 100
				click 376, 723	;确认注入
				sleep 100
				if PixelColorExist("0xFBFBFB",478, 396,300) ;确认注入提示框
					click 305, 611 ;点击确定
				else
					throw "Exception while DiCcanJinzhu, not found OK button"
			}
			else
			{

			}
			sleep 200
			CaptureScreen()	
			break
		}
		sleep 200		
	}
	SendMode Input		
}


F10::Pause   ;pause the script
F11::ExitApp ;stop the script
