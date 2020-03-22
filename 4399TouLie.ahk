#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include Functions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

fromList = % (InStr("blackchatlieshou", A_Args[1]) and A_Args[1] !="") ? A_Args[1] : "black"  ;black/chat/lieshou
isLaunch = % (A_Args[2]="") ? "launch" : A_Args[2]   ;launch/launch2/nolaunch
Arrayflag = % (A_Args[3]="") ? "XL" : A_Args[3]  ;ArraySeq value

logfilename := % "E:\\AhkScriptManager-master\\log\\Toulie_blackList" . A_now . ".txt"
LogToFile("Log file started...")
logcontent := % fromList . isLaunch . winName
LogToFile("Params: " . logcontent)

ArraySeq := []
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
if (Arrayflag = "L")
	ArraySeq := [19,21,22,23,35] 
Else if (Arrayflag = "S")  ;special
	ArraySeq := [26,20,25]
Else if (Arrayflag = "XL")
	ArraySeq := [20,25,19,21,22,23,35]	
Else if (Arrayflag = "XXL")
	ArraySeq := [20,19,21,22,23,35]
Else if (Arrayflag = "M") ;only xhhz
	ArraySeq := [20]

global LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
global winName := "xiaoxiaoshoufu"

For index, value in ArraySeq
{
	Try 
	{
		if (isLaunch="launch2")
			Gosub, PrepareStolenLaunch2
		Else
			Gosub, PrepareStolenLaunch

		Gosub, NiuShiOpen
		Gosub, SelectPeopleAndstolen 
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
LogToFile("Footer text to appear at the very end of your log, which you are done with.")
MadeGif("TouLie")
WinClose, % winName
sleep 200
WinClose 360游戏大厅
ExitApp

PrepareStolenLaunch:
	/*WinClose, %winName%
	sleep 200
	Launch4399Game(value,%winName%)
	WinSet, AlwaysOnTop, on, %winName%	
	*/
	IfWinNotExist, %winName%
	{
		Launch4399Game(value,winName)
	}
	Else
	{
		WinActivate, %winName%
		sleep 200
	}	

	LogToFile("Launch4399Game done")
	sleep 200
	try 
	{		
		GetCaiTuanMoney()
		LogToFile("GetCaiTuanMoney done!")
	}
	catch e
	{
		LogToFile(e)
	}
Return

PrepareStolenLaunch2:
	WinClose, %winName%
	sleep 200
	Launch4399Game(value,winName) ; launch twice, In case too many pop out window.
	sleep 10000
	WinClose, %winName%
	sleep 200	
	Launch4399Game(value,winName)
	WinSet, AlwaysOnTop, on, %winName%	
	LogToFile("Launch4399Game done")
	sleep 200
	try 
	{
		GetCaiTuanMoney()
		LogToFile("GetCaiTuanMoney done!")
	}
	catch e
	{
		LogToFile(e)
	}
Return

NiuShiOpen:
	try{
		SuanKai() 
		LogToFile("SuanKai done!")
	}
	catch e
	{				
		CaptureScreen()	
		WaitPixelColorAndClick("0xFBFBFB",463, 396,20)
		WaitPixelColorAndClick("0xFBFBFB",480, 229,20)
		sleep 100
		click 91, 891	
		sleep 100			
		LogToFile(e)
	}
Return


SelectPeopleAndstolen:
n :=1
SuccessCount :=1
while (n<7 and SuccessCount<6)
{
	;CloseAnySubWindow()
	sleeptime := n=1? 500:600
	sleep %sleeptime%

	(fromList = "lieshou")?(OpenTouLiePage(n))
	:((fromList = "chat")?(OpenTouLiePageFromChatList(n))
	:(OpenTouLiePageFromBlackList(n)))

	CaptureScreen()	
	try
	{
		sleep 500
		TouLieOpration()	
		SuccessCount++	
		LogToFile("Stolen one`n")
	}
	catch e ;Ignore any error during one operation and go ahead to next one.
	{
		LogToFile("Exception within ToulieOpreation.")		
		LogToFile(e)		
	}	
	Finally 
	{
		CaptureScreen()	
		n++
	}  
}
return

;Functions:
OpenTouLiePage(Num)
{
	;if (%Num%>5) throw "Num bigger than 5" 
	click 461, 321 ;Close card page
	;WaitPixelColorAndClickThrowErr("0xECD924",90,895,1000) ;Shop button
	sleep 300
	click 90,895
	sleep 200
	click 90,895
	sleep 500
	;click 501,252
	WaitPixelColorAndClickThrowErr("0x2E3030",212, 879,2000) ;LieShou button
	sleep 500

	if PixelColorExist("0xF39181",126, 187,100) ;Return button if exist.
		{
			click 126, 187
			sleep 500
		}
	
	if PixelColorExist("0xFBFBFB",459,399,100) ; Houbao window or shangzhan window if exist.
		{
			click 459,399
			sleep 500
		}	
	; Click corresponding people 
	click % (Num=1)?(LieshoucoList[1])
	:((Num=2)?(LieshoucoList[2])
	:((Num=3)?(LieshoucoList[3])
	:((Num=4)?(LieshoucoList[4])
	:((Num=5)?(LieshoucoList[5])
	:(LieshoucoList[6])))))
	Return
}

OpenTouLiePageFromBlackList(Num)
{
	;if (%Num%>5) throw "Num bigger than 5" 
	click 461, 321 ;Close card page
	sleep 200
	if PixelColorExist("0xFBFBFB",459,399,100) ; Hongbao window or shangzhan window if exist.
	{
		click 459,399
		sleep 300
	}	

	click 90,895
	sleep 400
	;click 501,252
	WaitPixelColorAndClickThrowErr("0xD26D24",500, 250,2000) ;HaoYou button
	sleep 500
	WaitPixelColorAndClickThrowErr("0xFFFFFF",449, 776,2000) ;BlackList button
	sleep 1000

	if PixelColorExist("0xFBFBFB",459,399,100) ; Hongbao window or shangzhan window if exist.
		{
			click 459,399
			sleep 300
		}	

	; Click corresponding people FFF8CE

	if Num=1
	{ 
		WaitPixelColorAndClickThrowErr("0x6EEACE",455, 373,1000) ;Click people in the blacklist
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		return 
	} 

	if Num=2
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",455, 440,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		return 
	}

	if Num=3
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",455, 507,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 
	
	if Num=4
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",455, 575,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 		
	
	if Num=5 
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",455, 643,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}

		if Num=6 
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",455, 708,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}
}

OpenTouLiePageFromChatList(Num)
{
	click 461, 321 ;Close card page
	sleep 200
	if PixelColorExist("0xFBFBFB",459,399,100) ; Hongbao window or shangzhan window if exist.
	{
		click 459,399
		sleep 300
	}	

	click 90,895
	sleep 300
	;click 501,252
	WaitPixelColorAndClickThrowErr("0xD26D24",500, 250,2000) ;HaoYou button
	sleep 500
	WaitPixelColorAndClickThrowErr("0xFFFFFF",358, 776,2000) ;Chat List button
	sleep 1000
	;MouseClickDrag, Left, 371, 691,371, 688,30
	;sleep 1000

	if PixelColorExist("0xFBFBFB",459,399,20) ; Hongbao window or shangzhan window if exist.
		{
			click 459,399
			sleep 300
		}	

	LogToFile("close any sub window")
	; Click corresponding people FFF8CE  675 608 540 472
	if Num=1
	{ 
		WaitPixelColorAndClickThrowErr("0xFFFFF3",426, 603,1000) ;Click people in the Chat list
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 

	if Num=2
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",440, 536,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}

	if Num=3
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",440, 468,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 
	
	if Num=4
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",440, 401,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 		
	
	if Num=5 
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",440, 333,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}

	if Num=6 
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",440, 266,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}
}


TouLieOpration()
{
	if !PixelColorExist("0x74BDFA",431, 530,3000)
		throw "Not able to open people Stolen page!"

	if PixelColorExist("0xFFFEF5",262, 617,10) and PixelColorExist("0xFFFFFF",318, 784,10)
	{
		click 293, 805 ;start TouLie Button		
		sleep 1000

		if PixelColorExist("0xFBFBFB",463, 395,10) ; >5 times, the window ask for 500 money.
		{
			mousemove 462, 391
			click
			throw ">5 times, the window ask for 500 money."
		}
		WaitPixelColorAndClickThrowErr("0x2A1E17",228, 744,3000)
		Loop
		{
			if PixelColorExist("0xFEC120",440, 742,1) ;进度条到了		
				break
			if PixelColorExist("0xE2413E",334, 611,1) ;OK button
				break
			if A_Index > 10  ;Total 20 loop times
				break
			sleep 30	
			Mousemove 293, 805
			click 20
		}
		sleep 200	 
		click 461, 321 ; Close the get card page
	}
	Else
	{
		throw "Already stoled in hours or the target is full!"
	}
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
