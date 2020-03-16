#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#Persistent  ; Keep running regardless return
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk

logfilename := % "E:\\AhkScriptManager-master\\log\\ZhuanPan" . A_now  . ".txt"

LogToFile("Log started, 4399ZhuanPan.ahk")

winName := ""
winName := (%1% ="") ? "xiaoxiaoshoufu" : %1% 

CoordMode, Pixel, window  
CoordMode, Mouse, window

try
{	
	IfWinExist %winName%
	{
		WinActivate %winName%
		sleep 200
		CaptureScreen()	
		CloseAnySubWindow()
		LogToFile("CloseAnySubWindow")
		sleep 100
		SuanKai() 	
		LogToFile("SuanKai() done")	
		sleep 200

		click 88, 896
		sleep 200
		WaitPixelColorAndClickThrowErr("0xD1762",505, 387,2000) ;ZhuanPan
		n=1  ; 10 x n times
		while (n<8)
		{

			WaitPixelColorAndClickThrowErr("0xF4452A",395,746,2000) ;Ten Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",398, 267,5000) ;Finished once
			sleep 200
			click 398, 267
			sleep 300
			click 453, 388  ;Close double money window if any.
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

