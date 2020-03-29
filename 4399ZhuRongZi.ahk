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
global StockPos := ["184, 415","292, 415","440, 415","202, 572"]                       		; 注资的三个框
global BtnArray := {okbtn: "324, 602", kejicomp: "690,519", clobtn: "480, 266", rzyes:"329,555", rzok: "483, 320"} ;button positions
global s :={short: "200", mid: "500", long: "1000", longer: "2000", longest: "3000"}        ;sleep interval times

;272, 302 (recommended) Color:	FFF8CE ;  212, 574 (recommended)Color:	FDFBF0

ZorR = % (A_Args[1]="") ? "Z" : A_Args[1]  ;注资或融资，或两个都要
Arrayflag = % (A_Args[2]="") ? "L" : A_Args[2]  ;SF27_01-06(L)

logfilename := % logPath . "\\ZhuZiRongZi" . A_now . ".txt"
LogToFile("Log file started...")
logcontent := % ZorR
LogToFile("Params: 1: " . ZorR . ", 2: " . Arrayflag)

winName := "xiaoxiaoshoufu"

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
if (Arrayflag = "X")		;just one user
	IniRead, SeqList, config.ini, account, X
Else if (Arrayflag = "L") 	;01-06
	IniRead, SeqList, config.ini, account, L
Else 
	SeqList :=""
ArraySeq := StrSplit(SeqList,",")

For index, value in ArraySeq
{
	WinClose, %winName%
	sleep 200
	Launch4399Game(value,winName)
	WinSet, AlwaysOnTop, on, %winName%	
	LogToFile("Launch4399Game done")
	sleep 200
	Try 
	{
		if (ZorR="Z") 						;注资
		{
			if (Mod(index,2) = 1)   		;分开注，以免所有号注到一起
				ZhuZi(1,16)					;注数这里是 hard code, 如需要可以不同账号注不同的数量
			else 
				ZhuZi(3,16)
		}
		Else if (ZorR="R") 					;融资
			RongZi()
		Else if (ZorR="ZR" or ZorR="RZ") 	;注资和融资
		{
			if (Mod(index,2) = 1)
				ZhuZi(1,16)
			else 
				ZhuZi(3,16)

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


WinSet, AlwaysOnTop, off, %winName%	
WinClose, %winName%
sleep 200
WinClose 360游戏大厅
LogToFile("Log End.")
MadeGif("ZhuRongZi")
ExitApp

ZhuZi(seq,zhu)
{
	click % HB[5] ;商会button
    sleep, % s["short"]
    click % SB[2] ;注资button
    sleep, % s["long"]
	CloseAnySubWindow()
	CaptureScreen()
	loop 8		;有可能有红包挡住，等几秒钟再试
	{
		if PixelColorExist("0xFFF8CE",272, 320,10)
    		Break
		else
			sleep, % s["mid"]
	}
	if PixelColorExist("0xFFF8CE",272, 302,100) ; 还没有注过资.
	{
		loop %zhu%
		{
			click % StockPos[seq]
			sleep 50
		}
		sleep % s["short"]
		click % BtnArray["rzok"]
		sleep, % s["short"] 
		click % BtnArray["okbtn"]
		LogToFile("zhuzi done for seq: " seq)
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
	CloseAnySubWindow()
	click % HB[5] ;商会button
    sleep, % s["short"]
    click % SB[4] ;注资button
    sleep, % s["long"]
	CaptureScreen()
	;BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]; 企业 coordinates
	;先判断是否有其他人融资过，如果有，跟着别人注，如果没有，默认注中间的企业
	if PixelColorNotExist("0xCDCDCD",156, 514,500) ;查看连接到游乐的融资线是否存在
		RongZiOper(1,15)
	else if PixelColorNotExist("0xABA9A5",166, 737,500) ;能源
		RongZiOper(4,15)
	else if PixelColorNotExist("0xCCCCCC",252, 631,500) ;金融
		RongZiOper(3,15)
	else if PixelColorNotExist("0x7DAECA",321, 734,500) ;洒店
		RongZiOper(5,15)
	else if PixelColorNotExist("0xCCCCCC",362, 483,500) ;科技
		RongZiOper(2,15)
	Else
	{
		RongZiOper(3,15)
		LogToFile("The first one to RongZi 3, done.")		
	}
}

RongZiOper(seq,zhu) ;融资操作
{
	click % BC[seq]
	sleep , % s["short"]
	CaptureScreen()
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
		LogToFile("RongZi done for " seq)
	}
	else
		LogToFile("RongZi already done yet, no need do again." seq)
}

F10::Pause   ;pause the script
F11::ExitApp ;stop the script
