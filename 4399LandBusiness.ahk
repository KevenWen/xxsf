#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force
#Include Functions.ahk
SetBatchLines -1

CoordMode, Pixel, window
CoordMode, Mouse, window

Arrayflag = % (A_Args[1]="") ? "XXL" : A_Args[1]  ;ArraySeq value

logfilename := % logPath . "\\LandBusiness" . A_now . ".txt"
LogToFile("Log file started...")
LogToFile("Params: " . A_Args[1])

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
if (Arrayflag = "M")		;just one user
	IniRead, SeqList, config.ini, account, M
if (Arrayflag = "H")		;users before rong zi
	IniRead, SeqList, config.ini, account, H	
Else if (Arrayflag = "XXL") 	;users after rong zi
	IniRead, SeqList, config.ini, account, XXL
Else if (Arrayflag = "XXXL") 	;land bussiness account list, not rong zi day list
	IniRead, SeqList, config.ini, account, XXXL		
Else 
	SeqList :=""
ArraySeq := StrSplit(SeqList,",")

global LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
global winName := "xiaoxiaoshoufu"

For index, value in ArraySeq
{
	Try 
	{
		Gosub, PrepareGame
		SendMode Event
		; 18-xhhz, 20-02,24-yun, 25-long,26-hou, 27-supper
		Switch value
		{
			Case 18:
				Dican(40)
			Case 20:
				Dican(38)
			Case 24:
				Dican(40)				
			Case 25:
				Dican(38)
			Case 26:
				Dican(38)							
			Case 27:
				Dican(40)
		}
		SendMode Input	
	}
	Catch e
	{
		CaptureScreen()	
		LogToFile(e)
	}
	CaptureScreen()	
	WinClose, %winName%
	sleep 200
}

CaptureScreen()	
WinSet, AlwaysOnTop, off, %winName%	
LogToFile("Log end.")
WinClose, % winName
sleep 200
WinClose 360游戏大厅
MadeGif("LandBusiness")
ExitApp

PrepareGame:
	IfWinNotExist, %winName%
	{
		Launch4399Game(value,winName)
	}
	Else
	{
		WinActivate, %winName%
		Winmove,%winName%,,829,23,600,959
		CloseAnySubWindow()
		click 85, 895
		sleep 200
	}
	LogToFile("Launch4399Game done")
	sleep 200
Return

Dican(num)
{
	loop
	{
		click 153, 889
		sleep 500	
		;Sometimes the close window function not work so need double check again.
		if PixelColorExist("0xFFFEF5",390, 190,1000)
			break
		else if A_Index > 5
		{
			CaptureScreen()
			throw "Not able to open tou zi page."
			break
		}		
		CloseAnySubWindow()
	}
	sleep 100
	Mousemove,510, 825
	send {LButton down}
	Mousemove,510, 95,10
	send {LButton up}
	click 510, 825
	sleep 200
	CaptureScreen()
	loop 25
	{
		CloseAnySubWindow()
		ImageSearch, Px, Py, 113, 429, 504, 827, % A_ScriptDir . "\\blockofyellow.bmp"
		if (ErrorLevel = 2)  ;Execption when conduct the search
			throw "ImageSearch not work, please check." 
		else if (ErrorLevel = 1) ;Image not found 
		{
			Mousemove,510, 825
			send {LButton down}
			Mousemove,510, 345,15
			send {LButton up}
			click 510, 825			
			sleep 200
		}
		else if (ErrorLevel = 0) and !PixelColorExist("0x706B59",424, 286,10) ;Image found and not on the first line
		{
			LogToFile("Image found when loop times: " . A_Index)
			CaptureScreen()	
			loop 2
			{
				try
				{
					click %Px%, %Py%
					sleep 200
					DiCcanJinzhu(num)
					break					
				}
				Catch e
				{
					CaptureScreen()
					CloseAnySubWindow()
					LogToFile("Land business meet an exception: " e)
				}					
			}

			LogToFile("Land business done, num is " . num)
			break
		}
		sleep 200		
	}
}

DiCcanJinzhu(num)
{
	if PixelColorExist("0xFFFEF5",185, 469,1000) 
	{
		Mousemove,255, 460
		click, % round(num/2)+2 ;金币注经营资源
		sleep 100
		Mousemove,255, 520
		click, % round(num/2)-3 ;金币注管理资源
		sleep 100
		Mousemove,414, 520
		click, 6				;资源卡注管理资源
		sleep 100
		Mousemove,330,580
		click, 5				;5份钻石注决策资源
		CaptureScreen()	
		sleep 100
		click 361, 704			;确认注入
		sleep 100
		if PixelColorExist("0xFBFBFB",462, 396,500) ;确认注入提示框
		{
			click 302, 593 ;点击确定
			sleep 300
			if PixelColorExist("0x5A7965",329, 284,10)
				throw "Exception while DiCcanJinzhu1."
			
			WaitPixelColorAndClick("0xFBFBFB",479, 192,200)
			CaptureScreen()	
		}	
		else
			throw "Exception while DiCcanJinzhu2."
	}
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
