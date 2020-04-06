#SingleInstance, Force
SetBatchLines, -1
#Include, sfGame.ahk
; click, % Arrayphy["btn1"]

class 4399sfGame ;extends sfGame
{

; <================================  Constructure functions  ================================>

	__New(seq,windowname)
	{
		
		global logfilename := % logPath . "\\" . windowname  . "_" . A_now  . ".txt"

		LogToFile("Log started.")

		try
		{
			IfWinExist, %windowname%
			{
				WinActivate %windowname%
				Winmove,%windowname%,,829,23,600,959
				click % HB[1]
				LogToFile("Find existing window named: " . windowname)
				sleep 200
			}
			else
			{
				LogToFile("Going to open game: " . windowname)
				this.Launch4399Game(seq,windowname)
				LogToFile("Game opened.")
			}	

			;Assign properties:
			WinGet IDVar,ID,A ; Get ID from Active window.		
			this.WID := IDVar
			this.winName := %windowname%
			this.sequ := %seq%

			LogToFile("Wid is： " . this.WID)
		}
		Catch, e
			{
				CaptureScreen()
				LogToFile("Game open failed: " . e)
			}
	}

    __Delete()
    {
		WinClose, %windowname%
		this.LogToFile("Log Ended.")
    }
	
; <===================================  Sub Classes for each page  ================================>

	#Include, .\4399Subpages\Shophomepage.ahk
	#Include, .\4399Subpages\Landpage.ahk
	#Include, .\4399Subpages\HunterPage.ahk
	#Include, .\4399Subpages\CaiTuanPage.ahk
	#Include, .\4399Subpages\GroupPage.ahk
	#Include, .\4399Subpages\OrderPage.ahk

; <==================================  Command functionalities  ====================================>

	PrepareGameWindow()
	{
		WinActivate, % ahk_id this.WID
		sleep 100
	}

	Close4399Game()
	{
		WinClose, %windowname%
	}

	Launch4399Game(Sequ,windowname)
	{
		WinClose, %windowname%
		Loop
		{
			if A_Index > 4
				{
					break
					throw "Cannot launch Game!"
				}
			try 
			{
				run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
				sleep 3000
				WinGetActiveTitle, Title
				WinWaitActive, %Title%
				WinSetTitle, %windowname%
				;WinSet, AlwaysOnTop, On, %windowname%
				Winmove,%windowname%,,829,23,600,959
				WaitPixelColor("0x232D4D",544, 84,15000)			;Waiting for up array			{
				sleep 2000
				Click 566, 83
				sleep 1000	
				WaitPixelColorAndClickThrowErr("0x3BB1B2",343, 766,12000) ; Start game button
				WaitPixelColorNotExist("0xB5DF65",521, 601,8000)        ;Waiting for the login page gone.
			}
			Catch e
			{
				CaptureScreen()
				Continue
			}
			sleep 2000
			loop 3
			{
				sleep 1000				
				if !PixelColorExist("0xAFC387",473, 105,10)
				{
					this.CloseAnySubWindow()
					break
				}
			}
			;WinSet, AlwaysOnTop, off, %windowname%
			break
		}	
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 400, 169, 511, 609, % A_ScriptDir . "\\blockofwhite.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
				Break
			else if (ErrorLevel = 0) ;Image found
			{
				if PixelColorExist("0x1657B0",324, 418,10) ;Daily awards
				{
					click 403, 573
					sleep 100
					click 402, 493
					sleep 100
					click 401, 415
				}
				if PixelColorExist("0xFBFBFB",471, 214,100) ;限时活动
				{
					click 449, 471
					sleep 100
				}
				
				click %Px%, %Py%
				sleep 200
			}
			sleep 100
		}	
	}

	CloseSpeSubWindow(n)
	{
		loop %n%
		{
			ImageSearch, Px, Py, 400, 169, 511, 609, % A_ScriptDir . "\\blockofwhite.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
				Break
			else if (ErrorLevel = 0) ;Image found
			{
				click %Px%, %Py%
				sleep 200
			}
			sleep 100
		}	
	}

}










