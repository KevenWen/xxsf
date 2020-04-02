#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

Arrayflag = % (A_Args[1]="") ? "I" : A_Args[1]  ;ArraySeq value

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
if (Arrayflag = "I") 	;Part of the account
	IniRead, SeqList, config.ini, account, sharepart
Else if (Arrayflag = "II") 	;All the account
	IniRead, SeqList, config.ini, account, shareall		
Else 
	SeqList :=""
ArraySeq := StrSplit(SeqList,",")

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
		;LogToFile(e)
	}
	WinClose, %winName%
	sleep 200
}
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
		CloseSpeSubWindow(10)
		sleep 200
	}
Return

getCard()
{
	click 246, 196	;click 礼包 button
	sleep 500
	Loop 150		;循环180次，可按需要调整
	{	
		WaitPixelColorAndClick("0x1657B0",288, 491,10,1000) ;click 每日分享 button
		WaitPixelColorAndClick("0xFCFEFE",347, 640,10,500)  ;click 立即分享 button
		if PixelColorExist("0x5BD157", 285, 530,10) 		;close "分享到" 提示
		{
			click 414, 432
			sleep 200
		}
		if !PixelColorExist("0x97E2E4",327, 633,10)	;close 分享成功或拼图窗口
			CloseSpeSubWindow(1)
		sleep 200
	}
	CloseSpeSubWindow(30)	;关闭所有子窗口
}

getScreen:
	sleep 100
	click 246, 196	;gift pack button
	sleep 300
	click 429, 577  ;card button
	sleep 500
	CaptureScreen()
Return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
