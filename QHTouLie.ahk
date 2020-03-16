#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;#NoTrayIcon				; No system tray icon
#SingleInstance force  
#Include QHFunctions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window

fromList = % (InStr("blackchatlieshou", A_Args[1]) and A_Args[1] !="") ? A_Args[1] : "black"  ;black/chat/lieshou

global LieshoucoList := ["538,279","538,356","538,428","538,506","538,576","538,647"]


Try 
{
	Gosub, PrepareStolen
	Gosub, NiuShiOpen
	Gosub, SelectPeopleAndstolen 
}
Catch e
{
	CaptureScreen()	
}
CaptureScreen()	
;WinClose, xxsf



CaptureScreen()	
WinSet, AlwaysOnTop, off, xxsf
MadeGif("TouLieQH")
sleep 200
ExitApp

PrepareStolen:
	winName := "xxsf"
	IfWinNotExist, %winName%
		LaunchqhGame()

	WinActivate, %winName%
	WinSet, AlwaysOnTop, on, %winName%	
	sleep 200
return

NiuShiOpen:
	try{
		SuanKaiqh() 
	}
	catch e
	{				
		CaptureScreen()	
		;WaitPixelColorAndClick("0xFBFBFB",479, 397,20)
		;WaitPixelColorAndClick("0xFBFBFB",500, 224,20)
		sleep 100
		click 47, 917	
		sleep 100			
	}
Return


SelectPeopleAndstolen:
n :=1
SuccessCount :=1
while (n<7 and SuccessCount<6)
{
	;CloseAnySubWindow()
	sleeptime := n=1? 500:400
	sleep %sleeptime%

	(fromList = "lieshou")?(OpenTouLiePage(n))
	:((fromList = "chat")?(OpenTouLiePageFromChatList(n))
	:(OpenTouLiePageFromBlackList(n)))

	CaptureScreen()	
	try
	{
		sleep 200
		TouLieOpration()	
		SuccessCount++	
	}
	catch e ;Ignore any error during one operation and go ahead to next one.
	{
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

	sleep 300
	click 49, 918
	sleep 200
	click 49, 918
	sleep 500
	WaitPixelColorAndClickThrowErr("0xE03720",217, 923,2000) ;LieShou button
	sleep 100


	if PixelColorExist("0xF39081",77, 175,100) ;Return button if exist.
		{
			click 77, 175
			sleep 500
		}
	/*
	if PixelColorExist("0xFBFBFB",459,399,100) ; Houbao window or shangzhan window if exist.
		{
			click 459,399
			sleep 500
		}	
	*/
	CloseQHSubWindowquick()
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
	;click 461, 321 ;Close card page
	sleep 200
	if PixelColorExist("0xFBFBFB",482, 397,100) ; Hongbao window or shangzhan window if exist.
	{
		click 482, 397
		sleep 300
	}	

	click 42, 915
	sleep 400
	;click 501,252
	WaitPixelColorAndClickThrowErr("0xD26D24",570, 257,2000) ;HaoYou button
	sleep 400
	WaitPixelColorAndClickThrowErr("0xFFFFFF",463, 800,2000) ;BlackList button
	sleep 600

	if PixelColorExist("0xFBFBFB",482, 397,100) ; Hongbao window or shangzhan window if exist.
		{
			click 482, 397
			sleep 300
		}	

	; Click corresponding people FFF8CE

	if Num=1
	{ 
		WaitPixelColorAndClickThrowErr("0x6EEACE",482, 366,1000) ;Click people in the blacklist
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		return 
	} 

	if Num=2
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",477, 436,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		return 
	}

	if Num=3
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",477, 504,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 
	
	if Num=4
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",477, 574,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 		
	
	if Num=5 
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",477, 645,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}

		if Num=6 
	{
		WaitPixelColorAndClickThrowErr("0x6EEACE",477, 713,1000)
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}
}

OpenTouLiePageFromChatList(Num)
{
	;click 461, 321 ;Close card page
	sleep 200
	if PixelColorExist("0xFBFBFB",482, 397,100) ; Hongbao window or shangzhan window if exist.
		{
			click 482, 397
			sleep 300
		}	

	click 42, 915
	sleep 400
	;click 501,252
	WaitPixelColorAndClickThrowErr("0xD26D24",570, 257,2000) ;HaoYou button
	sleep 500
	WaitPixelColorAndClickThrowErr("0xFFFFFF",366, 799,2000) ;Chat List button
	sleep 1000
	;MouseClickDrag, Left, 371, 691,371, 688,30
	;sleep 1000

	if PixelColorExist("0xFBFBFB",482, 397,100) ; Hongbao window or shangzhan window if exist.
		{
			click 482, 397
			sleep 300
		}

	; Click corresponding people FFF8CE  675 608 540 472
	if Num=1
	{ 
		WaitPixelColorAndClickThrowErr("0xFFFFF3",421, 659,1000) ;Click people in the Chat list
		sleep 500	
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 

	if Num=2
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",391, 57,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}

	if Num=3
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",378, 503,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 
	
	if Num=4
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",403, 415,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	} 		
	
	if Num=5 
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",371, 340,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}

	if Num=6 
	{
		WaitPixelColorAndClickThrowErr("0xFFFFF3",393, 290,1000) ;Click people in the Chat list
		sleep 500
		WaitPixelColorAndClickThrowErr("0x6DE9CF",206, 620,2000) ;TouLie Button	in People Page
		sleep 100
		return 
	}
}


TouLieOpration()
{
	if !PixelColorExist("0x74BDFA",459, 529,3000)
		throw "Not able to open people Stolen page!"

	if PixelColorExist("0xFFFEF5",276, 609,10) and PixelColorExist("0xFFFFFF",350, 790,10)
	{
		click 324, 815 ;start TouLie Button		
		sleep 1000

		if PixelColorExist("0xFBFBFB",489, 385,10) ; >5 times, the window ask for 500 money.
		{
			mousemove 489, 385
			click
			throw ">5 times, the window ask for 500 money."
		}
		WaitPixelColorAndClickThrowErr("0x2A1E17",315, 745,3000) ;进度条出现
		Loop
		{
			if PixelColorExist("0xFEC120",425, 765,1) ;进度条到了		
				break
			if PixelColorExist("0xE2413E",337, 635,1) ;OK button
				break
			if A_Index > 10  ;Total 20 loop times
				break
			sleep 30	
			Mousemove 324, 815
			click 20
		}	 
		;click 461, 321 ; Close the get card page
	}
	Else
	{
		throw "Already stoled in hours or the target is full!"
	}
}


F10::Pause   ;pause the script
F11::ExitApp ;stop the script