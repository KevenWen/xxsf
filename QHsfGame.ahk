#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

class QHsfGame
{

;=========================================  Common functions  ===============================================
	PrepareGameWindow(name)
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist		

		WinGetActiveTitle, CurTitle
		if (CurTitle = name)
			Return

		IfWinExist, %name%
        {
			WinSet, AlwaysOnTop, On, %name%
			WinActivate, %name%
			sleep 200
			WinSet, AlwaysOnTop, Off, %name%			
		}
		Else
			throw "Game not existing: " . name
	}

	LaunchQHGame(Sequ,windowname)   ;Be carefull to call this function since it can not detect which sever to load
	{
		Loop
		{
			if A_Index > 3
				{
					break
					throw "Cannot launch qun hei Game!"
				}
			WinClose, %windowname%
			WinClose Cisco AnyConnect	;The VPN windows may exist
			run %4399GamePath% -action:opengame -gid:4 -gaid:%Sequ%
			sleep 5000
			Winmove,%windowname%,,933,19,600,959			
			loop
			{
				if A_index > 20
					Continue 2
				if PixelColorExist("0xFFFEF5",387, 709,100)
				{
					this.CloseQHMenu()	
					sleep 200
					click 368, 783 ;click the start button
					break
				}

				If PixelColorExist("0xFE901A",365, 541,100)
				{
					click 365, 541 ;click the account button
					sleep 1500
					click 356, 545 ;click the manully login button
					sleep 500
				}
				sleep 1000
			}

			sleep 5000			
			loop
			{				
				if A_index > 10
					Continue 2
				if this.SubWindowExist()
					this.CloseAnySubWindow()
				sleep 1000
				if PixelColorExist("0xEFFEFF",56, 920,10) 	; double check again on the shop button				
				{	
					sleep 1000								; give one more secs to check if other pop window will come
					if !this.SubWindowExist()
						break 2								; looks all good here, break the main loop
					else{
						this.CloseAnySubWindow()
						break 2	
					}
				}	
			}							
		}
	}


	CloseAnySubWindow()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		
		loop 5
		{
			ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\img\blockofwhite.bmp"
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
			ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\img\blockofwhite.bmp"
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
		ImageSearch, Px, Py, 370, 160, 586, 550, % A_ScriptDir . "\img\blockofwhite.bmp"
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

	GetLandPage2(){
            this.GetLandpage()
            click 202, 250
            sleep 200
            if !PixelColorExist("0xFEE79B",28, 851,4000)		;左下角颜色	
                throw, "Nob able to GetLandPage2 "
	}

	isPrepared()
	{
        if A_Sec > 25 or A_Min > 0
        {
            LogToFile("Land business just click time expired, current time: " . A_Min . "mins, secs: " . A_Sec)
            return 0
        }
		if PixelColorExist("0x7C7C7C",494, 183,10) or PixelColorExist("0xB0B0B0",494, 183,10)
		{
			LogToFile("Find land business prepared, just click OK." )
			click 303, 609     ;点击确定
			sleep 200
			click 303, 609     ;点击确定
			sleep 200
    		loop 4
			{
				click 376, 726	   ;再次确认注入
				sleep 200
				if PixelColorExist("0xFFFFF3",308, 562,1000) ;确认注入提示框
				{
					click 303, 609     ;点击确定
					sleep 300
					click 477, 398
					sleep 200
				}
				if PixelColorExist("0xFD8F45",463, 250,10)
                {        
					LogToFile("Land business click OK done, loop times: " . A_index)
                    Return 1
                }					
			}
			LogToFile("Land business double check failed, will Getland again." )
			return 0									
		}
		else
			return 0
	}

    DiCanJinzhu()
    {
		if this.isPrepared()
			return
		this.GetLandpage()
		sleep 500
		SendMode Event
		this.CloseAnySubWindow()
        if !PixelColorExist("0x706B59",227, 417,10) and PixelColorExist("0x706B59",361, 417,10)     ;the gray color on the top
        {
            LogToFile("Land business already done, no action needed." )
            return  
        } 
		Mousemove,570, 840
		send {LButton down}
		Mousemove,570, 80,3
		send {LButton up}		
		sleep 100	
		click 570, 840
		sleep 200
		loop
		{
			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 140, 429, 530, 817, % A_ScriptDir . "\img\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 		
			else if (ErrorLevel = 1) ;Image not found 
			{
				sleep 200
				this.CloseAnySubWindow()							
				Mousemove,570, 840
				send {LButton down}
				sleep 100				
				Mousemove,570, 500,2
				send {LButton up}
				sleep 50
				click 570, 840
				sleep 200
			}
			else if (ErrorLevel = 0)  ;Image found
			{
                LogToFile("QH Image found when loop times: " . A_Index)
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",190, 480,1000) 		;经营资源输入框存在
				   and PixelColorExist("0x5A7965",331, 353,10)      ;且上面图片显示是闲置土地
				{
					click,265, 465, 11 ;经营1
					sleep 100
					click,265, 530, 15 ;经营2
					sleep 100
					click,265, 594, 11  ;经营3
					sleep 300					
                    if !PixelColorExist("0xFEEDC7",119, 391,10) and !PixelColorExist("0xFEEDC7",478, 391,10) ;左右两边都没有显示金钱不够提示
                        throw "Not enough money warning show!"

					click 376, 723	;确认注入
					sleep 100
					if PixelColorExist("0xFBFBFB",478, 396,300) ;确认注入提示框
                    {
                        click 305, 611     ;点击确定
                        WaitPixelColorAndClick("0xFBFBFB",495, 180,1000)
                    }
					else
                    {
                        LogToFile("Exception while QHDiCcanJinzhu: not found the OK button, will continue") 
						Continue
					}
				}
				else
				{
                    LogToFile("0xFFFEF5 and 0x5A7965 exception, will continue")
					Continue
				}

                if !PixelColorExist("0x706B59",574, 383,200) and !PixelColorExist("0x706B59",574, 416,10) ;the button is exist
                {
                    LogToFile("QH Land business done.")
                    Break  
                }
			}
			sleep 200
			if A_index > 10
				throw "QH DicanJinzhu loop more than 10 times still not get a free land."

		}
		SendMode Input		
	}

    SuanKai()
    {
	    this.GetLandPage2()

		click 417, 781  ; NiuShi button
		sleep 200
		if PixelColorExist("0xFFF8CE",421, 361,1000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
			click 430, 472                            ; Use button
		else
			click 501, 222							  ; close button

        sleep 200
        click 248, 778 ; JBP button
        sleep 200

		if PixelColorExist("0xFFF8CE",421, 361,1000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
			click 430, 472                            ; Use button
		else
			click 501, 222							  ; close button

        sleep 200		

        click 46, 915
        ;Setting Button
        WaitPixelColorAndClickThrowErr("0xFFFFFF",566, 187,3000)
        ;Setting page
        if !PixelColorExist("0xFFFFF3",145, 700,3000) ;左下空白
            throw "Setting page cannot found!"

        sleep 100
        click 410, 565 ;Save button
        sleep 1000
        this.CloseAnySubWindow()
    }

;=========================================  CaiTuan functions  ===============================================

	GetCaiTuanPage()
	{
		loop{
			if A_Index > 2
				throw "Not able to GetCaiTuanPage.PixelColorExist 0xFFFEF5 497 333 not exist."
			this.closeAnySubWindow()
			click % HB[1]
			sleep 100
			click % HB[4]
			sleep 200
			if PixelColorExist("0xFFFEF5",552, 334,2000)			;白色公关资金框
				Break
		}	
	}

	GetTianTiPage()
	{
		This.GetCaiTuanPage()
		click 69, 179
		WaitPixelColor("0xFFFEF5",177, 387,2000)  ;白色股份资金框
	}

	TianTiOpration(Times)
	{
		this.GetTianTiPage()
		loop %Times%
		{
			click 539, 444
			if PixelColorExist("0xFFFFF3",149, 566,1000) ;立即到账
			{
				LogToFile("TianTi start immediately. ")	
				click 300, 609
				sleep 200
			}
			click 547, 274		;开始 button
			if PixelColorExist("0xFFFEF5",265, 860,1000) ; Add 钻石
			{
				click 265,853,1
				sleep 100
				Click 365,853,0
				sleep 100
				click 465,853,0
				sleep 100	
			}		
			WaitPixelColorNotExist("0xFFFEF5",265,860,20000)
			LogToFile("TianTi finished, total times: " . A_index)			
			CaptureScreen()
			sleep 300
			click 265,853
			sleep 300
			click 539, 444				;上一次分配
			CaptureScreen()			
			sleep 300
		}
	}

	GetQHCaiTuanMoney()
	{
		WaitPixelColorAndClickThrowErr("0x3E515C",290, 914,2000) ;cai tuan button
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFFCF6",552, 230,2000) ;Shou Ru button	
		sleep 100
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

	GetGroupPage3(){
		this.GetGroupPage()
		click % SB[3]
		WaitPixelColor("0xFFFEF5",220, 407,2000)			;白色商会币框
	}

	GetGroupPage4(){
		this.GetGroupPage()
		click % SB[4]
		WaitPixelColor("0x91B65A",491, 349,2000)			;科技企业后的绿色
	}

	GroupZhuZi(which)
	{
		this.GetGroupPage2()
		loop 8		;有可能有红包挡住，等几秒钟再试
		{
			if PixelColorExist("0xFFF8CE",250, 320,10)
				Break
			else
				sleep, % s["mid"]
		}
		if PixelColorExist("0xFFF8CE",231, 305,100) ; 还没有注过资.
		{
			num := % Getzhushu()
			loop %num%
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
	}

	CheZi()
	{
		this.GetGroupPage4()
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

	PreRongZi(RZCom)
	{		
		this.GetGroupPage4()

		click, % BC[RZCom]
		sleep, % s["long"]		

		SetDefaultMouseSpeed 10
		num := % Getzhushu()-1
		click,200, 574, %num%
		SetDefaultMouseSpeed 2		
		sleep, % s["mid"]

		if !PixelColorExist("0xFFFFF3",275, 398,10) ;存在没有更多金币提示.!
			Throw, "Not enough money warnning exist!"    

		sleep, % s["mid"]
		click % RZWin["yesbtn"]
		sleep, % s["short"]
	}

	isRongZiprepared()
	{
		return (PixelColorExist("0xB0B0B0",498, 263,100) or PixelColorExist("0x7C7C7C",498, 263,10))
	}

	RongZiOKinternal()
	{
		click % PopWin["okbtn"]
		sleep, % s["mid"]
		if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
			click % PopWin["qhclobtn"]
	}

    RongZiOKpublic()
	{
		loop
		{
			if !PixelColorExist("0xFFFFFF",139, 401,10) and !PixelColorExist("0xB2A68C",308, 666,10) ;左上白点和确定button下的第二个弹出窗口color
			{
				4399sfGame.CloseSpeSubWindow(1)
				LogToFile("RongZiOKpublic closed an unexpected window.")															
			}			
			if PixelColorExist("0xFFFFFF",139, 401,10)												;左上白点
			{
				LogToFile("RongZiOKpublic find OK window, going to click")					
				click % PopWin["okbtn"]
				sleep, % s["short"]
				click % PopWin["okbtn"]
				sleep, % s["short"]
				break
			}

			if !4399sfGame.SubWindowExist() or A_index > 3
				throw "Not found RongZi OK button or loop times out!"
		}
	}

	BuyTimePlus()
	{
		this.GetGroupPage3()
		/*
		if PixelColorExist("0xC59A18",208, 655,50)  ; 2-2
		{
			click 208, 655
			sleep 200
			click 278, 628		;确定button
			;click 476, 398    	;close button , for testing only
			sleep 200
			LogToFile("Bought timeplus 2-2.")
		}
		*/
	}

	PlayZhuanPan(times = 6, BuyTimeplus = 0)
	{
        if BuyTimeplus
			this.BuyTimePlus()

        this.closeAnySubWindow()
		click 41, 914
		sleep 200		
		WaitPixelColorAndClickThrowErr("0xD17622",575, 390,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times+1)
		{
			WaitPixelColorAndClickThrowErr("0xF4452A",416, 769,2000) ;Ten Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",422, 257,5000) ;Finished once
			sleep 200
			click 422, 257
			sleep 300
			click 480, 398  ;Close double money window if any.
			sleep 200
			n++  
		}
        sleep 1000
	}

}






