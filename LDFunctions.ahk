#SingleInstance, Force
SetBatchLines, -1
;SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.

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

LaunchLDGame()
{
	Loop
	{
		if A_Index > 4
			{
				break
				throw "Cannot launch qun hei Game!"
			}
		WinClose, ahk_class LDPlayerMainFrame
		runwait "C:\ChangZhi\LDPlayer\dnconsole.exe" launchex --index 0 --packagename "com.wydsf2.ewan",, Hide
		sleep 5000
        WinActivate  ahk_class LDPlayerMainFrame 
		sleep 200
		WinSetTitle, ldxxsf
		WinSet, AlwaysOnTop, On, ldxxsf

		sleep 3000 ;Waiting for start button
		if PixelColorExist("0xFFFEF5",380, 738,18000)
		{
            runwait "C:\ChangZhi\LDPlayer\ld.exe" -s 0 input tap 448 1298,, Hide
		}
		Else If PixelColorExist("0xFE901A",368, 504,100)
		{
			click 368, 504 ;click the account button
			sleep 500
			click 356, 545 ;click the manully login button
			sleep 500

			if PixelColorExist("0x3AB0B4",368, 783,10000)
			{
				;CloseQHMenu()	
				sleep 200
				click 368, 783 ;click the start button
			}
			Else
			{
				CaptureScreen()
				Continue
			}

		}
		Else		
		{
			CaptureScreen()
			Continue
		}

		sleep 5000 ;Waiting for pop out window

		CloseLDSubWindow()
		sleep 200

		if !(PixelColorExist("0xFFFEF5",288, 323,1000)=0) ; double check again on the caituan page
		{
			CaptureScreen()
			Continue
		}

		WinSet, AlwaysOnTop, off, xxsf
		;CaptureScreen()
		break
	}	
}

CloseLDSubWindow()
{
	if PixelColorExist("0xFBFBFB",500, 200,1000) ;限时活动
	{
		click 500,200
	}	

	WaitPixelColorAndClick("0xFBFBFB",510, 346,200) ;qian dao jiang li
	WaitPixelColorAndClick("0xFBFBFB",480, 350,20) ;立即冷确
	WaitPixelColorAndClick("0xFBFBFB",499, 250,20) ;Rong Zi button
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
		;LogToFile(e)
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
		;LogToFile(e)
	}
}

SendAlertEmail()
{
	Run "powershell.exe" -ExecutionPolicy Bypass -File E:\\AhkScriptManager-master\\3rd\\EmailTestScript.ps1 
}

SendSlackEmail()
{
	;run "E:\AhkScriptManager-master\libblat.exe" -body "See Attached file" -attach "C:\Users\kwen\Downloads\output.txt" -subject "New SR was raised in the last xx hours" -to "q4q3m9g3r6f7u1d1@quest.slack.com" -server relay.quest.com -f SRNotification@quest.com
	run "E:\AhkScriptManager-master\lib\blat.exe" -body "testing" -subject "New SR was raised in the last xx hours" -to "keven.wen@quest.com" -server relay.quest.com -f SRNotification@quest.com
}

SendMsgToTIM()
{
	send, ^!{z} 
	WinWaitActive ahk_exe TIM.exe,,5
	click 108, 200
	sleep 200 
	send, ^{v} 
	sleep 200
	send, !{s}
	sleep 300
	click right 400,300
	sleep 100
	click, 468, 451
	sleep 200
	send !{F4}  
}

LogToFile(TextToLog)
{
    global LogFileName  ; This global variable was previously given a value somewhere outside this function.
    FileAppend, %TextToLog%`n, %LogFileName%
}
