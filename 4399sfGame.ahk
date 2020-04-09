#SingleInstance, Force
SetBatchLines, -1
SetTitleMatchMode, 3
#Include, Functions.ahk
;#Include, sfGame.ahk
; click, % Arrayphy["btn1"]

class 4399sfGame ;extends sfGame
{

; <===================================  Properties declare  =======================================>

WID := ""
winName := ""
sequ := ""


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
				WaitPixelColor("0x232D4D",544, 84,15000)			;Waiting for up array			
				sleep 2000
				Click 566, 83
				sleep 1000	
				;WaitPixelColorAndClickThrowErr("0x3BB1B2",343, 766,12000) 
				WaitPixelColor("0xFFFEF5",371, 686,12000) ;waiting for Start game button
				sleep 500
				click 343, 766
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

	SubWindowExist()
	{
		ImageSearch, Px, Py, 400, 169, 511, 609, % A_ScriptDir . "\\blockofwhite.bmp"
		if (ErrorLevel = 2)  ;Execption when conduct the search
			return 0
		else if (ErrorLevel = 1) ;Image not found 
			return 0
		else if (ErrorLevel = 0) ;Image found
			return 1
	}

   Getzhushu()
	{
		Switch % this.winName
		{
			Case "song":
				return 38
			Case "long":
				return 39
			Case "hou":
				return 38				
			Case "yun":
				return 38
			Case "supper":
				return 41							
			Case "xxhz":
				return 40
			Case "xhhz":
				return 40
			Default:
				return 16	
		}
	}

   CheckName()
	{
		;18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
		;phy: supper=10 yun=8 song=2 long=7 hou=9 xhhz= mao=6 sf01=1 sf03=3 sf04=4 sf05=5
		Switch % this.winName
		{
			Case "song":
				return % (this.sequ in 20,2)?1:0
			Case "long":
				return % (this.sequ in 25,7)?1:0
			Case "hou":
				return % (this.sequ in 26,9)?1:0				
			Case "yun":
				return % (this.sequ in 24,8)?1:0
			Case "supper":
				return % (this.sequ in 27,10)?1:0							
			Case "xxhz":
				return % (this.sequ = 18)?1:0
			Case "xhhz":
				return % (this.sequ = 18)?1:0
			Default:
				return 1	
		}
	}


}

