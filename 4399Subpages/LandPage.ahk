
class LandPage{    

	GetLandPage()
	{
		loop{
            if A_Index > 2
                throw "Not able to GetLandPage."
            4399sfGame.closeAnySubWindow()
            click % HB[1]
            sleep 200
            click % HB[2]
            sleep 200
            if PixelColorExist("0x9E9E9E",72, 797,4000)		;No5 左边的灰色带
                Break
        }    
    }

	GetLandPage2()
	{
		this.GetLandPage()
		WaitPixelColorAndClick("0xFFFFFF",284, 247,1000)	;地产投资白色点
		if !PixelColorExist("0xFFFEF5",421, 393,2000)		;白色总点击数框
        {
            WaitPixelColorAndClick("0xFFFFFF",284, 247,1000)	;click again just in case.
            WaitPixelColor("0xFFFEF5",421, 393,2000)
        }    
	}

    SuanKai()
    {
	    this.GetLandPage2()

        if !PixelColorExist("0x4BB2D9",318, 786,10) ;JBP not available home
        and !PixelColorExist("0x4AB2D9",318, 786,10) ;JBP not available phy
        and !PixelColorExist("0x4AB1D8",318, 786,10)  ;JBP not available remote
        {
            if PixelColorExist("0x81FBD6",398, 787,10) ; time tunnel available
            or PixelColorExist("0x81F1CB",398, 787,10) ; time tunnel available remote
            {
                click 398, 787
                sleep 200
                WaitPixelColor("0xFFF8CE",440, 357,2000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
                click 445, 469                            ; Use button           
                sleep 300
            }	
            Else
                throw "SuanKai():JBP not available!"
        }	

        if !PixelColorExist("0xE4E4E4",447, 756,10) 
            and (PixelColorExist("0x4BB3D9",466, 786,10) or PixelColorExist("0x4AB1D8",466, 786,10))
            and !PixelColorExist("0xFFFDEF",447, 756,10) 
        {
            ;LogToFile("suankai done for 1,3")
            WaitPixelColorAndClick("0xDEF7EE",471, 737,500)  ; NiuShi button
            sleep 100
            WaitPixelColor("0xFFF8CE",440, 357,2000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
            click 445, 469                            ; Use button
        }

        sleep 200
        WaitPixelColorAndClickThrowErr("0xDEF7EE",317, 737,1500) ; JBP button
        sleep 200
        WaitPixelColor("0xFFF8CE",440, 357,2000)  ;窗口上方空白颜色，如果是1500钻石窗口，颜色会不一样
        click 445, 469                            ; Use button
        sleep 500
        ;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		

        this.Save_Refresh4399()
    }

	isPrepared()
	{
        if A_Sec > 20
        {
            LogToFile("Land business just click time expired, current secs: " . A_Sec)
            return 0
        }

		if PixelColorExist("0x7C7C7C",478, 191,10) or PixelColorExist("0xB0B0B0",478, 191,10)
		{
			LogToFile("Find land business prepared, just click OK.")
			click 293, 592     ;点击确定
			sleep 200
			click 293, 592     ;点击确定
			sleep 200
    		loop 4
			{
                click 361, 704	   ;再次确认注入
                sleep 200
                if PixelColorExist("0xFFFFF3",312, 549,1000) ;确认注入提示框
                {
                    click 302, 593     ;点击确定
                    sleep 300               
                    click 465, 406
                    sleep 500
                }
				if PixelColorExist("0xFD8F45",446, 257,10)
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

    DiCanJinzhu(num)
    {
		if this.isPrepared()
			return
        this.GetLandPage()        
        SendMode Event
        sleep 300
        4399sfGame.CloseAnySubWindow()
        if !PixelColorExist("0x706B59",268, 415,10) and PixelColorExist("0x706B59",375, 417,10) ;the gray color on the top
        {
            LogToFile("Land business already done, no action needed." )
            return  
        }
        sleep 100                
        Mousemove,510, 825
        send {LButton down}
        Mousemove,510, 140,4
        send {LButton up}
        click 510, 825
        sleep 200
        loop
        {
            4399sfGame.CloseAnySubWindow()
            ImageSearch, Px, Py, 113, 429, 504, 827, % A_ScriptDir . "\img\blockofyellow.bmp"
            if (ErrorLevel = 2)  ;Execption when conduct the search
                throw "ImageSearch not work, please check." 
            else if (ErrorLevel = 1) ;Image not found 
            {
                sleep 200
                4399sfGame.CloseAnySubWindow()                
                Mousemove,510, 825
                send {LButton down}
                Mousemove,510, 400,15
                send {LButton up}
                click 510, 825			
                sleep 200
            }
            else if (ErrorLevel = 0) ;Image found 
            {
                LogToFile("Image found when loop times: " . A_Index)
                ;MouseMove, %Px%, %Py%
                click %Px%, %Py%
                sleep 200                        
                if PixelColorExist("0xFFFEF5",169, 472,1000)    ;经营资源输入框存在
                and PixelColorExist("0x5A7965",331, 353,10)     ;且上面图片显示是闲置土地
                {
					click,265, 465, 11 ;经营1
					sleep 100
					click,265, 525, 15  ;经营2
					sleep 100
					click,265, 585, 11  ;经营3
					sleep 300	
                    if !PixelColorExist("0xFEEDC7",122, 389,10) and !PixelColorExist("0xFEEDC7",460, 398,10) ;左右两边都没有显示金钱不够提示
                        throw "Not enough money warning show!"

                    click 361, 704			;确认注入
                    sleep 100
                    if PixelColorExist("0xFFFFF3",312, 549,3000)     ;确定提示框存在              
                    {
                        click 302, 593      ;点击确定  
                        WaitPixelColorAndClick("0xFBFBFB",479, 192,1000)
                    }	
                    else
                    {
                        LogToFile("Exception while DiCcanJinzhu2: not found the OK button, will continue")
                        Continue 
                    }
                }
                else
                {
                    LogToFile("0xFFFEF5 and 0x5A7965 exception, will continue")
                    Continue
                }

                if !PixelColorExist("0x706B59",504, 373,200) and !PixelColorExist("0x706B59",506, 414,10) ;the button is exist
                {
                    LogToFile("Land business done, num is " . num)
			        sleep 200                     
                    Break  
                }                      
            }      
			if A_index > 10
				throw "DicanJinzhu loop more than 10 times still not get a free land."
        }
        SendMode Input			
    }


}