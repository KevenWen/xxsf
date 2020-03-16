#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#Persistent  ; Keep running regardless return
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include QHFunctions.ahk

logfilename := % "E:\\AhkScriptManager-master\\log\\QHZhuanPan" . A_now  . ".txt"

LogToFile("Log started, QHZhuanPan.ahk")

winName := ""
winName := (%1% ="") ? "xxsf" : %1% 

CoordMode, Pixel, window  
CoordMode, Mouse, window

;LaunchqhGame()
;ExitApp
try
{	
	IfWinExist %winName%
	{
		WinActivate %winName%
		sleep 200
		CaptureScreen()	
		CloseQHSubWindow()
		LogToFile("CloseAnySubWindow")
		sleep 100
		SuanKaiQH() 	
		LogToFile("SuanKai() done")	
		sleep 200

		click 49, 880
		sleep 200
		WaitPixelColorAndClickThrowErr("0xD13020",594, 379,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n<7)
		{

			WaitPixelColorAndClickThrowErr("0xF4452A",435, 755,2000) ;Ten Times Button
			sleep 1000
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",434, 251,4000) ;Finished once
			sleep 200
			click 392, 301
			sleep 300
			WaitPixelColorAndClick("0xFBFBFB",489, 328,10) ;close卡片界面,if any.			
			sleep 100
			click 453, 423  ;Close double money window if any.
			sleep 200
			CaptureScreen()	
			n++  
		}
		sleep 1500
		CaptureScreen()	
	}
}
catch e
{
	CaptureScreen()		
	LogToFile("OOps, Exception happens!")	
	sleep 2000
}
Finally 
{
	CaptureScreen()		
	sleep 2000
	LogToFile("Log End.")	
	MadeGif("ZhuanPan")
	ExitApp
}
