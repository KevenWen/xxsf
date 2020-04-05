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

global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times

PixelColorExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor = p_DesiredColor )
        {
            sleep 100
            Return 1            
        }    
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}

PixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor != p_DesiredColor )
        {
            sleep 100
            Return 1            
        } 
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}

WaitPixelColor(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=1000) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB
        If ( ErrorLevel )
            throw "WaitPixelColor has error!"
        If ( l_OutputColor = p_DesiredColor )
        {
            sleep 100
            Return 1            
        } 
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            throw "WaitPixelColor has error!"
    }
}

WaitPixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB
        If ( ErrorLevel ) ;Not found 
			throw "WaitPixelColorNotExist has error!"
        If ( l_OutputColor = p_DesiredColor ) ;Still found
            sleep 50 ;same
		Else
			break	;not same
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut) ;Timeout
  			throw "WaitPixelColorNotExist has error!"
    }
}

WaitPixelColorAndClick(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0,wtime=1000) 
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

WaitPixelColorAndClickThrowErr(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=1000) 
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
			sleep 20

        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
				Throw "WaitPixelColorAndClickTimeOut!"
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

LogToFile(TextToLog)
{
    global LogFileName  ; This global variable was previously given a value somewhere outside this function.
    FileAppend, %TextToLog%`n, %LogFileName%
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