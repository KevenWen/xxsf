#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk

CoordMode, Pixel, window  
CoordMode, Mouse, window

class LDGame
{

;=========================================  Common functions  ===============================================
	__New(isclose=1)
	{
		this.isclosed := isclose

		LogToFile("")
		LogToFile("Log started for LDPlayer." )		

		IfWinExist, LDPlayer
		{
			WinActivate LDPlayer
			WinSet, AlwaysOnTop, On, LDPlayer		
			Sleep 100
			LogToFile("Find existing window named LDPlayer. ")
		}
		else
		{
			try{
			this.LaunchLDGame()
			LogToFile("LDPlayer Started.")
			CaptureScreen()
			}
			Catch e{
			LogToFile("LDPlayer window not fond and start game failed: " . e)
			CaptureScreen()
			Return
			}
		}
	}

    __Delete()
    {
		WinSet, AlwaysOnTop, Off, LDPlayer		
		if this.isclosed
		{
			WinClose, LDPlayer
			sleep 100
		}

		LogToFile("Log Ended for LDPlayer.`n")
    }

; <==================================  Properties  ====================================>

	RZ[]{
		get{
			IniRead, value,% UserIni,LDPlayer,RZ,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,LDPlayer,RZ
			IniWrite, % A_Min . ":" . A_Sec, % UserIni,LDPlayer,Rztime			
		}
	}

	DC[]{
		get{
			IniRead, value, % UserIni,LDPlayer,DC,0
			return %value%
		}

		set{
			IniWrite, % value, % UserIni,LDPlayer,DC
			IniWrite, % A_Min . ":" . A_Sec, % UserIni,LDPlayer,Dctime					
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
	}
; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow()
		this.DiCanJinzhu()
		this.DC := 1
		LogToFile("GetLand() done for LDPlayer")
		}
		Catch e
		{
		LogToFile("GetLand() get exception: " . e)
		CaptureScreen()
		}
	}

; <========================  融资确认  ===========================>

    ClickRongZiOK()
	{
		try{
		this.PrepareGameWindow()
		CaptureScreen()
		this.ClickRongZiOKPublic()
		this.RZ := 1
		LogToFile("ClickRongZiOK() done for LDPlayer")
		}
		Catch e
		{
		LogToFile("ClickRongZiOK() get exception: " . e)
		CaptureScreen()
		}
	}

	RongZi()
	{
		try{
		this.GetGroupPage4()
		this.RongZiPri()
		LogToFile("RongZi() done for LDPlayer")		
		this.RZ := 1	
		}
		catch e {
		LogToFile("RongZi() get exception: " . e)
		CaptureScreen()		
		}
	}

;=========================================  Common functions  ===============================================

	PrepareGameWindow()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		

		IfWinExist, LDPlayer
        {
			WinActivate, LDPlayer
			sleep 200
		}
		Else
			throw "Game not existing!"
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 341, 139, 537,512 , % A_ScriptDir . "\\blockofwhite.bmp"
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

	DiCanJinzhu()
	{
		this.GetLandpage()
		sleep 300
        if PixelColorExist("0xB3DDBF",511, 377,100) or PixelColorExist("0xB6DEC1",511, 366,10) ;the white color on the button,remote or phy
        {
            CaptureScreen()
            LogToFile("Land business already done, no action needed." )
            return  
        }  
		sleep 200
		SendMode Event
		Mousemove,520, 878
		send {LButton down}
		Mousemove,520, 130,4
		send {LButton up}
		click 520, 878	
		sleep 200
		loop
		{
			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 253, 431, 527, 901, % A_ScriptDir . "\\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 		
			else if (ErrorLevel = 1) ;Image not found 
			{
				Mousemove,520, 878
				send {LButton down}
				Mousemove,520, 280,5
				send {LButton up}
				click 520, 878
				sleep 200
			}
			else if (ErrorLevel = 0) ;Image found
			{
                LogToFile("LD Image found when loop times: " . A_Index)
				CaptureScreen()	
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",141, 484,1000) 		;经营资源输入框存在
				   and PixelColorExist("0x5A7965",300, 270,10)      ;且上面图片显示是闲置土地
				{
					click,235, 470, 23 ;金币23
					sleep 100
					click,241, 540, 17 ;金币17
					sleep 100
					click,415, 540, 3 ;资源卡6
					sleep 100
					click,326, 607, 3  ;3份钻石注决策资源
					sleep 300					
                    if !PixelColorExist("0xFEEDC7",82, 391,10) and !PixelColorExist("0xFEEDC7",79, 378,10) ;没有显示金钱不够提示
                        throw "Not enough money warning show!"

					click 355, 746	;确认注入
					sleep 200
					if PixelColorExist("0xFBFBFB",468, 391,300) ;确认注入提示框
                    {
                        click 305, 625     ;点击确定
						CaptureScreen()
                        WaitPixelColorAndClick("0xFBFBFB",485, 161,1000)
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

                if !PixelColorExist("0x706B59",520, 423,200) and !PixelColorExist("0x706B59",520, 382,10) ;the button is exist
                {
                    CaptureScreen()
                    LogToFile("LD Land business done.")
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
			click 459, 248				;融资 tab
			if PixelColorExist("0xABA9A5",468, 572,2000) ;金融企业右边的灰块
				break
		}

	}

	OpenBusinessSkill(){
		try{
			this.PrepareGameWindow()
			loop 3 {
				this.CloseAnySubWindow()
				click 356, 984				;商会 button
				sleep 300
				click 239, 241				;注资 tab
				sleep 1000
				click 88, 247				;商会 tab
				sleep 200
				CaptureScreen()
				if PixelColorExist("0xFFFEF5",395, 444,2000) ;商战配置中的白色块
					break
			}

			if PixelColorExist("0xA1FF3D",108, 590,100){
				LogToFile("Already opened, no need more action. ")
				this.SJ := 1  
				return
			}
			click 108, 590					  				;赚钱上的绿点
			sleep 100
			For index, value in OpenSJListLD  				;开启赚钱/偷猎/融资/地产技能
			{
				PixelColorExist("0xF1E4B8",315, 542,1500)    ;知已知彼框上颜色
				sleep 200
				click, % value
				PixelColorExist("0xFFFFF3",315, 542,1000)	;开启 button
				sleep 200
				click 355, 610
				LogToFile("OpenBusinessSkill() for: " . index)			
				;WaitPixelColorAndClick("0xFBFBFB", 500, 410,1000)	;关闭 button, for testing only
			}

			sleep 1000
			CaptureScreen()
			click 506, 228  ; 关闭subwindow
			sleep 100
			this.SJ := 1
			CaptureScreen()
			LogToFile("OpenBusinessSkill() done for LDPlayer")
		}
		Catch e
		{
		LogToFile("OpenBusinessSkill() get exception: " . e)
		CaptureScreen()
		}
	}

	ClickRongZiOKPublic()
	{
		click 310, 627
		sleep, % s["short"]
		click 310, 627
		sleep, % s["short"]		
		loop 5
		{
			if !this.SubWindowExist()
				break
			if !PixelColorExist("0xB2A68C",278, 680,10) ; the color under in the OK window
				this.CloseSpeSubWindow(1)
			if PixelColorExist("0xB2A68C",278, 680,100)
			{
				click 310, 627
				sleep, % s["short"]
				CaptureScreen()
			}	
		}
	}

	RongZiPri()
	{		
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to complete RongZi."

			this.CloseAnySubWindow()			
			click, 403, 724	   							  ; 固定注洒店
			if !PixelColorExist("0xFFFEF5",203, 604,2000) ; 不是显示0份
			throw, "Already RongZi, not zero!"

			mousemove, 200, 600
			CaptureScreen()			
			sleep, % s["short"]
			SetDefaultMouseSpeed 30
			SendMode Event
			click, 40
			SetDefaultMouseSpeed 2	
			SendMode Input
			CaptureScreen()							
			sleep, % s["mid"]

			if !PixelColorExist("0xFFFFF3",246, 396,10) ;存在没有更多金币提示.!
				Throw, "Not enough money warnning exist!"    

			click 328, 594
			if !PixelColorExist("0xFFFFFF",98,403,2000)
				Continue
			else
			{
				click  277, 628						
				sleep 200
				if PixelColorExist("0xFBFBFB",495, 249,1000)
					click 477, 318
				CaptureScreen()	
				sleep 200
				break
			}
		}
	}

	;=========================================  Launch Game  ===============================================

	LaunchLDGame()
	{
		WinClose Cisco AnyConnect	;The VPN windows may exist	
		WinClose, IrfanView			;The capture screen error windows may exist		
		run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan"  
		LogToFile("Start to Launch LDGame. ")			
		sleep 40000
		IfWinExist, LDPlayer
		{
			WinActivate, LDPlayer
			sleep 200
			Loop
			{
				LogToFile("Find Started window, going to Click AD. ")	
				run %LDExePath% -s 0 input tap 828 406,, Hide

				if PixelColorExist("0xFFFEF5",382, 727,10)
				{
					LogToFile("Find Start button, going to Click it. ")	
					run %LDExePath% -s 0 input tap 450 1300,, Hide
					sleep 10000
					this.CloseAnySubWindow()
					Break
				}

				if A_Index > 60
					throw "LDPlayer start wait timeout"

				sleep 2000
			}
		}
		Else
			throw "LDPlayer window not exist"
	}

}





