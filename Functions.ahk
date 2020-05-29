#SingleInstance, Force
SetBatchLines, -1
;SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.

global 4399GamePath = ""
global recorderpath = ""

global idTable := {}
global numTable := {}

IniRead, 4399GamePath, config.ini, path, 4399GamePath
IniRead, recorderpath, config.ini, path, recorderpath

IniRead, content, config.ini, users/num                 ;取用户信息，显示于taskui界面上
Loop, Parse, Content, `n, `r
{

    ; ignore all commented lines
    If RegExMatch(A_LoopField, "^\s*;")
        Continue

    ; split the line into $Key and $Value
    RegEx := "^(?P<Key>[^=]*?)=(?P<Value>.*)"
    If RegExMatch(A_LoopField, RegEx, $)
    {
        IDZS := StrSplit($Value,"/")
        idTable[$Key] := IDZS[1]
        numTable[$Key] := IDZS[2]
    }
}

;======================== some common positions ==============================

global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}                ; sleep interval times

global	HB := ["70, 910","145, 910","225, 910","305, 910","380, 910","445, 910"]                    ; home buttons
global	SB := ["100, 260","230,260","330,260","420,260"]                                            ; shanghui buttons
global	BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                              ; 5个融资企业位置
global	PopWin := {okbtn: "324, 608", clobtn: "480, 266",qhclobtn: "500, 266",zhuziok: "507, 320"}  ; button positions
global	RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}                      ; 融资的按钮
global  StockPos := ["155, 415","310, 415","460, 415"]                       		                ; 注资的三个框
global	OpenSJList := ["403, 330","403, 444","403, 675","403, 753"]
global  LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]              


;======================== color related functions ==============================

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
            throw, % "WaitPixelColor conduct has error, desired color: " . p_DesiredColor
        If ( l_OutputColor = p_DesiredColor )
        {
            sleep 100
            Return 1            
        } 
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            throw, % "WaitPixelColor has error, desired color: " . p_DesiredColor
    }
}

WaitPixelColorNotExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=10) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB
        If ( ErrorLevel ) ;Not found 
			throw, % "WaitPixelColorNotExist conduct has error, desired color:" . p_DesiredColor
        If ( l_OutputColor = p_DesiredColor ) ;Still found
            sleep 50 ;same
		Else
			break	;not same
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut) ;Timeout
  			throw, "WaitPixelColorNotExist has error, desired color:" . p_DesiredColor
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
				Throw, % "WaitPixelColorAndClickErrorLevel conduct, desired color:" . p_DesiredColor

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
				Throw, % "WaitPixelColorAndClickTimeOut, desired color:" . p_DesiredColor
    }
}

;================================= recording  functions ===================================

GameRecordingOn()
{
    if !FileExist(recorderpath)
        return
	try
	{
        Run, % recorderpath
        loop
        {
            IfWinActive, ahk_class TfrmMain
                break
            if A_index > 10
                throw, "Run game recorder time out!"
            sleep 1000
        }
        sleep 200
        send {F9}
        sleep 200
        WinMinimize, ahk_class TfrmMain ;minimize the TfrmMain window
        LogToFile("Game Recording On.")
	}
	catch e
	{
		;Ignore the error here.
		LogToFile("Game recording turn on failed: " . e)
	}
}

GameRecordingOff()
{
    send {F11}
    sleep 2000      
    Process, Close, gamerecorder.exe
    LogToFile("Game Recording Off.")
}

;================================= Log  functions ===================================

LogToFile(TextToLog)
{
    try{
    FormatTime, CurrentDateTime,, HH:mm:ss
    FormatTime, Dayfolder,, yyyyMMdd
    if TextToLog = ""
        FileAppend, % "`n", % A_ScriptDir . "\\log\\" . Dayfolder .  "_log.txt"
    Else
        FileAppend, % CurrentDateTime . ": " . TextToLog . "`n", % A_ScriptDir . "\\log\\" . Dayfolder .  "_log.txt"
    }
    catch e {
        ;Nothing need do here
    }
}

; ==============================  Start game without create user ojbect =============================

Launch4399GamePri(windowname,Sequ)
{
    IfWinExist %windowname%
    {
        WinActivate %windowname%
        Return
    }

    run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
    sleep 4000
    WinGetActiveTitle, Title    ;Title is very important!!! make sure everytime the title is correct.
    if !InStr(Title, "xiaoxiao")
        MsgBox, "The active windows is not named xiaoxiaoshoufu" 
    WinSetTitle,%Title%,, %windowname%
    Winmove,%windowname%,,829,23,600,959			
}

; =======================================  Time related ====================================

    WaitForTime(eTime, plusday=1) { 
    eTime := A_YYYY A_MM A_DD SubStr(eTime, 1 ,2) SubStr(eTime, 3 ,2) (SubStr(eTime, 5, 2) ? SubStr(eTime, 5, 2) : "00")
    if (A_Now > eTime and plusday)  ; if eTime is past, set for tomorrow at eTime
        eTime += 1, day
    TimeToSleep := eTime
    TimeToSleep -= A_Now, seconds
    Sleep, % TimeToSleep * 1000    
    FormatTime, current, A_Now, HHmmss ; optional - comment out if you don't need the current time returned
    Return, current
    }

    WaitTime(eTime, plusday=1) { 
    eTime := A_YYYY A_MM A_DD SubStr(eTime, 1 ,2) SubStr(eTime, 3 ,2) (SubStr(eTime, 5, 2) ? SubStr(eTime, 5, 2) : "00")
    if (A_Now > eTime and plusday)  ; if eTime is past, set for tomorrow at eTime
        eTime += 1, day
    TimeToSleep := eTime
    TimeToSleep -= A_Now, seconds
    Return, TimeToSleep
    }