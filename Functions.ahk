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



/*
uname_l :={}
uname_a := StrSplit(seqname,",")
Loop % uname_a.MaxIndex()
{
    uname_tem := StrSplit(uname_a[A_Index],":")
    uname_l.InsertAt(1, % uname_tem[1] . ":" . uname_tem[2])

    MsgBox, Color number %A_Index% is %uname_l%.
    ExitApp
}
*/
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times


global	HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
global	SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons
global	BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                       ; 5个企业 coordinates
global	TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                       ; Tooltip positions
global	PopWin := {okbtn: "324, 602", clobtn: "480, 266"}           						 ; button positions
global	RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}
global StockPos := ["184, 415","292, 415","440, 415","202, 572"]                       		; 注资的三个框
global BtnArray := {okbtn: "324, 602", kejicomp: "690,519", clobtn: "480, 266", rzyes:"329,555", rzok: "483, 320"} ;button positions
global	OpenSJList := ["403, 330","403, 444","403, 675","403, 753"]
global uname_l := {27:"supper",24:"yun",25:"long",20:"song"}
global LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]

/*
s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ; sleep interval times
HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons
	BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                       ; 5个企业 coordinates
TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                       ; Tooltip positions
	PopWin := {okbtn: "324, 602", clobtn: "480, 266"}           						 ; button positions
	RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}
 StockPos := ["184, 415","292, 415","440, 415","202, 572"]                       		; 注资的三个框
 BtnArray := {okbtn: "324, 602", kejicomp: "690,519", clobtn: "480, 266", rzyes:"329,555", rzok: "483, 320"} ;button positions
	OpenSJList := ["403, 330","403, 444","403, 675","403, 753"]
 uname_l := {27:"supper",24:"yun",25:"long",20:"song"}
 LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
*/


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
    FormatTime, CurrentDateTime,, HH:mm:ss
    ;LogFileName := % logPath . "\\logfile.txt"  ; This global variable was previously given a value somewhere outside this function.
    FileAppend, % CurrentDateTime . ": " . TextToLog . "`n", % logPath . "\\logfile.txt"
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