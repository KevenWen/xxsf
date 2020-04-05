#SingleInstance, Force
SetBatchLines, -1
#Include, sfGame.ahk

class QHsfGame extends sfGame
{
	__New()
	{
		global qhpw = ""
		IniRead, qhpw, config.ini, passwords, QHpw
	}


	ResizeQHWindow()
	{
		;CoordMode, Pixel, window  
		;CoordMode, Mouse, window
		
			IfWinExist xxsf
		{
			WinActivate
			;Winmove,xxsf,,933,19,628,937
			Winmove,xxsf,,933,19,600,959
		}		

	}

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
			Winmove,xxsf,,933,19,600,959

			sleep 3000 ;Waiting for start button
			if PixelColorExist("0x41B6AC",368, 783,18000)
			{
				CloseQHMenu()	
				sleep 200
				click 368, 783 ;click the start button
			}
			Else If PixelColorExist("0xFE901A",365, 541,100)
			{
				click 365, 541 ;click the account button
				sleep 500
				click 356, 545 ;click the manully login button
				sleep 500

				if PixelColorExist("0x41B6AC",368, 783,18000)
				{
					CloseQHMenu()	
					sleep 200
					click 368, 783 ;click the start button
				}
				Else
					Continue
			}
			Else		
				Continue

			sleep 5000 ;Waiting for pop out window

			CloseAnySubWindow()
			sleep 200

			if !PixelColorExist("0xEFFEFF",56, 920,100) ; double check again on the shop button
			{
				CaptureScreen()
				Continue
			}

			WinSet, AlwaysOnTop, off, xxsf
			break
		}	
	}

	GetQHCaiTuanMoney()
	{
		WaitPixelColorAndClickThrowErr("0x3E515C",290, 914,2000) ;cai tuan button
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFFCF6",552, 230,2000) ;Shou Ru button	
		sleep 100
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\\blockofwhite.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
				Break
			else if (ErrorLevel = 0) ;Image found
			{
				if PixelColorExist("0x1657B0",335, 421,10) ;Daily awards
				{
					click 446, 416
					sleep 100
					click 446, 503
					sleep 100
					click 446, 589
					sleep 100
				}
				if PixelColorExist("0xFBFBFB",500, 216,20) ;限时活动
				{
					click 445, 480
					sleep 100
					click 436, 383
					sleep 100				
				}
				
				click %Px%, %Py%
				sleep 200
			}
			sleep 100
		}	
	}

	CloseQHMenu()
	{
		if PixelColorExist("0xF7EF5F",566, 572,1000) ;群黑图标
		click 566, 572
		sleep 500
		click 561, 639
		sleep 200
	}	

}







