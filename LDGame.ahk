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
			Sleep 100
			LogToFile("Find existing window named LDPlayer. ")
		}
		else
		{
			LogToFile("LDPlayer window not fond.")
			CaptureScreen()
			Return
		}
	}

    __Delete()
    {
		if this.isclosed
		{
			WinClose, LDPlayer
			sleep 100
		}

		LogToFile("Log Ended for LDPlayer.`n")
    }

; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow()
		this.DiCanJinzhu()
		LogToFile("GetLand() done for LDPlayer")
		}
		Catch e
		{
		LogToFile("GetLand() get exception: " . e)
		CaptureScreen()
		}
	}

; <========================  融资确认  ===========================>

    RongZiOKpublic()
	{
		loop 5
		{
			if !this.SubWindowExist()
				break
			if !PixelColorExist("0xEBFAFA",326, 614,10) ; the white color in the OK button
				4399sfGame.CloseSpeSubWindow(1)
			if PixelColorExist("0xEBFAFA",326, 614,10)
			{
				click 310, 627
				sleep, % s["short"]
				CaptureScreen()
			}	
		}
	}

;=========================================  Common functions  ===============================================

	PrepareGameWindow()
	{
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
            click 50, 975
            sleep 500
            click 117, 987
            sleep 1000
            if PixelColorExist("0x9E9E9E",25, 887,4000)		;3号地产 左边的灰条	
                Break
        } 
	}

	DiCanJinzhu()
	{
		this.GetLandpage()
		sleep 300
		SendMode Event
		Mousemove,521, 889
		send {LButton down}
		Mousemove,536, 132,5
		sleep 100	
		send {LButton up}
		click 521, 889
		sleep 200
		CaptureScreen()
		loop
		{
			if A_index > 13
				throw "QH DicanJinzhu loop more than 15 times still not get a free land."

			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 253, 431, 527, 901, % A_ScriptDir . "\\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 		
			else if (ErrorLevel = 1) ;Image not found 
			{
				Mousemove,521, 889
				send {LButton down}
				Mousemove,536, 280,5
				send {LButton up}
				click 521, 889
				sleep 200
			}
			else if (ErrorLevel = 0) and !PixelColorExist("0x706B59",455, 284,10) ;Image found and not on the first line
			{
                LogToFile("LD Image found when loop times: " . A_Index)
				CaptureScreen()	
				click %Px%, %Py%
				sleep 200
				if PixelColorExist("0xFFFEF5",141, 486,1000) 		;经营资源输入框存在
				   and PixelColorExist("0x5A7965",300, 270,10)      ;且上面图片显示是闲置土地
				{
					click,235, 474, 23 ;金币23
					sleep 100
					click,241, 546, 17 ;金币17
					sleep 100
					click,415, 609, 3 ;资源卡6
					sleep 100
					click,326, 614, 3  ;3份钻石注决策资源
					CaptureScreen()
					sleep 300					
                    if !PixelColorExist("0xFEEDC7",82, 391,10) and !PixelColorExist("0xFEEDC7",470, 394,10) ;左右两边都没有显示金钱不够提示
                        throw "Not enough money warning show!"

					click 355, 758	;确认注入
					sleep 200
					if PixelColorExist("0xFBFBFB",479, 391,300) ;确认注入提示框
                    {
                        click 305, 630     ;点击确定
						CaptureScreen()
                        WaitPixelColorAndClick("0xFBFBFB",489, 161,1000)
                    }
					else
                    {
    					CaptureScreen()
                        LogToFile("Exception while LDDiCcanJinzhu: not found the OK button") 
					}
				}
				else
				{
                    LogToFile("0xFFFEF5 and 0x5A7965 exception.")
                    CaptureScreen()
				}

                if !PixelColorExist("0xF2B21B",Px, Py,200)  ;double check 
                {
                    CaptureScreen()
                    LogToFile("LD Land business done.")
                    Break  
                }
			}
			sleep 200		
		}
		SendMode Input		
	}

}





