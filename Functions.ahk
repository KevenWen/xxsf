#SingleInstance, Force
SetBatchLines, -1
;SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.

global 4399GamePath = ""
global LDGamePath = ""
global gifskipath = ""
global emailPSFilePath = ""
global logPath = ""
global i_viewpath = ""
global logArchivePath = ""

global supper_id 
global yun_id 
global song_id
global hou_id
global long_id
global xhhz_id
global sf01_id 
global sf03_id 
global sf04_id
global sf05_id
global sf06_id


IniRead, logPath, config.ini, path, logPath
IniRead, logArchivePath, config.ini, path, logArchivePath
IniRead, emailPSFilePath, config.ini, path, emailPSFilePath
IniRead, LDGamePath, config.ini, path, LDGamePath
IniRead, 4399GamePath, config.ini, path, 4399GamePath
IniRead, gifskipath, config.ini, path, gifskipath
IniRead, i_viewpath, config.ini, path, i_viewpath


IniRead, supper_id, config.ini, users, supper
IniRead, yun_id, config.ini, users, yun
IniRead, song_id, config.ini, users, song
IniRead, long_id, config.ini, users, long
IniRead, hou_id, config.ini, users, hou
IniRead, xhhz_id, config.ini, users, xhhz
IniRead, sf01_id, config.ini, users, sf01
IniRead, sf03_id, config.ini, users, sf03
IniRead, sf04_id, config.ini, users, sf04
IniRead, sf05_id, config.ini, users, sf05
IniRead, sf06_id, config.ini, users, sf06

global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times

global	HB := ["70, 910","145, 910","225, 910","305, 910","380, 910","445, 910"]            ; home buttons
global	SB := ["100, 260","230,260","330,260","420,260"]                                            ; shanghui buttons
global	BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                              ; 5个企业 coordinates
global	TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                              ; Tooltip positions
global	PopWin := {okbtn: "324, 602", clobtn: "480, 266",qhclobtn: "500, 266",zhuziok: "507, 320"}  ; button positions
global	RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}                      ; 融资的按钮
global StockPos := ["155, 415","310, 415","460, 415"]                       		                ; 注资的三个框
global	OpenSJList := ["403, 330","403, 444","403, 675","403, 753"]
global LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
global Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn_2: "798, 692", btn3: "522, 633"        ; RDP click OK buttons
        , btn_3: "522, 692", btn4: "253, 622", btn_4: "253, 692"}       ; btn1 肉沫茄子 btn2 - btn4 4399,前一个窗口刚好挡住下一个的确认两个字。

PixelColorExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor = p_DesiredColor )
        {
            sleep 50
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

WaitPixelColorAndClick(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10,wtime=100) 
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
		FormatTime, Dayfolder,, yyyyMMdd
        path := % logPath . "\\" . Dayfolder . "Screens\\" . A_now . ".png"
		Run, % i_viewpath . " /capture=3" . " /convert=" . path
        LogToFile("Screen")
	}
	catch e
	{
		;Ignore the error here.
		LogToFile("Screen captured failed: " . e)
	}

}

CaptureScreenAll()
{
	try
	{
        FormatTime, Dayfolder,, yyyyMMdd
		path := % logPath . "\\" . Dayfolder . "Fullscreens\\" . A_now . ".png"
		Run, % i_viewpath . " /capture=0" . " /convert=" . path
        LogToFile("Full Screen")
	}
	catch e
	{
		;Ignore the error here.
		LogToFile("Full Screen captured failed: " . e)
	}

}

MadeGif(named="unknown")
{
	try
	{
		FormatTime, Dayfolder,, yyyyMMdd
        path := % logPath . "\\" . Dayfolder . "Screens\\"
		FileMove,  % logPath . "\\gif_output\\*.gif", % logPath . "\\Arch_gif", 1
		name := % logPath . "\\gif_output\\" . named . "_" . A_now . ".gif"
		Runwait, % gifskipath . " " . path . "\\*.png --quality 90 -W 400 -H 640 --fps 1 -o " . name . " --fast"
		;FileMove, % logPath . "\\*.png", % logArchivePath . "\\Arch", 1
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
    try{
    FormatTime, CurrentDateTime,, HH:mm:ss
    FormatTime, Dayfolder,, yyyyMMdd
    if TextToLog = ""
        FileAppend, % "`n", % logPath . "\\" . Dayfolder .  "_log.txt"
    Else
        FileAppend, % CurrentDateTime . ": " . TextToLog . "`n", % logPath . "\\" . Dayfolder .  "_log.txt"
    }
    catch e {
        ;Nothing need do here
    }
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

RongZiOKEmu()
{
    For index,value in  ["song","hou","xhhz","supper","long","yun"]
    {
        IfWinExist %value%
        {
            WinActivate %value%
            sleep, % s["short"]
            click % PopWin["okbtn"]
            sleep, % s["short"]
            click % PopWin["okbtn"]
            CaptureScreen()
        }   
    }
}
UploadNetDisk()
{
    Run "C:\Users\keven\AppData\Roaming\baidu\BaiduNetdisk\BaiduNetdisk.exe"
    sleep 600000
    Process, close, baidunetdisk.exe
}

Launch4399GamePri(windowname,Sequ)
{
    IfWinExist %windowname%
    {
        WinActivate %windowname%
        Return
    }

    run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
    sleep 4000
    WinGetActiveTitle, Title
    if !InStr(Title, "xiaoxiao")
        MsgBox, "The active windows is not named xiaoxiaoshoufu" 
    WinSetTitle,%Title%,, %windowname%
    Winmove,%windowname%,,829,23,600,959			
}