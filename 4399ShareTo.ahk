#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

Arrayflag = % (A_Args[1]="") ? "L" : A_Args[1]  ;ArraySeq value

logfilename := % logPath . "\\Cards" . A_now . ".txt"
LogToFile("Log file started...")
LogToFile("Params: " . A_Args[1])

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
if (Arrayflag = "L") 	;Part of the account
	IniRead, SeqList, config.ini, account, L
Else if (Arrayflag = "XXXL") 	;All the account
	IniRead, SeqList, config.ini, account, XXXL		
Else 
	SeqList :=""
ArraySeq := StrSplit(SeqList,",")

global LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
global winName := "xiaoxiaoshoufu"

For index, value in ArraySeq
{
	Try 
	{
		Gosub, PrepareGame
		Gosub, getScreen
		getCard()
		Gosub, getScreen
	}	
	Catch e
	{
		LogToFile(e)
	}
	WinClose, %winName%
	sleep 200
}

WinSet, AlwaysOnTop, off, %winName%	
LogToFile("Log end.")
WinClose, % winName
sleep 200
WinClose 360游戏大厅
MadeGif("Cards")
ExitApp

PrepareGame:
	IfWinNotExist, %winName%
	{
		Launch4399Game(value,winName)
	}
	Else
	{
		WinActivate, %winName%
		Winmove,%winName%,,629,23,600,959
		sleep 200
	}
	LogToFile("Launch4399Game done")
	sleep 200
Return

getCard()
{
	CloseAnySubWindow()
	click 246, 196	;gift pack button
	sleep 500

	Loop 120
	{
		if PixelColorExist("0x1657B0",288, 491,10)
		{
			click 288, 491  ;share everyday button
			sleep 1000
		}	
		if PixelColorExist("0xFCFEFE",347, 640,10) ;share immediately button
		{
			click 344, 640
			sleep 500
		}
		if PixelColorExist("0x5BD157", 285, 530,10) ;"share to" tip
		{
			click 414, 432
			sleep 200
		}
		if !PixelColorExist("0x97E2E4",327, 633,10)
		{
			CloseSpeSubWindow(1)
		}
		sleep 200
	}
	CloseAnySubWindow()
}

getScreen:
	sleep 1000
	CloseAnySubWindow()
	click 246, 196	;gift pack button
	sleep 300
	click 429, 577  ;card button
	sleep 500
	CaptureScreen()
Return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
