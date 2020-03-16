#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

global Jw := 2
global winName := "xxsf"

Try 
{
	Gosub, PrepareTT
	Gosub, TTOperation
}
Catch e
{
	CaptureQHscreen()	
}

WinSet, AlwaysOnTop, off, xxsf
;MadeGif("TouLieQH")
sleep 200
ExitApp

PrepareTT:
	Loop
	{
		if A_Index > 3  ; more than 3 times, not try any more
			{
				WinSet, AlwaysOnTop, off, %winName%
				ExitApp
			}

		IfWinNotExist, %winName%
			LaunchqhGame()

		WinActivate, %winName%
		WinSet, AlwaysOnTop, on, %winName%	

		WaitPixelColorAndClick("0x3E515C",311, 896,2000) ;caituan button
		sleep 1000
		if PixelColorExist("0xFFFEF5",88, 324,1000)   ;check the gufengzijin is white, if yes, it is on the tt page
		{
			click 69, 177 ;if not ,click TianTi button
			sleep 1000
		}

		if !PixelColorExist("0xFFD99C",311, 473,1000) ;if any pop out window unexpected,then restart the game.
		{
			WinClose, %winName%
			Continue
		}

		break		
	}
return

TTOperation:
	if PixelColorExist("0xF7FBFA",533, 445,200) or PixelColorExist("0xFFFFFF",505, 455,1000) ; Check if the 0 exist, if yes, still waiting for money ready!
		{
			;CaptureQHscreen()
			WinSet, AlwaysOnTop, off, xxsf	
			ExitApp
		}		
	
	WaitPixelColorAndClickThrowErr("0xFFFFFF",564, 269,2000) ; start button
	sleep 100
	if !PixelColorExist("0xFFFEF5",234, 836, 5000) ; if the color is unexpected, close the game and exit. so next time it will fix itself. 
	{
		click 561, 436  ;in case not enough money allocated.
		sleep 1000
		WinClose, %winName%
		ExitApp
	}
/*
	(Jw = 1)? (click 240, 817)	 	;add one for 1
	:((Jw = 2)?(click 345, 817) 	;add one for 2
	:((Jw =3)?(click 450, 817)		;add one for 3
	:())) 							;Not add any Jw
*/
	sleep 100
	click 234, 836  ;add one for 1
	sleep 100	
	;click 345, 817	;add one for 2
	sleep 100
	;click 514, 827  ;;add one for 2
	sleep 5000

	PixelColorExist("0xFFF8CE",167, 843,40000)
	CaptureQHscreen()
	sleep 200
	click 345, 817
	sleep 1000
	click 565, 436
	sleep 200
return


LaunchqhGame()
{
	Loop
	{
		if A_Index > 4
			{
				break
				throw "Cannot launch qun hei Game!"
			}
		WinClose, xxsf
		run "C:\Users\keven\AppData\Roaming\360Game5\bin\360Game.exe" -action:opengame -gid:4 -gaid:30
		sleep 3000
		WinGetActiveTitle, xxsf
		WinWaitActive, xxsf
		WinSet, AlwaysOnTop, On, xxsf
		Winmove,xxsf,,933,19,628,937

		sleep 3000 ;Waiting for start button
		if PixelColorExist("0x3AB0B4",368, 783,18000)
		{

			CloseQHMenu()	
			sleep 200
			click 368, 783 ;click the start button
		}
		Else If PixelColorExist("0xFE901A",368, 504,100)
		{
			click 368, 504 ;click the account button
			sleep 500
			click 356, 545 ;click the manully login button
			sleep 500

			if PixelColorExist("0x3AB0B4",368, 783,10000)
			{
				CloseQHMenu()	
				sleep 200
				click 368, 783 ;click the start button
			}
			Else
			{
				CaptureQHscreen()
				Continue
			}

		}
		Else		
		{
			CaptureQHscreen()
			Continue
		}

		sleep 5000 ;Waiting for pop out window

		CloseQHSubWindow()
		sleep 200

		if !(PixelColorExist("0xFFFEF5",288, 323,1000)=0) ; double check again on the caituan page
		{
			CaptureQHscreen()
			Continue
		}

		;WinSet, AlwaysOnTop, off, xxsf
		;CaptureScreen()
		break
	}	
}

CloseQHSubWindow()
{
	if PixelColorExist("0xFBFBFB",508, 213,1000) ;限时活动
		click 508, 213

	WaitPixelColorAndClick("0xFBFBFB",510, 346,200) ;qian dao jiang li
	WaitPixelColorAndClick("0xFBFBFB",479, 397,20) ;立即冷确
	WaitPixelColorAndClick("0xFBFBFB",499, 263,20) ;Rong Zi button
	sleep 100
}

CloseQHSubWindowquick()
{
	if PixelColorExist("0xFBFBFB",508, 213,20) ;限时活动
		click 508, 213

	WaitPixelColorAndClick("0xFBFBFB",510, 346,20) ;qian dao jiang li
	WaitPixelColorAndClick("0xFBFBFB",479, 397,20) ;立即冷确
	WaitPixelColorAndClick("0xFBFBFB",499, 263,20) ;Rong Zi button
	sleep 100
}

CloseQHMenu()
{
	click 596, 559
	sleep 500
	click 585, 628
	sleep 200
}

CaptureQHscreen()
{
	path := % "E:\\AhkScriptManager-master\\log\\TianTiLog\\" . A_now . ".png"
	RunWait, "C:\Program Files\IrfanView\i_view64.exe" /capture=3 /convert=%path%
}