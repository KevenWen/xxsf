﻿#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk

class QHsfGame
{

;=========================================  Common functions  ===============================================
	ResizeQHWindow()
	{
		;CoordMode, Pixel, window  
		;CoordMode, Mouse, window
		
		IfWinExist xxsf
		{
			WinActivate
			;Winmove,xxsf,,933,19,628,937
			Winmove,xxsf,,933,19,600,959
		}		

	}

	PrepareGameWindow()
	{
		IfWinExist, xxsf
        {
			WinActivate, xxsf
			sleep 200
		}
		Else
			throw "Game not existing!"
	}

	GetShoppage(){

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
			Winmove,xxsf,,933,19,600,959

			sleep 3000 ;Waiting for start button
			if PixelColorExist("0x41B6AC",368, 783,18000)
			{
				this.CloseQHMenu()	
				sleep 200
				click 368, 783 ;click the start button
			}
			Else If PixelColorExist("0xFE901A",365, 541,100)
			{
				click 365, 541 ;click the account button
				sleep 500
				click 356, 545 ;click the manully login button
				sleep 500

				if PixelColorExist("0x41B6AC",368, 783,18000)
				{
					this.CloseQHMenu()	
					sleep 200
					click 368, 783 ;click the start button
				}
				Else
					Continue
			}
			Else		
				Continue

			sleep 5000 ;Waiting for pop out window

			this.CloseAnySubWindow()
			sleep 200

			if !PixelColorExist("0xEFFEFF",56, 920,100) ; double check again on the shop button
			{
				CaptureScreen()
				Continue
			}

			break
		}	
	}

	GetQHCaiTuanMoney()
	{
		WaitPixelColorAndClickThrowErr("0x3E515C",290, 914,2000) ;cai tuan button
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFFCF6",552, 230,2000) ;Shou Ru button	
		sleep 100
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\\blockofwhite.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
				Break
			else if (ErrorLevel = 0) ;Image found
			{
				if PixelColorExist("0x1657B0",335, 421,10) ;Daily awards
				{
					click 446, 416
					sleep 100
					click 446, 503
					sleep 100
					click 446, 589
					sleep 100
				}
				if PixelColorExist("0xFBFBFB",500, 216,20) ;限时活动
				{
					click 445, 480
					sleep 100
					click 436, 383
					sleep 100				
				}
				
				click %Px%, %Py%
				sleep 200
			}
			sleep 100
		}	
	}

	CloseSpeSubWindow(n)
	{
		loop %n%
		{
			ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\\blockofwhite.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
				Break
			else if (ErrorLevel = 0) ;Image found
			{
				click %Px%, %Py%
				sleep 200
			}
			sleep 100
		}	
	}

	SubWindowExist()
	{
		ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\\blockofwhite.bmp"
		if (ErrorLevel = 2)  ;Execption when conduct the search
			return 0
		else if (ErrorLevel = 1) ;Image not found 
			return 0
		else if (ErrorLevel = 0) ;Image found
			return 1
	}


	CloseQHMenu()
	{
		if PixelColorExist("0xF7EF5F",566, 572,1000) ;群黑图标
		click 566, 572
		sleep 500
		click 561, 639
		sleep 200
	}	

;=========================================  land functions  ===============================================
	GetLandpage(){
		loop{
            if A_Index > 2
                throw "Not able to GetLandPage."
            this.closeAnySubWindow()
            click % HB[1]
            sleep 200
            click % HB[2]
            sleep 200
            if PixelColorExist("0x706B59",398, 288,2000)		;升级button 旁边的灰色条	
                Break
        } 
	}

	DiCanJinzhu()
	{
		this.GetLandpage()
		sleep 100
		SendMode Event
		loop 2
		{
			Mousemove,570, 840
			send {LButton down}
			Mousemove,570, 300,6
			sleep 100	
			send {LButton up}
			click 570, 840
			sleep 200
		}
		CaptureScreen()
		loop 15
		{
			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 113, 429, 504, 817, % A_ScriptDir . "\\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 		
			else if (ErrorLevel = 1) ;Image not found 
			{
				Mousemove,570, 824
				send {LButton down}
				Mousemove,570, 500,2
				send {LButton up}
				click 570, 824
				sleep 200
			}
			else if (ErrorLevel = 0) and !PixelColorExist("0x706B59",455, 284,10) ;Image found and not on the first line
			{
				CaptureScreen()	
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",190, 480,1000) 		;经营资源输入框存在
				   and PixelColorExist("0x5A7965",331, 353,10)     ;且上面图片显示是闲置土地
				{
					click,265, 465, 23 ;金币23
					sleep 100
					click,265, 530, 17 ;金币17
					sleep 500
                    if !PixelColorExist("0xFEEDC7",119, 391,10) and !PixelColorExist("0xFEEDC7",478, 391,10) ;左右两边都没有显示金钱不够提示
                        throw "Not enough money warning show!"
					click,433, 530, 3 ;资源卡6
					sleep 100
					click,350, 594, 3  ;5份钻石注决策资源
					CaptureScreen()
					sleep 100
					click 376, 723	;确认注入
					sleep 100
					if PixelColorExist("0xFBFBFB",478, 396,300) ;确认注入提示框
                    {
                        click 305, 611     ;点击确定      
                        WaitPixelColorAndClick("0xFBFBFB",495, 180,1000)
                    }
					else
                    {
    					CaptureScreen()
                        LogToFile("Exception while QHDiCcanJinzhu: not found the OK button") 
					}
				}
				else
				{
                    LogToFile("0xFFFEF5 and 0x5A7965 exception.")
                    CaptureScreen()
				}

                if !PixelColorExist("0xF7D04A",Px, Py,200)  ;double check 
                {
                    CaptureScreen()
                    LogToFile("QH Land business done.")
                    Break  
                }
			}
			sleep 200		
		}
		SendMode Input		
	}

;=========================================  group functions  ===============================================

	GetGroupPage(){
		loop{
			if A_Index > 2
				throw "Not able to GetGroupPage, PixelColorExist 0xFFFEF5 492 354 not exist."
			this.closeAnySubWindow()
			click % HB[5]
			sleep 100			
			if PixelColorExist("0xFFFEF5",550, 354,2000)			;白色人数框
				break
		}
	}

	GetGroupPage2(){
		this.GetGroupPage()
		click % SB[2]
		WaitPixelColor("0xFFFEF5",186, 420,2000)			;白色总股份资本框
	}

	GetGroupPage4(){
		this.GetGroupPage()
		click % SB[4]
		WaitPixelColor("0x91B65A",491, 349,2000)			;科技企业后的绿色
	}

	GroupZhuZi(which)
	{
		this.GetGroupPage2()
		CaptureScreen()
		loop 8		;有可能有红包挡住，等几秒钟再试
		{
			if PixelColorExist("0xFFF8CE",250, 320,10)
				Break
			else
				sleep, % s["mid"]
		}
		if PixelColorExist("0xFFF8CE",211, 302,100) ; 还没有注过资.
		{
			loop 42
			{
				click % StockPos[which]
				sleep 50
			}
			sleep % s["short"]
			click % PopWin["zhuziok"]
			sleep, % s["short"] 
			click % PopWin["okbtn"]
			LogToFile("zhuzi done at: " . which . ", num: " . num)
		}	
		else
			LogToFile("ZhuZi already done yet, no need do again.")

		sleep, % s["short"]
		CaptureScreen()
	}
/*
	;Functions:
	PreRongZi(RZCom)
	{
		click, % BC[RZCom]
		sleep, % s["long"]
		; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper
	; TTCo := StrSplit(PopWin["rzarea"],",")
		mousemove, 239, 570
		sleep, % s["short"]
		click,40
		sleep, % s["mid"]
		
		if !PixelColorExist("0xFFFFFF",121, 358,10) ;存在没有更多金币提示，problem here!
			Throw, "Not enough money warnning exist!"

		click % RZWin["yesbtn"]    
	}

	CheZi()
	{
		Loop 5
		{
			click % BC[A_index]
			sleep, % s["long"]
			if PixelColorExist("0xFBFBFB",500, 265,1000)   
			and PixelColorExist("0xFFFEF5",216, 585,20) 
			and PixelColorExist("0xFFFEF5",235, 586,20)     ;窗口打开，没有融资，带有0，且只有两个字符
			{
				click % PopWin["qhclobtn"]
				sleep, % s["long"]
				Continue 1
			}
			Else
			{
				click % RZWin["chezibtn"]
				sleep, % s["long"]
				click % PopWin["okbtn"] 
				sleep, % s["longer"]
				click % PopWin["qhclobtn"]
				sleep, % s["longer"]
				Break 1 
			}
		}
	}
*/
	PreRongZi(RZCom)
	{		
		this.GetGroupPage4()

		click, % BC[RZCom]
		sleep, % s["long"]		

		mousemove, 200, 574
		sleep, % s["short"]
		SetDefaultMouseSpeed 10
		click, 40
		SetDefaultMouseSpeed 2		
		sleep, % s["mid"]

		if !PixelColorExist("0xFFFFF3",275, 398,10) ;存在没有更多金币提示.!
			Throw, "Not enough money warnning exist!"    

		sleep, % s["mid"]
		click % RZWin["yesbtn"]
		sleep, % s["short"]
	}

	RongZiOKinternal()
	{
		click % PopWin["okbtn"]
		sleep, % s["mid"]
		CaptureScreen()
		if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
			click % PopWin["qhclobtn"]
	}

    RongZiOKpublic()
	{
		loop 5
		{
			if !this.SubWindowExist()
				break
			if !PixelColorExist("0xD2F3F3",344, 594,10)
				4399sfGame.CloseSpeSubWindow(1)
			if PixelColorExist("0xD2F3F3",344, 594,10)
			{
				click % PopWin["okbtn"]
				sleep, % s["short"]
				click % PopWin["okbtn"]
				sleep, % s["short"]
				CaptureScreen()
			}	
		}
	}

;----------------------------------
/*
	GroupCheZi()
	{
		this.GetGroupPage4()
		Loop 5
		{
			click % BC[A_index]
			sleep, % s["long"]
			if PixelColorExist("0xFBFBFB",480, 269,1000)   
			and PixelColorExist("0xFDFBF0",212, 573,10) ;FDFBF0
			and PixelColorExist("0xFFFEF5",230, 574,10)     ;窗口打开，没有融资，带有0，且只有两个字符
			{
				click % PopWin["clobtn"]
				sleep, % s["long"]
				Continue
			}
			Else
			{
				click % RZWin["chezibtn"]
				sleep, % s["long"]
				click % PopWin["okbtn"] 
				sleep, % s["longer"]
				click % PopWin["clobtn"]
				sleep, % s["longer"]
				Break   
			}
		}
	}

	PreRongZi(RZCom)
	{		
		this.GetGroupPage4()

		click, % BC[RZCom]
		sleep, % s["long"]		

		mousemove, 200, 574
		sleep, % s["short"]
		SetDefaultMouseSpeed 10
		click, % 4399sfGame.Getzhushu()
		SetDefaultMouseSpeed 2		
		sleep, % s["mid"]

		if !PixelColorExist("0xFFFFF3",268, 396,10) ;存在没有更多金币提示.!
			Throw, "Not enough money warnning exist!"    

		sleep, % s["mid"]
		click % RZWin["yesbtn"]
		sleep, % s["short"]
	}

	RongZiOKinternal()
	{
		click % PopWin["okbtn"]
		sleep, % s["mid"]
		CaptureScreen()
		if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
			click % PopWin["clobtn"]
	}

*/


}







