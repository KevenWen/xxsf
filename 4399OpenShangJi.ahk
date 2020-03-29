#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#Include Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

logfilename := % logPath . "\\OpenShangJi" . A_now . ".txt"
LogToFile("Log file started...")
winName := "xiaoxiaoshoufu" ;wintitle

try
{	
	IfWinNotExist, %winName%
		Launch4399Game(27,winName)	
		
	IfWinExist %winName%
		{
			WinActivate %winName%
			Winmove,%winName%,,1229,23,600,959
			sleep 200
			CaptureScreen()
			CloseAnySubWindow()
			LogToFile("CloseAnySubWindow done")
			sleep 100

			WaitPixelColorAndClick("0xFF4841", 377, 909,1000) ; click shang hui button
			PixelColorExist("0xF7D7AD",194, 522,2000)
			CaptureScreen()
			sleep 200
			Loop
			{
				if PixelColorExist("0xA1FF3D",145, 561,100) ;Check if gray out, if not, click multiple times to refresh.
				{
					click 238, 269
					sleep 1000
					click 148, 267
					sleep 500 
				}
				else
				{
					LogToFile("Shangji is gray out now!")
					break
				}
			
				sleep 1000

				if (A_Index > 3)
					throw "Refresh 3 times but still not gray out"
			}
			CaptureScreen()
			LogToFile("Before first time open Shangji")
			sleep 200
			OpenSJ()
			LogToFile("After first time open Shangji")
			sleep 200
			CaptureScreen()
			sleep 1000
		}
}
catch e
{
	CaptureScreen()	
	LogToFile(e)
}

;Restart the Game to check if the shangJi is all opened:
Launch4399Game(27,winName)
LogToFile("Restart the game to check if all shangji Opened.")
sleep 1000
WaitPixelColorAndClick("0xFF4841", 377, 909,1000) ; click shang hui button
PixelColorExist("0xF7D7AD",194, 522,2000)
CaptureScreen()
sleep 200
;Check if gray out.

if (PixelColorExist("0xA1FF3D",144, 563,100) 
	and  PixelColorExist("0xA1FF3D",232, 561,100)
	and  PixelColorExist("0xA1FF3D",403, 562,100))
{	
	LogToFile("Restarted and checked Shangji opened")
	WinClose, %winName%
	ExitApp	
}
else
{	
	
	LogToFile("ShangJi still not opened after restart! Going to open again")
	OpenSJ()
}

Launch4399Game(27,winName)
sleep 1000
WaitPixelColorAndClick("0xFF4841", 377, 909,1000) ; click shang hui button
PixelColorExist("0xF7D7AD",194, 522,2000)
CaptureScreen()
sleep 200
if (PixelColorExist("0xA1FF3D",144, 563,100) 
	and  PixelColorExist("0xA1FF3D",232, 561,100)
	and  PixelColorExist("0xA1FF3D",403, 562,100)) ;Check if gray out.
{
	LogToFile("Restarted twice and checked Shangji opened")	
	WinClose, %winName%
	ExitApp	
}
else
{
	LogToFile("Restarted twice and checked Shangji still not open, going to send alert !")	
	SendAlertEmail()
}

LogToFile("Log file ended.")
MadeGif("OpnShangJi")
WinClose, %winName%
ExitApp


;Functions:
OpenSJ()
{
	Click 146, 562 ;click zhuanqian 技能设置
	sleep 1000
	
	; 开启赚钱技能
	click 403, 330 ;kai qi area
	sleep 500
	click 359, 578 ;ZhuanShi kai qi
	sleep 1000

	; 开启偷猎技能
	click 403, 444 ;kai qi area
	sleep 500
	click 359, 578 ;ZhuanShi kai qi
	sleep 1000

	; 开启融资技能
	click 403, 675 ;kai qi area
	sleep 500
	click 359, 578 ;ZhuanShi kai qi
	sleep 1000
	
	; 关闭subwindow
	click 492, 249 
	sleep 100
} 

F10::Pause   ;pause the script
F11::ExitApp ;stop the script