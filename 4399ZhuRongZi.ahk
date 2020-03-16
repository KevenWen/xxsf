#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance force  
#Include Functions.ahk
SetBatchLines -1

CoordMode, Pixel, window  
CoordMode, Mouse, window


global HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
global SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons           
global BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                       ; 企业 coordinates
global StockPos := ["184, 415","292, 415","440, 415","202, 572"]                       					; 注资的三个框
global BtnArray := {okbtn: "324, 602", kejicomp: "690,519", clobtn: "480, 266", rzyes:"329,555", rzok: "483, 320"} ;button positions
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ;sleep interval times

;272, 302 (recommended) Color:	FFF8CE ;  212, 574 (recommended)Color:	FDFBF0

ZorR = % (A_Args[1]="") ? "Z" : A_Args[1]  ;注资或融资，或两个都要
Arrayflag = % (A_Args[2]="") ? "L" : A_Args[2]  ;SF27_01-06(L), or all the users(XL)

logfilename := % "E:\\AhkScriptManager-master\\log\\ZhuZiRongZi" . A_now . ".txt"
LogToFile("Log file started...")
logcontent := % ZorR
LogToFile("Params: " . ZorR)

winName := "xiaoxiaoshoufu"

ArraySeq := []
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
if (Arrayflag = "L")
	ArraySeq := [19,21,22,23,35]
Else if (Arrayflag = "XL")
	ArraySeq := [19,21,22,23,35]	
Else if (Arrayflag = "S")
	ArraySeq := [19]		

For index, value in ArraySeq
{
	WinClose, %winName%
	sleep 200
	Launch4399Game(value,winName)
	WinSet, AlwaysOnTop, on, %winName%	
	LogToFile("Launch4399Game done")
	sleep 200
	Gosub, isResultWinshow
	Try 
	{
		if (ZorR="Z")
		{
			if (Mod(index,2) = 1)
				ZhuZi2(15)
			else 
				ZhuZi3(15)
		}
		Else if (ZorR="R")
			RongZi()
		Else if (ZorR="ZR" or ZorR="RZ")
		{
			if (Mod(index,2) = 1)
				ZhuZi2(15)
			else 
				ZhuZi3(15)

			RongZi()	
		}
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
MadeGif("ZhuRongZi")
WinClose, %winName%
sleep 200
WinClose 360游戏大厅
ExitApp


ZhuZi2(zhu)
{
	click % HB[5] ;商会button
    sleep, % s["short"]
    click % SB[2] ;注资button
    sleep, % s["long"]
	Gosub, isResultWinshow
	if PixelColorExist("0xFFF8CE",272, 302,100) ; 还没有注过资.
	{
		loop %zhu%
		{
			click % StockPos[2]
			sleep 50
		}
		sleep % s["short"]
		click % BtnArray["rzok"]
		sleep, % s["short"] 
		Gosub, isResultWinshow
		click % BtnArray["okbtn"]
		LogToFile("zhuzi2 done.")
	}	
	else
	{
		LogToFile("ZhuZi already done yet, no need do again.")
	}
    sleep, % s["short"]
}


ZhuZi3(zhu)
{
	click % HB[5] ;商会button
    sleep, % s["short"]
    click % SB[2] ;注资button
    sleep, % s["long"]
	Gosub, isResultWinshow
	if PixelColorExist("0xFFF8CE",272, 302,100) ; 还没有注过资.
	{
		loop %zhu%
		{
			click % StockPos[3]
			sleep 20
		}
		sleep % s["short"]
		Gosub, isResultWinshow
		click % BtnArray["rzok"]
		sleep, % s["short"] 
		click % BtnArray["okbtn"]
		LogToFile("zhuzi3 done.")
	}
	else
	{
		LogToFile("ZhuZi already done yet, no need do again.")
	}		
    sleep, % s["short"]
    CaptureScreen()	
}

RongZi()
{
	click % HB[5] ;商会button
    sleep, % s["short"]
    click % SB[4] ;注资button
    sleep, % s["long"]

	;BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]; 企业 coordinates
	if PixelColorNotExist("0xCDCDCD",156, 514,500) ;Youle
	{
		click % BC[1]
		sleep , % s["short"]
		RongZiOper(14)
		LogToFile("RongZi1 done.")
	}
	else if PixelColorNotExist("0xABA9A5",166, 737,500) ;NengYuan
	{
		click % BC[4]
		sleep , % s["short"]
		RongZiOper(14)
		LogToFile("RongZi4 done.")		
	}
	else if PixelColorNotExist("0xCCCCCC",252, 631,500) ;JingRong
	{
		click % BC[3]
		sleep , % s["short"]
		RongZiOper(14)
		LogToFile("RongZi3 done.")		
	}
	else if PixelColorNotExist("0x7DAECA",321, 734,500) ;JiuDian
	{
		click % BC[5]
		sleep , % s["short"]
		RongZiOper(14)
		LogToFile("RongZi5 done.")		
	}
	else if PixelColorNotExist("0xCCCCCC",362, 483,500) ;KeJi
	{
		click % BC[2]
		sleep , % s["short"]
		RongZiOper(14)
		LogToFile("RongZi2 done.")		
	}
	Else
	{
		click % BC[3]
		sleep , % s["short"]
		RongZiOper(14)
		LogToFile("RongZi3 done.")		
	}
}

RongZiOper(zhu)
{
	Gosub, isResultWinshow
	if PixelColorExist("0xFFFEF5",230, 574,100)
	{
		loop %zhu%
		{
			click % StockPos[4]
			sleep 50
		}
		click % BtnArray["rzyes"]
		sleep, % s["short"]
		click % BtnArray["okbtn"]
		sleep, % s["short"]
		if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
		{
			sleep, % s["short"]
			CaptureScreen()	
			click % Arrayhome["clobtn"]
			;winclose, xiaoxiaoshoufu
		}
		LogToFile(%zhu%)
	}
	else
		LogToFile("RongZi already done yet, no need do again.")
}

isResultWinshow:
	if PixelColorExist("0xFBFBFB",472, 397,10)
	{
		click 472, 397
		sleep, % s["short"]
	}
Return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
