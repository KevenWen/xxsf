#SingleInstance, Force
SetBatchLines, -1
;SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.

global qhpw = ""
IniRead, qhpw, credentials.ini, passwords, QHpw

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

WaitPixelColorAndClick(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0,p_GetMode="RGB") 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, %p_GetMode%	
        If ( ErrorLevel )
            Return 1
        If ( l_OutputColor = p_DesiredColor )
			{
			Mousemove %p_PosX%, %p_PosY%
			sleep 50	
			click 
			Return 0
			}
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 2 
    }
}


ResizeQHWindow()
{
	;CoordMode, Pixel, window  
	;CoordMode, Mouse, window
	
		IfWinExist xxsf
	{
		WinActivate
		Winmove,xxsf,,933,19,628,937
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
				Continue
		}
		Else		
			Continue

		sleep 5000 ;Waiting for pop out window

		CloseAnySubWindow()
		sleep 200

		if !(PixelColorExist("0xFFFEF5",288, 323,1000)=0) ; double check again on the caituan page
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
	WaitPixelColorAndClickThrowErr("0x3E515C",305, 897,2000) ;cai tuan button
	sleep 200
	WaitPixelColorAndClickThrowErr("0xFFFCF7",580, 226,2000) ;Shou Ru button	
	sleep 100
}

CloseAnySubWindow()
{
	loop 5
	{
		ImageSearch, Px, Py, 370, 140, 610, 575, E:\\AhkScriptManager-master\\scripts\\blockofwhite.bmp
		if (ErrorLevel = 2)  ;Execption when conduct the search
			throw "ImageSearch not work, please check." 
		else if (ErrorLevel = 1) ;Image not found 
			Break
		else if (ErrorLevel = 0) ;Image found
		{
			if PixelColorExist("0x1657B0",348, 413,10) ;Daily awards
			{
				click 462, 407
				sleep 100
				click 462, 492
				sleep 100
				click 462, 580
				sleep 100
			}
			if PixelColorExist("0xFBFBFB",508, 213,20) ;限时活动
			{
				click 450, 471
				sleep 200
			}
			
			click %Px%, %Py%
			sleep 200
		}
		sleep 100
	}	
}

CloseQHMenu()
{
	if PixelColorExist("0xF8F161",596, 559,1000) ;群黑图标
	click 596, 559
	sleep 500
	click 586, 633
	sleep 200
}

CaptureScreen()
{
	try
	{
		path := % "E:\\AhkScriptManager-master\\log\\" . A_now . ".png"
		RunWait, "C:\Program Files\IrfanView\i_view64.exe" /capture=3 /convert=%path%
	}
	catch e
	{
		;Ignore the error here.
		LogToFile(e)
	}

}

MadeGif(named)
{
	try
	{
	FileMove, E:\\AhkScriptManager-master\\log\\gif_output\\*.gif, E:\\AhkScriptManager-master\\log\\Arch_gif
	name := % "E:\\AhkScriptManager-master\\log\\gif_output\\" . named . "_" . A_now . ".gif"
	RunWait, "E:\AhkScriptManager-master\ext\gifski.exe" E:\\AhkScriptManager-master\\log\\*.png --quality 90 -W 400 -H 640 --fps 1 -o %name% --fast
	FileMove, E:\\AhkScriptManager-master\\log\\*.png, E:\\AhkScriptManager-master\\log_archive\\Arch
	}
	catch e
	{
		;Ignore the error here.
		LogToFile(e)
	}
}

SendAlertEmail()
{
	Run "powershell.exe" -ExecutionPolicy Bypass -File E:\\AhkScriptManager-master\\3rd\\EmailTestScript.ps1 
}

LogToFile(TextToLog)
{
    global LogFileName  ; This global variable was previously given a value somewhere outside this function.
    FileAppend, %TextToLog%`n, %LogFileName%
}

