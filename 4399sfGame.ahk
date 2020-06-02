#SingleInstance, Force
SetBatchLines, -1
SetTitleMatchMode, 3
#Include, Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

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

	Launch4399Game(Sequ,windowname)
	{
		WinClose, xiaoxiaoshoufu  ; Never use the default name, otherwise cannot get correct zhushu
		Loop
		{
			WinClose, %windowname%
			WinClose Cisco AnyConnect	;The VPN windows may exist	
			WinClose, IrfanView			;The capture screen error windows may exist				

			if A_Index > 2				
					throw "Cannot launch Game!"
			try 
			{
				run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
				sleep 5000
				WinGetActiveTitle, Title
				if !InStr(Title, "xiaoxiao")
					throw "The active windows is not named xiaoxiaoshoufu" 
				WinSetTitle,%Title%,, %windowname%
				WinSet, AlwaysOnTop, On, %windowname%				
				Winmove,%windowname%,,829,23,600,959				
				WaitPixelColor("0x232D4D",544, 84,15000)			;Waiting for up array		
				loop
				{	
					if A_Index > 15
					{
						LogToFile("the up array clicked 15 times with no response!")
						Continue 2
					}

					click, 566, 83
					sleep 1000
					if !PixelColorExist("0x232D4D",544, 84,10) ;Click the up array if it  exist
						break
				}

				WaitPixelColor("0xFFFEF5",371, 686,15000) ;waiting for Start game button
				sleep 500
				click 343, 766
				WaitPixelColorNotExist("0xB5DF65",521, 601,8000)        ;Waiting for the login page gone.
			}
			Catch e
			{
				LogToFile("Start Game timeout, going to retry..." . e)
				Continue
			}
	
			sleep 2000
			colcount := 0
			
			loop
			{				
				if PixelColorExist("0xCEC870",524, 91,10) ;the color in the top right corner
					colcount++
				else
					closeAnySubWindow()

				if colcount	> 1
					break
				if A_Index > 5
				{
					LogToFile("homepage not show expected and not sub window found!")
					Continue 2
				}
				sleep 1000			
			}
		    WinSet, AlwaysOnTop, Off, %windowname%
			break
		}	
	}

   Getzhushu()
	{
		WinGetActiveTitle, titlename
		if numTable[titlename] = ""
			return 16						;默认最低16注
		else
			return numTable[titlename]		;配置在ini文件里的注数
	}

}

