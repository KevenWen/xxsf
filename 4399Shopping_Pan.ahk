#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#Persistent  ; Keep running regardless return
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk

logfilename := % logPath . "\\Shopping-ZhuanPan" . A_now  . ".txt"

LogToFile("Log started, 4399Shopping_Pan.ahk")

winName := ""
;winName := (%1% ="") ? "xiaoxiaoshoufu" : %1% 
winName := (A_Args[1] ="") ? "long" : A_Args[1] 

CoordMode, Pixel, window  
CoordMode, Mouse, window

try
{	
	;IfWinNotExist, %winName%
	;	Launch4399Game(26,winName)	
		
	IfWinExist %winName%
	{
		WinActivate %winName%
		sleep 200
		CaptureScreen()	
		CloseAnySubWindow()
		;LogToFile("CloseAnySubWindow")
		sleep 100
		SuanKai() 	
		LogToFile("SuanKai() done")	
		sleep 200
		Gosub, StartShopping
		LogToFile("Shopping done")
		sleep 100
		;if (winName = "long")
			Gosub, StartZhuanPan					
		LogToFile("ZhuanPan done")

		sleep 500
		CaptureScreen()	
	}
}
catch e
{
	CaptureScreen()		
	LogToFile("OOps, Exception happens!")	
	sleep 1000
}
Finally 
{
	CaptureScreen()		
	sleep 100
	LogToFile("Log End.")	
	;MadeGif("Shopping")
	ExitApp
}

;Functions:
StartShopping:
	click 360, 896
	sleep 200
	WaitPixelColorAndClickThrowErr("0xFFFFFF",370, 260,2000) ;Shop button
	sleep 300

	if PixelColorExist("0x63B0FF",345, 474,100) ;1-3
	{
		click 345, 474
		sleep 300
		click 323, 593
		sleep 200		
		LogToFile("Shopping buy 1-3")				
	}

	if PixelColorExist("0x63B0FF",450, 474,100) ;1-4
	{
		click 450, 474
		sleep 300
		click 323, 593
		sleep 200	
		LogToFile("Shopping buy 1-4")				
	}


	if PixelColorExist("0x63B0FF",135, 474,100) or PixelColorExist("0x62AFFE",135, 474,100) ;Row 1-1
	{
		click 135, 474
		sleep 300
		click 323, 593 ;OK button	
		;click 462, 394	;Close button, for testing perpose	
		sleep 200			
		LogToFile("Shopping buy 1-1")		
	}

	if PixelColorExist("0x63B0FF",240, 600,100) ;2-2
	{
		click 240, 599
		sleep 300			
		click 323, 593
		sleep 200
		LogToFile("Shopping buy 2-2")				
	}		

	sleep 100
	CaptureScreen()	
return

StartZhuanPan:
	click 88, 896
	sleep 200
	WaitPixelColorAndClickThrowErr("0xD1762",505, 387,2000) ;ZhuanPan
	sleep 200
	n=1  ; 10 x n times
	while (n<7)
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
return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script