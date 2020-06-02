#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

class DQGame
{

;=========================================  Common functions  ===============================================
	__New()
	{
		LogToFile("Waiting for implement in the extended class." )		
	}

    __Delete()
	{
		if this.isclosed
		{
			WinClose, % this.winName
			sleep 100
		}
		else
			WinMinimize, % this.winName

		LogToFile("Log Ended for 6322Player.`n")
    }

; <==================================  Properties  ====================================>

	HomepagePos[]{
		get{
			IniRead, value,% UserIni,6322Player,RZ,0
			return %value%
		}


	global  LieshoucoList := ["490,296","490,366","490,436","490,506","490,576","490,647"]
	global  Arrayphy := {btn1: "1069, 662", btn2: "798, 629", btn_2: "798, 692", btn3: "522, 633" 
			, btn_3: "522, 692", btn4: "253, 622", btn_4: "253, 692"}

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

	SJ[]{
		get{
			IniRead, value, % UserIni,LDPlayer,SJ,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,LDPlayer,SJ
			IniWrite, % A_Sec . ":" . A_Sec, % UserIni,LDPlayer,Sjtime					
		}


; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		PrepareGameWindow(this.winName)
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
	
	Zhuanpan(times){
		try{
		PrepareGameWindow(this.winName)
		this.Suankai()
		LogToFile("Suankai() done for 6322Player.")
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
			PrepareGameWindow(this.winName)
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


;=========================================  land functions  ===============================================
	GetLandpage(){
		loop{
            if A_Index > 2
                throw "Not able to GetLandPage."
            closeAnySubWindow()
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
        if A_Sec > 20
        {
            LogToFile("Land business just click time expired, current secs: " . A_Sec)
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
			closeAnySubWindow()
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
        closeAnySubWindow()
    }

	PlayZhuanPan(times = 6)
	{
        closeAnySubWindow()
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

	GetGroupPage4()
	{
		PrepareGameWindow(this.winName)
		loop
		{
			if A_index > 2
				throw, "Tried 2 times, still not able to GetGroupPage4."
			closeAnySubWindow()
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
			closeAnySubWindow()
	}

	RongZiPri()
	{		
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to complete RongZi."

			closeAnySubWindow()
			click 170, 733	   							  ; 固定注能源
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

	LaunchGame(index,packagename)
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		run %LDGamePath% launchex --index %index% --packagename %packagename%  
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
					closeAnySubWindow()
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

