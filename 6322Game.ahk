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
			WinSet, AlwaysOnTop, On, 6322Player		
			Sleep 100
			LogToFile("Find existing window named 6322Player. ")
		}
		else
		{
			try{
			this.Launch6322Game()
			LogToFile("6322Player Started.")
			CaptureScreen()
			}
			Catch e{
			LogToFile("6322Player window not fond and start game failed: " . e)
			CaptureScreen()
			Return
			}
		}
	}

    __Delete()
    {
		WinSet, AlwaysOnTop, Off, 6322Player		
		if this.isclosed
		{
			WinClose, 6322Player
			sleep 100
		}

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
		CaptureScreen()
		}
	}

; <========================  转盘  ===========================>
	
	Zhuanpan(times){
		try{
		this.PrepareGameWindow()
		this.Suankai()
		CaptureScreen()		
		LogToFile("Suankai() done for 6322Player.")
		}
		Catch e
		{
		LogToFile("Suankai() get exception: " . e)
		CaptureScreen()
		}

		try{	
		this.PlayZhuanPan(times)
		CaptureScreen()		
		LogToFile("PlayZhuanPan done!")		
		}
		Catch e
		{
		LogToFile("PlayZhuanPan() get exception: " . e)
		CaptureScreen()
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
				this.RZ := 1
				LogToFile("RongZi() done for 6322Player")			
			}
			else {
				this.GetGroupPage4()
				this.RongZiPri()
			}
			this.RZ := 1
			LogToFile("RongZi() done for 6322Player.")
		} catch e {
			LogToFile("RongZi() get exception: " . e)
			CaptureScreen()		
		}
	}

;=========================================  Common functions  ===============================================

	PrepareGameWindow()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		

		WinGetActiveTitle, CurTitle
		if (CurTitle = "6322Player")
			Return

		IfWinExist, 6322Player
        {
			WinActivate, 6322Player
			sleep 200
		}
		Else
			throw "Game not existing!"
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 370, 130, 537,512 , % A_ScriptDir . "\\blockofwhite.bmp"
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
			ImageSearch, Px, Py, 370, 130, 537, 512, % A_ScriptDir . "\\blockofwhite.bmp"
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
		ImageSearch, Px, Py, 370, 130, 537, 512, % A_ScriptDir . "\\blockofwhite.bmp"
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
		CaptureScreen()
		if PixelColorExist("0x7C7C7C",491, 159,10) or PixelColorExist("0xB0B0B0",491, 159,10)
		{		
			LogToFile("Find land business prepared, just click OK." )
			click 281, 627     ;点击确定
			sleep 200
			click 281, 627     ;点击确定
			sleep 200
			loop 5
			{
				click 361, 758	   ;再次确认注入
				sleep 200
				if PixelColorExist("0xFFFFF3",274, 583,1000) ;确认注入提示框
				{
					click 281, 627     ;点击确定
					sleep 300
					CaptureScreen()				
					click 468, 404
					sleep 200
				}
				if PixelColorExist("0xFD8F45",457, 236,10)  ;角色入驻 color
					break
			}
			this.closeAnySubWindow()
			if !PixelColorExist("0x706B59",526, 385,100) and !PixelColorExist("0x706B59",526, 415,10) ;the button is exist
			{
				CaptureScreen()
				LogToFile("Land business click OK done.")
				sleep 200                     
				return 1 
			}
			else
			{
				LogToFile("Land business double check failed, will Getland again." )	
				CaptureScreen()			
				return 0
			}
									
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
		if !PixelColorExist("0x706B59",194, 400,100)			;the gray color next refresh time
		{
			CaptureScreen()
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
			ImageSearch, Px, Py, 253, 432, 500, 900, % A_ScriptDir . "\\blockofyellow.bmp"
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
				CaptureScreen()	
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",141, 485,1000) 		;经营资源输入框存在
				and PixelColorExist("0x5A7965",300, 360,10)      ;且上面图片显示是闲置土地
				{
					click,235, 470, 37 ;金币
					sleep 100
					;click,241, 585, 6 ;金币
					;sleep 100
					click,415, 538, 2 ;资源卡
					sleep 100
					click,326, 615, 2  ;钻石注决策资源
					sleep 300					
					if !PixelColorExist("0xFEEDC7",76, 391,10) ;没有显示金钱不够提示
						throw "Not enough money warning show!"

					click 361, 758	;确认注入
					sleep 200
					if PixelColorExist("0xFFFFF3",301, 582,300) ;确认注入提示框
					{
						click 301, 632     ;点击确定
						CaptureScreen()
						WaitPixelColorAndClick("0xFBFBFB",492, 158,1000)
					}
					else
					{
						CaptureScreen()
						LogToFile("Exception while LDDiCcanJinzhu: not found the OK button")
						Continue						 
					}
				}
				else
				{
					LogToFile("0xFFFEF5 and 0x5A7965 exception.")
					CaptureScreen()
					Continue
				}

				if !PixelColorExist("0x706B59",526, 385,100) and !PixelColorExist("0x706B59",526, 415,10) ;the button is exist
				{
					CaptureScreen()
					LogToFile("6322 LD Land business done.")
					sleep 200                     
					Break  
				}   
			}
			sleep 200
			if A_index > 38
				throw "DicanJinzhu loop more than 8 times still not get a free land."
		}
		SendMode Input
	}

    SuanKai()
    {
	    this.GetLandPage2()

		click 421, 834  ; NiuShi button
		sleep 200
		WaitPixelColor("0xFFF8CE",426, 415,2000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
		click 412, 528                            ; Use button

        sleep 200
        click 261, 834 ; JBP button
        sleep 200
		WaitPixelColor("0xFFF8CE",426, 415,2000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
		click 412, 528   
        sleep 200
        ;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		

        click 49, 976
        ;Setting Button
        WaitPixelColorAndClickThrowErr("0xFFFFFF",516, 246,3000)
        ;Setting page
        if !PixelColorExist("0xFFFFF3",419, 376,3000) ;off上面的空白
            throw "Setting page cannot found!"

        sleep 100
        click 394, 625 ;Save button
        sleep 1000
        this.CloseAnySubWindow()
    }

	PlayZhuanPan(times = 6)
	{
        this.closeAnySubWindow()
		click 39, 970
		sleep 200		
		WaitPixelColorAndClickThrowErr("0xD17622",526, 446,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times)
		{
			WaitPixelColorAndClickThrowErr("0xF4452A",409, 827,2000) ;Ten Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",390, 300,5000) ;Finished once
			sleep 200
			click 390, 300
			sleep 300
			click 445, 447  ;Close double money window if any.
			sleep 200
			click 433, 432
			CaptureScreen()	
			n++  
		}
        sleep 1000
	}

;=========================================  Group functions  ===============================================

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
			click 445, 312				;融资 tab					
			if PixelColorExist("0xABA9A5",468, 572,2000) ;金融企业右边的灰块
				break
		}

	}

	isRongZiprepared()
	{
		return (PixelColorExist("0xB0B0B0",475, 320,100) or PixelColorExist("0x7C7C7C",475, 320,10))
	}

	ClickRongZiOKPublic()
	{
		click 285, 733
		sleep, % s["short"]
		click 310, 666
		sleep, % s["short"]		
		click 310, 666
		sleep, % s["short"]
		if PixelColorExist("0xFBFBFB",477, 318,1000) ; the color under in the OK window
			this.CloseAnySubWindow()
	}

	RongZiPri()
	{		
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to complete RongZi."

			this.CloseAnySubWindow()
			click 138,475	   							  ; 固定注游乐
			if !PixelColorExist("0xFFFEF5",211, 640,2000) ; 不是显示0份
			throw, "Already RongZi, not zero!"

			mousemove, 200, 640
			CaptureScreen()			
			sleep, % s["short"]
			SetDefaultMouseSpeed 30
			SendMode Event
			click, 39
			SetDefaultMouseSpeed 2	
			SendMode Input
			CaptureScreen()											
			sleep, % s["mid"]

			if !PixelColorExist("0xFFFFF3",250,450,10) ;存在没有更多金币提示.!
				Throw, "Not enough money warnning exist!"    

			click 312, 631
			if !PixelColorExist("0xFFFFFF",115, 459,2000)
				Continue
			else
			{
				click  287, 661					
				sleep 200
				if PixelColorExist("0xFBFBFB",477, 318,1000)
					click 477, 318
				CaptureScreen()	
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
		run %LDGamePath% launchex --index 2 --packagename "com.tantanyou.sf"  
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

