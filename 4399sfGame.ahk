#SingleInstance, Force
SetBatchLines, -1
SetTitleMatchMode, 3
#Include, Functions.ahk

class 4399sfGame
{

; <===================================  Properties declare  =======================================>


; <===================================  Sub Classes for each page  ================================>

	#Include, .\4399Subpages\Shophomepage.ahk
	#Include, .\4399Subpages\Landpage.ahk
	#Include, .\4399Subpages\HunterPage.ahk
	#Include, .\4399Subpages\CaiTuanPage.ahk
	#Include, .\4399Subpages\GroupPage.ahk
	#Include, .\4399Subpages\OrderPage.ahk

; <==================================  Command functionalities  ====================================>
	PrepareGameWindow(name)
	{	
		WinGetActiveTitle, CurTitle
		if (CurTitle = name)
			Return
		
		IfWinExist,%name%
		{
			WinActivate, %name%
			LogToFile("")
			LogToFile("Log switch for: " . name)
			sleep 100
		}
		Else
			throw "Window name not exist!"
	}

	Close4399Game(windowname)
	{
		WinClose, %windowname%
	}

	Launch4399Game(Sequ,windowname)
	{
		WinClose, xiaoxiaoshoufu  ; Never use the default name, otherwise cannot get correct zhushu
		Loop
		{
			WinClose, %windowname%
			
			if A_Index > 4				
					throw "Cannot launch Game!"
			try 
			{
				run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
				sleep 5000
				WinGetActiveTitle, Title
				if !InStr(Title, "xiaoxiao")
					throw "The active windows is not named xiaoxiaoshoufu" 
				WinSetTitle,%Title%,, %windowname%
				;WinSet, AlwaysOnTop, On, %windowname%
				Winmove,%windowname%,,829,23,600,959
				WaitPixelColor("0x232D4D",544, 84,15000)			;Waiting for up array			
				MouseMove, 566, 83
				sleep 500				
				send {LButton down}
				sleep 10	
				send {LButton up}
				;Click 566, 83
				sleep 1000	
				;WaitPixelColorAndClickThrowErr("0x3BB1B2",343, 766,12000) 
				WaitPixelColor("0xFFFEF5",371, 686,15000) ;waiting for Start game button
				sleep 500
				click 343, 766
				WaitPixelColorNotExist("0xB5DF65",521, 601,8000)        ;Waiting for the login page gone.
			}
			Catch e
			{
				CaptureScreen()
				LogToFile("Start Game timeout, going to retry...")
				Continue
			}

			if PixelColorExist("0x232D4D",544, 84,10) ;Click the up array again if it still exist
				click, 566, 83
			
			sleep 2000
			colcount := 0
			
			loop
			{				
				if PixelColorExist("0xCEC870",520, 90,10) ;the color in the top right cornal
					colcount++
				else
					this.CloseAnySubWindow()

				if colcount	> 1
					break
				if A_Index > 5
				{
					LogToFile("homepage not show expected and not sub window found!")
					CaptureScreen()
					Continue 2
				}

				sleep 1000			
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
		WinGetActiveTitle, titlename
		Switch titlename
		{
			Case "song":
				return 38
			Case "long":
				return 39
			Case "hou":
				return 38				
			Case "yun":
				return 40
			Case "supper":
				return 42							
			Case "xxhz":
				return 39
			Case "xhhz":
				return 39
			Default:
				return 16	
		}
	}

   CheckName()
	{
		;18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
		;phy: supper=10 yun=8 song=2 long=7 hou=9 xhhz= sf01=11 sf01=1 sf03=3 sf04=4 sf05=5
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
			Case "xhhz":
				return % (this.sequ = 18)?1:0
			Case "sf01":
				return % (this.sequ in 1,19)?1:0
			Case "sf03":
				return % (this.sequ in 3,21)?1:0
			Case "sf04":
				return % (this.sequ in 4,22)?1:0
			Case "sf05":
				return % (this.sequ in 5,23)?1:0
			Case "sf06":
				return % (this.sequ in 11,35)?1:0
			Default:
				return 0	
		}
	}

}

