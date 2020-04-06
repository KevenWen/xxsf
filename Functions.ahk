#SingleInstance, Force
SetBatchLines, -1
;SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.

global rdppw = ""
global rdpdomain = ""
global 4399GamePath = ""
global LDGamePath = ""
global gifskipath = ""
global emailPSFilePath = ""
global logPath = ""
global i_viewpath = ""
global logArchivePath = ""

IniRead, rdppw, config.ini, passwords, RDPpw
IniRead, rdpdomain, config.ini, passwords, RDPdm
IniRead, logPath, config.ini, path, logPath
IniRead, logArchivePath, config.ini, path, logArchivePath
IniRead, emailPSFilePath, config.ini, path, emailPSFilePath
IniRead, LDGamePath, config.ini, path, LDGamePath
IniRead, 4399GamePath, config.ini, path, 4399GamePath
IniRead, gifskipath, config.ini, path, gifskipath
IniRead, i_viewpath, config.ini, path, i_viewpath


PixelColorExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor = p_DesiredColor )
            Return 1
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}

PixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor != p_DesiredColor )
            Return 1
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}


WaitPixelColor(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0,p_GetMode="RGB",p_ReturnColor=0) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, %p_GetMode%	
        If ( ErrorLevel )
            Return ( p_ReturnColor ? l_OutputColor : 1 )
        If ( l_OutputColor = p_DesiredColor )
            Return ( p_ReturnColor ? l_OutputColor : 0 )
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return ( p_ReturnColor ? l_OutputColor : 2 )
    }
}

WaitPixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0,p_GetMode="RGB") 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, %p_GetMode%	
        If ( ErrorLevel ) ;Not found 
			break		
        If ( l_OutputColor = p_DesiredColor ) ;Still found
            sleep 50 ;same
		Else
			break	;not same
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut) ;Timeout
  			throw "WaitPixelColorNotExist has error!"
    }
}

WaitPixelColorAndClickThrowErr(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0) 
{
    l_Start := A_TickCount	
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
        If ( ErrorLevel )
				Throw "WaitPixelColorAndClickErrorLevel!"

        If ( %l_OutputColor% = %p_DesiredColor% )
            {
			Mousemove %p_PosX%, %p_PosY%
			sleep 50	
			click 
			return
			}
		Else
			{
			sleep 20
			}
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
				Throw "WaitPixelColorAndClickTimeOut!"
    }
}

WaitPixelColorAndClick(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0,wtime=100) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
        If ( ErrorLevel )
            Return 1
        If ( l_OutputColor = p_DesiredColor )
			{
			Mousemove %p_PosX%, %p_PosY%
			sleep 50	
			click
			sleep %wtime% 
			Return 0
			}
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 2 
    }
}

CaptureScreen()
{
	try
	{
		path := % logPath . "\\" . A_now . ".png"
		RunWait, % i_viewpath . " /capture=3" . " /convert=" . path
	}
	catch e
	{
		;Ignore the error here.
		;LogToFile(e)
	}

}

CaptureScreenAll()
{
	try
	{
		path := % logPath . "\\fullScreen\\" . A_now . ".png"
		RunWait, % i_viewpath . " /capture=0" . " /convert=" . path
	}
	catch e
	{
		;Ignore the error here.
		;LogToFile(e)
	}

}

MadeGif(named="unknown")
{
	try
	{
		FileMove,  % logPath . "\\gif_output\\*.gif", % logPath . "\\Arch_gif", 1
		name := % logPath . "\\gif_output\\" . named . "_" . A_now . ".gif"
		RunWait, % gifskipath . " " . logPath . "\\*.png --quality 90 -W 400 -H 640 --fps 1 -o " . name . " --fast"
		FileMove, % logPath . "\\*.png", % logArchivePath . "\\Arch", 1
	}
	catch e
	{
		;Ignore the error here.
		;LogToFile("MadeGif exception: " . e)
	}
}

SendAlertEmail()
{
	Run "powershell.exe" -ExecutionPolicy Bypass -File %emailPSFilePath%
}

SendSlackEmail()
{
	;run "E:\AhkScriptManager-master\libblat.exe" -body "See Attached file" -attach "C:\Users\kwen\Downloads\output.txt" -subject "New SR was raised in the last xx hours" -to "q4q3m9g3r6f7u1d1@quest.slack.com" -server relay.quest.com -f SRNotification@quest.com
	run "E:\AhkScriptManager-master\lib\blat.exe" -body "testing" -subject "New SR was raised in the last xx hours" -to "keven.wen@quest.com" -server relay.quest.com -f SRNotification@quest.com
}

Launch4399Game(Sequ,windowname)
{
	Loop
	{
		if A_Index > 4
			{
				break
				throw "Cannot launch Game!"
			}
		WinClose, %windowname%
		run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
		sleep 3000
		WinGetActiveTitle, Title
		WinWaitActive, %Title%
		WinSetTitle, %windowname%
		WinSet, AlwaysOnTop, On, %windowname%
		Winmove,%windowname%,,829,23,600,959
		if (WaitPixelColor("0x232D4D",544, 84,15000)=0)			;Waiting for up array
		{
			Click 566, 83
			sleep 500		
		}
		Else
			Continue

		sleep 2000 
		if PixelColorExist("0x232D4D",544, 84,20)				;Click again, some times the first click not get any response.
		{
			Click 566, 83
			sleep 500		
		} 			

		if !(WaitPixelColorAndClick("0x3BB1B2",343, 766,12000)=0)
			Continue

		WaitPixelColorNotExist("0xB5DF65",521, 601,8000)        ;Waiting for the login page gone.
		sleep 2000
		loop 3
		{
			sleep 1000
			if !PixelColorExist("0xAFC387",473, 105,10)
			{
				CloseAnySubWindow()
				break
			}
		}
		WinSet, AlwaysOnTop, off, %windowname%
		break
	}	
}

SuanKai()
{
	WinActivate, %winName%
	sleep 500
	CloseAnySubWindow()
	sleep 200
	click 166, 893 ;TouZi
	sleep 200
	click 236, 267
	sleep 200
	loop
	{
		if (PixelColorExist("0xADFFEF",414, 825,10))
			break
		click 236, 267
		sleep 500
		if (A_Index > 4)
			throw "Nob able to open TouZi Page!"
	}
	;WaitPixelColorAndClickThrowErr("0xFFFFFF",283, 247,2000) ;

	if !PixelColorExist("0x4BB2D9",318, 786,10) ;JBP not available
	{
		if PixelColorExist("0x81FBD6",398, 787,10) ; time tunnel available
		{
			click 398, 787
			sleep 200
			WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
			sleep 300
		}	
		Else
		{
			throw "SuanKai():JBP not available!"
		}

	}	

	if !PixelColorExist("0xE4E4E4",447, 756,10) 
		and PixelColorExist("0x4BB3D9",466, 786,10) 
		and !PixelColorExist("0xFFFDEF",447, 756,10) 
	{
		;LogToFile("suankai done for 1,3")
		WaitPixelColorAndClick("0xDEF7EE",471, 737,500)  ; NiuShi button
		sleep 200
		WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
		sleep 300
	}

	sleep 200
	WaitPixelColorAndClickThrowErr("0xDEF7EE",317, 737,1500) ; JBP button
	sleep 200
	WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
	sleep 800
	;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		
	Save_Refresh4399()

	/*  ;phy only
	click 458, 750
	sleep 500
	;WaitPixelColorAndClickThrowErr("0xFBFBFB",481, 232,2000) ; close button for testing
	WaitPixelColorAndClickThrowErr("0x6BE8CF",445, 469,2000) ; Use button
	sleep 200
	click 298, 755
	sleep 500
	WaitPixelColorAndClickThrowErr("0x6BE8CF",445, 469,2000) ; Use button
	sleep 200
	Save_Refresh4399()
	*/
}

Save_Refresh4399()
{
	click 86, 893
	;Setting Button
	WaitPixelColorAndClickThrowErr("0xFFFFFF",496, 198,3000)
	;Setting page
	if !(WaitPixelColor("0xFFFFF3",405, 321,3000) = 0)
		throw "Setting page cannot found!"

	sleep 100
	click 404, 554 ;Save button
	sleep 1000
	Click, 476, 276 ;Close button
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

LogToFile(TextToLog)
{
    global LogFileName  ; This global variable was previously given a value somewhere outside this function.
    FileAppend, %TextToLog%`n, %LogFileName%
}

GetConsortiumMoney()
{
	WaitPixelColorAndClickThrowErr("0x3E515C",307, 879,2000) ;cai tuan button
	sleep 200
	WaitPixelColorAndClickThrowErr("0xFFDFAB",457, 234,2000) ;Shou Ru button	
	sleep 100
}

GetDailayTaskMoney()
{
	if PixelColorExist("0xD12A06",473, 308,20) ;每日任务,如偷满10次
	{
		Click 495, 315
		sleep 200
		Click 420, 420 ;Task 1
		sleep 50
		Click 420, 500 ;Task 2
		sleep 50		
		Click 420, 580 ;Task 3
		sleep 100
		Click 479, 344 ;Close Button
		sleep 200
	}
}

FixRDPConn()
{
	WinActivate ahk_exe mstsc.exe
	;WinSet, AlwaysOnTop, On, ahk_exe mstsc.exe
	;The active window "CompanyPhy - 10.154.10.6 - Remote Desktop Connection" is 1120 wide, 872 tall, and positioned at 585,111.
	Winmove,ahk_exe mstsc.exe,,585,111,1120,872
	sleep 200

	Loop
	{
		if A_Index > 2
			Return 0

		if PixelColorExist("0xFFFCF8",1060, 500,200) ;the white color in the left pop up OK window
			Break
		Else
		{
			WinClose,ahk_exe mstsc.exe	
			sleep 200
			run "C:\Windows\system32\mstsc.exe" "C:\Users\keven\Documents\phy.rdp"
			sleep 10000	
		}
	}
	Return 1
}

IsItemInList(item, list, delim="")			;Return if a var in the list, mainly use to read days from config.ini
{
   delim := (delim = "") ? "," : delim
   Loop, Parse, list, %delim%
   {
      if (A_LoopField = item)
         return true
   }
   return false
}