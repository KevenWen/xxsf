#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#Persistent  ; Keep running regardless return
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk
;SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

winName := ""
winName := (%1% ="") ? "xiaoxiaoshoufu" : %1% 

;logfilename := % "E:\\AhkScriptManager-master\\log\\ShangZhanReport" . A_now . ".txt"
;LogToFile("Log file started...")

Try 
{
	WinClose, %winName%
	sleep 200
	Launch4399Game(25,winName)
	WinActivate, %winName%
	sleep 1500

	;Take a look the order list
	;CaptureScreen()		
	sleep 1000
	;MouseClickDrag, Left, 326, 676,326,326,80
	click 425, 896 ;Order button
	sleep 500
	Click 82, 707 ;ShangHui button
	sleep 500
	CaptureScreen()
	sleep 500
	CaptureScreen()	;the first 11 entry	
	sleep 1000
	CaptureScreen()	;the first 11 entry	again
	MouseMove, 326, 676
	sleep 1000
	MouseClickDrag, Left, 326, 676,326,326,50
	sleep 2000
	mousemove 557, 398
	CaptureScreen()		;the seconrd entries
	sleep 1000			
	MouseClickDrag, Left, 326, 676,326,326
	sleep 2000			
	mousemove 557, 398
	CaptureScreen()		;the third entries
	sleep 2000


	click 361, 891 ;shanghui button
	sleep 1000

	;Take a look the zhuzi/shop/ZhuZi list
	click 447, 267 ;RongZi button
	sleep 1000
	CaptureScreen()	
	sleep 500	
	runwait "CalculateRZ.ahk"
	sleep 1000	

	;Take a look the zhuzi/shop/ZhuZi list
	click 339, 274 ;shop button
	sleep 1000
	CaptureScreen()	
	sleep 500	
	CaptureScreen()	
	sleep 1000	

	;Take a look the zhuzi/shop/ZhuZi list
	click 233, 267 ;Open the ZhuZi list
	PixelColorExist("0xFFF8CE",315, 333,2000)
	sleep 200
	CaptureScreen()	
	sleep 200
	MouseClickDrag, Left, 302, 853,304, 483
	sleep 500
	CaptureScreen()		
	sleep 500
	MouseClickDrag, Left, 302, 853,304, 483
	sleep 500
	CaptureScreen()		
	sleep 1000			

	;Take a look the shangzhan process
	click 361, 891 ;shanghui button
	sleep 1000
	CaptureScreen()		
	sleep 2000
	if PixelColorExist("0xFFF8CE",121, 471,10) ;ShangZhang Button not exist
		throw "Shangzhnag not start yet!"

	click 120, 464 ;shangzhang button
	sleep 1000
	CaptureScreen()		
	sleep 180000
	Loop
	{	CaptureScreen()		
		sleep 2000

		if PixelColorExist("0xFFFFF3",417, 474,10)
			break  ; Check if End
		if (A_Index > 35)
			break ; if timeout	

		sleep 90000
	}
}
Catch e
{
	;log.addLogEntry(e)
}
Finally 
{
	CaptureScreen()		
	sleep 2000
	MadeGif("ShangZhan")
	sleep 1000
	FileMove, E:\\AhkScriptManager-master\\log\\gif_output\\*.gif, E:\\AhkScriptManager-master\\log\\homebackup
}

ExitApp




