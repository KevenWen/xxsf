#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

class 6322Game
{

;=========================================  Common functions  ===============================================
	__New(isclose=1)
	{
		this.isclosed := isclose

		LogToFile("")
		LogToFile("Log started for 6322Player." )		

		IfWinExist, 6322Player
		{
			WinActivate 6322Player
			Sleep 100
			if PixelColorExist("0xFFFEF5",370, 735,10)
			{
				LogToFile("Find existing window with start button, going to Click it. ")	
				click 277, 835
				sleep 10000
				this.CloseAnySubWindow()
			}			
			LogToFile("Find existing window named 6322Player. ")
		}
		else
		{
			try{
			this.Launch6322Game()
			LogToFile("6322Player Started.")
			}
			Catch e{
			LogToFile("6322Player window not fond and start game failed: " . e)
			Return
			}
		}
	}

    __Delete()
	{
		if this.isclosed
		{
			WinClose, 6322Player
			sleep 100
		}
		else
			WinMinimize, 6322Player

		LogToFile("Log Ended for 6322Player.`n")
    }

; <==================================  Properties  ====================================>

	RZ[]{
		get{
			IniRead, value,% UserIni,6322Player,RZ,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,6322Player,RZ
			IniWrite, % A_Min . ":" . A_Sec, % UserIni,6322Player,Rztime			
		}
	}

	DC[]{
		get{
			IniRead, value, % UserIni,6322Player,DC,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,6322Player,DC
			IniWrite, % A_Min . ":" . A_Sec, % UserIni,6322Player,Dctime					
		}
	}
; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow()
		this.DiCanJinzhu()
		this.DC := 1
		LogToFile("GetLand() done for 6322Player.")
		}
		Catch e
		{
		LogToFile("GetLand() get exception: " . e)
		}
	}

; <========================  转盘  ===========================>
	
	Zhuanpan(times,buytimeplus = 0){
		try{
		this.PrepareGameWindow()
		this.Suankai()
		LogToFile("Suankai() done for 6322Player.")
		}
		Catch e
		{
		LogToFile("Suankai() get exception: " . e)
		}

		try{	
		this.PlayZhuanPan(times,buytimeplus)
		LogToFile("PlayZhuanPan done!")		
		}
		Catch e
		{
		LogToFile("PlayZhuanPan() get exception: " . e)
		}		
	}

; <========================  融资确认  ===========================>

	RongZi()
	{
		try{
			this.PrepareGameWindow()
			if this.isRongZiprepared() {
				LogToFile("Find RongZi prepared, Going to click OK.")		
				this.ClickRongZiOKPublic()
			}
			else {
				this.GetGroupPage4()
				this.RongZiPri()
			}
			this.RZ := 1
			LogToFile("RongZi() done for 6322Player.")
		} catch e {
			LogToFile("RongZi() get exception: " . e)
		}
	}

;=========================================  Common functions  ===============================================

	PrepareGameWindow()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		

		WinGetActiveTitle, CurTitle
		if (CurTitle = "6322Player") and !PixelColorExist("0xFFFEF5",370, 735,10)
			Return

		IfWinExist, 6322Player
        {
			WinActivate, 6322Player
			sleep 200
			if PixelColorExist("0xFFFEF5",370, 735,10)
			{
				LogToFile("Find Start button, going to Click it. ")	
				click 277, 835
				sleep 10000
				this.CloseAnySubWindow()
			}	
		}
		Else
			throw "Game not existing!"
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 370, 130, 537,512 , % A_ScriptDir . "\img\blockofwhite.bmp"
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

	CloseSpeSubWindow(n)
	{
		loop %n%
		{
			ImageSearch, Px, Py, 370, 130, 537, 512, % A_ScriptDir . "\img\blockofwhite.bmp"
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
		ImageSearch, Px, Py, 370, 130, 537, 512, % A_ScriptDir . "\img\blockofwhite.bmp"
		if (ErrorLevel = 2)  ;Execption when conduct the search
			return 0
		else if (ErrorLevel = 1) ;Image not found 
			return 0
		else if (ErrorLevel = 0) ;Image found
			return 1
	}

;=========================================  land functions  ===============================================
	GetLandpage(){
		loop{
            if A_Index > 2
                throw "Not able to GetLandPage."
            this.closeAnySubWindow()
            click 50, 965
            sleep 500
            click 117, 965
            sleep 1000
            if PixelColorExist("0x9E9E9E",25, 871,4000)		;3号地产 左边的灰条	
                Break
        } 
	}

	GetLandpage2(){
		loop{
            if A_Index > 2
                throw "Not able to GetLandPage2."
            this.GetLandpage()
            click 227, 234
            sleep 200
            if PixelColorExist("0xFFFEF5",458, 396,2000)		;总点击数白框	
                Break
        } 
	}

	isPrepared()
	{		
        if A_Sec > 25 or A_Min > 0
        {
            LogToFile("Land business just click time expired, current time: " . A_Min . "mins, secs: " . A_Sec)
            return 0
        }
		if PixelColorExist("0x7C7C7C",491, 159,10) or PixelColorExist("0xB0B0B0",491, 159,10)
		{		
			LogToFile("Find land business prepared, just click OK." )
			click 281, 627     ;点击确定
			sleep 200
			click 281, 627     ;点击确定
			sleep 200
			loop 4
			{
				click 361, 758	   ;再次确认注入
				sleep 200
				if PixelColorExist("0xFFFFF3",274, 583,1000) ;确认注入提示框
				{
					click 281, 627     ;点击确定
					sleep 300		
					click 468, 404
					sleep 200
				}
				if PixelColorExist("0xFD8F45",457, 236,10)  ;角色入驻 color
				{				
					LogToFile("Land business click OK done, loop times: " . A_index)
					return 1 	
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
		sleep 300
		if !PixelColorExist("0x706B59",252, 420,10) and PixelColorExist("0x706B59",358, 420,10)		;the gray color next refresh time
		{
			LogToFile("Land business already done, no action needed." )
			return  
		}
		sleep 200
		SendMode Event
		Mousemove,525, 900
		send {LButton down}
		Mousemove,525, 100,5
		send {LButton up}
		click 525, 900
		sleep 200
		loop
		{
			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 253, 432, 500, 900, % A_ScriptDir . "\img\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 		
			else if (ErrorLevel = 1) ;Image not found 
			{
				Mousemove,525, 900
				send {LButton down}
				Mousemove,525, 380,20
				send {LButton up}
				click 525, 900
				sleep 200
			}
			else if (ErrorLevel = 0) ;Image found
			{
				LogToFile("LD Image found when loop times: " . A_Index)
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",141, 485,1000) 		;经营资源输入框存在
				and PixelColorExist("0x5A7965",300, 360,10)      ;且上面图片显示是闲置土地
				{
					click,235, 470, 11 ;经营1
					sleep 100
					click,235, 540, 15  ;经营2
					sleep 100
					click,235, 610, 11  ;经营3
					sleep 300					
					if !PixelColorExist("0xFEEDC7",76, 391,10) ;没有显示金钱不够提示
						throw "Not enough money warning show!"

					click 361, 758	;确认注入
					sleep 200
					if PixelColorExist("0xFFFFF3",301, 582,300) ;确认注入提示框
					{
						click 301, 632     ;点击确定
						WaitPixelColorAndClick("0xFBFBFB",492, 158,1000)
					}
					else
					{
						LogToFile("Exception while LDDiCcanJinzhu: not found the OK button")
						Continue						 
					}
				}
				else
				{
					LogToFile("0xFFFEF5 and 0x5A7965 exception.")
					Continue
				}

				if !PixelColorExist("0x706B59",526, 385,100) and !PixelColorExist("0x706B59",526, 415,10) ;the button is exist
				{
					LogToFile("6322 LD Land business done.")
					sleep 200                     
					Break  
				}   
			}
			sleep 200
			if A_index > 8
				throw "DicanJinzhu loop more than 8 times still not get a free land."
		}
		SendMode Input
	}

    SuanKai()
    {
	    this.GetLandPage2()

		click 462, 819  ; NiuShi button
		sleep 200
		if PixelColorExist("0xFFF8CE",404, 354,1000)  ;窗口上方空白颜色，如果是3000钻石窗口，颜色会不一样
			click 424, 479                            ; Use button
		else
			click 497, 205							  ; close button

        sleep 200
        click 281, 824 ; JBP button
        sleep 200

		if PixelColorExist("0xFFF8CE",404, 354,1000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
			click 424, 479                            ; Use button
		else
			click 497, 205							  ; close button
		
        sleep 200
        ;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		

        click 49, 976
        ;Setting Button
        WaitPixelColorAndClickThrowErr("0xFFFFFF",515, 169,3000)
        ;Setting page
        if !PixelColorExist("0xFFFFF3",386, 761,3000) ;公告下面的空白
            throw "Setting page cannot found!"

        sleep 100
        click 407, 584 ;Save button
        sleep 1000
        this.CloseAnySubWindow()
    }

	BuyTimePlus()
	{
		this.GetGroupPage3()
		if PixelColorExist("0xC59A18",300, 517,100) ;1-3
		{
			click 330, 510
			sleep 300
			click 278, 628
			sleep 200		
			LogToFile("Shopping buy 1-3")				
		}

		if PixelColorExist("0xC59A18",409, 518,100) ;1-4
		{
			click 454, 511
			sleep 300
			click 278, 628
			sleep 200		
			LogToFile("Shopping buy 1-4")				
		}

		if PixelColorExist("0xC59A18",81, 518,100) ;Row 1-1
		{
			click 91, 510
			sleep 300
			click 278, 628 ;OK button	
			;click 462, 394	;Close button, for testing perpose	
			sleep 200			
			LogToFile("Shopping buy 1-1")		
		}

		if PixelColorExist("0xC59A18",208, 655,50)  ; 2-2
		{
			click 208, 655
			sleep 200
			click 278, 628		;确定button
			;click 476, 398    	;close button , for testing only
			sleep 200
			LogToFile("Bought timeplus 2-2.")
		}
	}

	PlayZhuanPan(times = 6, BuyTimeplus = 0)
	{
        if BuyTimeplus
			this.BuyTimePlus()
		
		this.closeAnySubWindow()
		click 39, 970
		sleep 200		
		WaitPixelColorAndClickThrowErr("0xD17622",523, 389,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times+1)
		{
			WaitPixelColorAndClickThrowErr("0xF4452A",407, 810,2000) ;Ten Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",408, 239,5000) ;Finished once
			sleep 200
			click 408, 239
			sleep 300
			click 465, 388  ;Close double money window if any.
			sleep 200
			click 408, 239
			n++  
		}
        sleep 1000
	}

;=========================================  Group functions  ===============================================

	GetGroupPage3()
	{
		this.PrepareGameWindow()
		loop
		{
			if A_index > 2
				throw, "Tried 2 times, still not able to GetGroupPage4."
			this.CloseAnySubWindow()
			click 356, 984				;商会 button
			sleep 300
			click 333, 249				;商店 tab					
			if PixelColorExist("0xFFECD4",478, 895,2000) ;稀有道具下面空白块颜色
				break
		}
	}

	GetGroupPage4()
	{
		this.PrepareGameWindow()
		loop
		{
			if A_index > 2
				throw, "Tried 2 times, still not able to GetGroupPage4."
			this.CloseAnySubWindow()
			click 356, 984				;商会 button
			sleep 300
			click 468, 247				;融资 tab					
			if PixelColorExist("0xABA9A5",468, 572,2000) ;金融企业右边的灰块
				break
		}
	}

	isRongZiprepared()
	{
		return (PixelColorExist("0xB0B0B0",497, 251,100) or PixelColorExist("0x7C7C7C",497, 251,10) or PixelColorExist("0x575757",497, 251,10))
	}

	ClickRongZiOKPublic()
	{
		click 277, 691
		sleep, % s["short"]
		click 277, 638
		sleep, % s["short"]		
		click 277, 638
		sleep, % s["short"]
		if PixelColorExist("0xFBFBFB",495, 250,1000) ; the color under in the OK window
			this.CloseAnySubWindow()
	}

	RongZiPri()
	{		
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to complete RongZi."

			this.CloseAnySubWindow()
			click 390,410	   							  ; 固定注科技2
			if !PixelColorExist("0xFFFEF5",204, 604,2000) ; 不是显示0份
			throw, "Already RongZi, not zero!"

			mousemove, 204, 604
			sleep, % s["short"]
			SetDefaultMouseSpeed 30
			SendMode Event
			click, 38
			SetDefaultMouseSpeed 2	
			SendMode Input									
			sleep, % s["mid"]

			if !PixelColorExist("0xFFFFF3",248, 395,10) ;存在没有更多金币提示.!
				Throw, "Not enough money warnning exist!"    

			click 326, 595
			if !PixelColorExist("0xFFFFFF",98, 401,2000)
				Continue
			else
			{
				click  277, 630					
				sleep 200
				if PixelColorExist("0xFBFBFB",494, 252,1000)
					click 494, 252
				sleep 200		
				break					
			}
		}
	}

	;=========================================  Launch Game  ===============================================

	Launch6322Game()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		
		run %LDGamePath% launchex --index 3 --packagename "com.tantanyou.sf"  
		LogToFile("Start to Launch LDGame. ")			
		sleep 10000
		IfWinExist, 6322Player
		{
			WinActivate, 6322Player
			sleep 200
			Loop
			{
				if PixelColorExist("0xFFFFFF",255, 388,100) ; or PixelColorExist("0xFFFFFF",272, 265,100) ;remote or local
				{
					LogToFile("Find accout window, going to Click Enter. ")	
					click 347, 559
				}

				if PixelColorExist("0xFFFEF5",370, 735,10)
				{
					LogToFile("Find Start button, going to Click it. ")	
					click 277, 835
					sleep 10000
					this.CloseAnySubWindow()
					Break
				}

				if A_Index > 60
					throw "6322Player start wait timeout"

				sleep 2000
			}
		}
		Else
			throw "6322Player window not exist"
	}
}

