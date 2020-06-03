#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

class YQXGame
{

;=========================================  Common functions  ===============================================
	__New(isclose=1)
	{
		this.isclosed := isclose

		LogToFile("")
		LogToFile("Log started for YQXPlayer." )		

		IfWinExist, YQXPlayer
		{
			WinActivate YQXPlayer	
			Sleep 100
			LogToFile("Find existing window named YQXPlayer. ")		
		}
		else
		{
			try{
			this.LaunchYQXGame()
			LogToFile("YQXPlayer Started.")
			}
			Catch e{
			LogToFile("YQXPlayer window not fond and start game failed: " . e)
			Return
			}
		}
	}

    __Delete()
    {
		if this.isclosed
		{
			WinClose, YQXPlayer
			sleep 100
		}
		else
			WinMinimize, YQXPlayer

		LogToFile("Log Ended for YQXPlayer.`n")
    }

; <==================================  Properties  ====================================>

	RZ[]{
		get{
			IniRead, value,% UserIni,YQXPlayer,RZ,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,YQXPlayer,RZ
			IniWrite, % A_Min . ":" . A_Sec, % UserIni,YQXPlayer,Rztime			
		}
	}

	DC[]{
		get{
			IniRead, value, % UserIni,YQXPlayer,DC,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,YQXPlayer,DC
			IniWrite, % A_Min . ":" . A_Sec, % UserIni,YQXPlayer,Dctime					
		}
	}
; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow()
		this.DiCanJinzhu()
		this.DC := 1
		LogToFile("GetLand() done for YQXPlayer.")
		}
		Catch e
		{
		LogToFile("GetLand() get exception: " . e)
		}
	}

; <========================  转盘  ===========================>
	
	Zhuanpan(times){
		try{
		this.PrepareGameWindow()
		this.Suankai()
		LogToFile("Suankai() done for YQXPlayer.")
		}
		Catch e
		{
		LogToFile("Suankai() get exception: " . e)
		}

		try{	
		this.PlayZhuanPan(times)
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
			LogToFile("RongZi() done for YQXPlayer.")
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
		if (CurTitle = "YQXPlayer")
			Return

		IfWinExist, YQXPlayer
        {
			WinActivate, YQXPlayer
			sleep 200
		}
		Else
			throw "Game not existing!"
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 341, 139, 537,512 , % A_ScriptDir . "\img\blockofwhite.bmp"
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
            click 227, 301
            sleep 200
            if PixelColorExist("0xFFFEF5",459, 450,2000)		;总点击数白框	
                Break
        } 
	}

	isPrepared()
	{
        if A_Sec > 20
        {
            LogToFile("Land business just click time expired, current secs: " . A_Sec)
            return 0
        }
		if PixelColorExist("0x7C7C7C",472, 236,10) or PixelColorExist("0xB0B0B0",472, 236,10)
		{		
			LogToFile("Find land business prepared, just click OK." )
			click 281, 661     ;点击确定
			sleep 200
			click 281, 661     ;点击确定
			sleep 200
			loop 4
			{
				click 355, 780	   ;再次确认注入
				sleep 200
				if PixelColorExist("0xFFFFF3",226, 623,1000) ;确认注入提示框
				{
					click 281, 661     ;点击确定
					sleep 300				
					click 451, 454
					sleep 200
				}
				if PixelColorExist("0xFD8F45",439, 309,10)  ;角色入驻 color
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
		if !PixelColorExist("0x706B59",228, 472,100) and PixelColorExist("0x706B59",348,472,10)			;the gray color next refresh time
		{
			LogToFile("YQX Land business already done, no action needed." )
			return  
		}
		sleep 200
		SendMode Event
		Mousemove,525, 905
		send {LButton down}
		Mousemove,525, 100,4
		send {LButton up}
		click 525, 905	
		sleep 200
		loop
		{
			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 253, 490, 500, 910, % A_ScriptDir . "\img\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 		
			else if (ErrorLevel = 1) ;Image not found 
			{
				Mousemove,525, 905
				send {LButton down}
				Mousemove,525, 350,10
				send {LButton up}
				click 525, 905
				sleep 200
			}
			else if (ErrorLevel = 0) ;Image found
			{
				LogToFile("LD Image found when loop times: " . A_Index)
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",154, 533,1000) 		;经营资源输入框存在
				and PixelColorExist("0x5A7965",300, 404,10)      ;且上面图片显示是闲置土地
				{
					click,235, 520, 11  ;经营1
					sleep 100
					click,235, 585, 17  ;经营2
					sleep 100
					click,235, 650, 11  ;经营3
					sleep 300					
					if !PixelColorExist("0xFEEDC7",92, 449,10) ;没有显示金钱不够提示
						throw "Not enough money warning show!"

					click 355, 780	;确认注入
					sleep 200
					if PixelColorExist("0xFBFBFB",461, 454,300) ;确认注入提示框
					{
						click 301, 661     ;点击确定
						WaitPixelColorAndClick("0xFBFBFB",472, 236,1000)
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

				if !PixelColorExist("0x706B59",528, 446,200) and !PixelColorExist("0x706B59",526, 474,10) ;the button is exist
				{
					LogToFile("YQX LD Land business done.")
					sleep 200                     
					Break  
				}   
			}
			sleep 200
			if A_index > 8
				throw "QH DicanJinzhu loop more than 8 times still not get a free land."
		}
		SendMode Input
	}

    SuanKai()
    {
	    this.GetLandPage2()

		click 421, 834  ; NiuShi button
		sleep 200
		if PixelColorExist("0xFFF8CE",426, 415,1000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
			click 412, 528                            ; Use button
		else
			click 477, 277							  ; close button

        sleep 200
        click 261, 834 ; JBP button
        sleep 200

		if PixelColorExist("0xFFF8CE",426, 415,1000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
			click 412, 528                            ; Use button
		else
			click 477, 277

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
		while (n < times+1)
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
		return (PixelColorExist("0xB0B0B0",475, 320,100) or PixelColorExist("0x7C7C7C",475, 320,10) or PixelColorExist("0x575757",475, 320,10))
	}

	ClickRongZiOKPublic()
	{
		loop 3
		{
			if PixelColorExist("0x796A55",32, 918,10) or PixelColorExist("0xB0B0B0",476, 319,10) ; the color in the left bottom
			{
				LogToFile("Only two sub windows which is as expected now.")
				break
			}
			else
			{
				this.CloseSpeSubWindow(1)
				LogToFile("Closed a sub windows while ClickRongZiOKPublic.")
				sleep 50
			}
		}

		;click 283,734
		;sleep, % s["short"]
		click 310, 666
		sleep, % s["short"]		
		click 310, 666
		sleep, % s["short"]

		if PixelColorExist("0xAD9779",32, 918,1000) ; the color in the left bottom
			this.CloseAnySubWindow()
	}

	RongZiPri()
	{		
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to complete RongZi."

			this.CloseAnySubWindow()
			click 180,750	   							  ; 固定注能源4
			if !PixelColorExist("0xFFFEF5",211, 640,2000) ; 不是显示0份
			throw, "Already RongZi, not zero!"

			mousemove, 200, 640
			sleep, % s["short"]
			SetDefaultMouseSpeed 30
			SendMode Event
			click, 39
			SetDefaultMouseSpeed 2	
			SendMode Input				
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
				sleep 200		
				break					
			}
		}
	}

	;=========================================  Launch Game  ===============================================

	LaunchYQXGame()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		
		run %LDGamePath% launchex --index 1 --packagename "com.dh.flash.game.minigame"  
		LogToFile("Start to Launch LDGame. ")			
		sleep 10000
		IfWinExist, YQXPlayer
		{
			WinActivate, YQXPlayer
			sleep 200
			Loop
			{
				if PixelColorExist("0xFFFDFF",281, 272,100) or PixelColorExist("0xFFFDFF",272, 265,100) ;remote or local
				{
					LogToFile("Find last time play window, going to Click play. ")	
					click 281, 374
				}

				if PixelColorExist("0xFFFEF5",359, 754,10)
				{
					LogToFile("Find Start button, going to Click it. ")	
					click 279, 849
					sleep 10000
					this.CloseAnySubWindow()
					Break
				}

				if A_Index > 60
					throw "YQXPlayer start wait timeout"

				sleep 2000
			}
		}
		Else
			throw "YQXPlayer window not exist"
	}
}

