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

/*	
	WinActivate xxsf
	sleep 200
WinGetActiveStats, Title, Width, Height, X, Y
MsgBox, The active window "%Title%" is %Width% wide`, %Height% tall`, and positioned at %X%`,%Y%.
*/
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

		CloseQHSubWindow()
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


SuanKaiQH()
{
	WinActivate,xxsf
	sleep 500
	;CloseQHSubWindowquick()
	sleep 200
	click 134, 894 ;TouZi
	sleep 200
	PixelColorExist("0xFFFEF5",173, 179,2000) ;

	click  230, 236
	sleep 500

	if !PixelColorExist("0xD3EBF8",218, 791,100) ;JBP not available
		throw "SuanKai():JBP not available!"


	if (!PixelColorExist("0x000000",425, 792,20)) ;no black
		and (PixelColorExist("0xDCF0F7",377, 789,20))  ;small white color exist
		;and !PixelColorExist("0xFFFDF1",414, 779,10)  ; no dot
	{
		WaitPixelColorAndClick("0xDEF7EE",430, 742,500)  ; NiuShi button
		sleep 200
		WaitPixelColorAndClickThrowErr("0x6DE9CF",475, 469,2000) ; Use button 
		sleep 300
	}

	sleep 200
	WaitPixelColorAndClickThrowErr("0xDEF7EE",271, 742,1500) ; JBP button
	sleep 200
	WaitPixelColorAndClickThrowErr("0x6DE9CF",475, 469,2000) ; Use button 
	sleep 300
	;WaitPixelColorAndClick("0xFBFBFB",491, 390,10) ;close sub window if exist
	sleep 200
	;WaitPixelColorAndClick("0xD12624",508, 235, 10) ;close sub window if exist

	sleep 200	
	Save_RefreshQH()
}

Save_RefreshQH()
{
	click 44, 892 ;shop button
	;Setting Button
	sleep 500
	;WaitPixelColorAndClick("0xFFFFFF",594, 187,3000) ; setting button
	click 594, 187
	sleep 300
	;Setting page
	if !PixelColorExist("0xFFFFF3",285, 332,3000)
		throw "Setting page cannot found!"

	sleep 100
	click 431, 553 ;Save button
	sleep 1000
	WaitPixelColorAndClick("0xFBFBFB",504, 266, 500) ;Close button
}

GetQHCaiTuanMoney()
{
	WaitPixelColorAndClickThrowErr("0x3E515C",305, 897,2000) ;cai tuan button
	sleep 200
	WaitPixelColorAndClickThrowErr("0xFFFCF7",580, 226,2000) ;Shou Ru button	
	sleep 100
}


CloseQHMenu()
{
	if PixelColorExist("0xF0E650",596, 559,1000) ;限时活动
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

GetCaiTuanMoney()
{
	WaitPixelColorAndClickThrowErr("0x3E515C",307, 879,2000) ;cai tuan button
	sleep 200
	WaitPixelColorAndClickThrowErr("0xFFDFAB",457, 234,2000) ;Shou Ru button	
	sleep 100
}
