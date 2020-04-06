
class GroupPage{    
	
    GetGroupPage()
	{
		this.closeAnySubWindow()
		click % HB[5]
		WaitPixelColor("0xFFFEF5",492, 354,2000)			;白色人数框
	}

    GetGroupPage2()
	{
		this.GetGroupPage()
		click % SB[2]
		WaitPixelColor("0xFFFEF5",138, 420,2000)			;白色总股份资本框
	}

    GetGroupPage3()
	{
		this.GetGroupPage()
		click % SB[3]
		WaitPixelColor("0xFEF5EA",497, 319,2000)			;商店上的红白条
	}

    GetGroupPage4()
	{
		this.GetGroupPage()
		click % SB[4]
		WaitPixelColor("0x91B65A",461, 349,2000)			;科技企业后的绿色
	}

    BuyTimeSpeedplus()
	{
		this.GetGroupPage3() ;Shop button
		
		if PixelColorExist("0x63B0FF",345, 474,100) ;1-3
		{
			click 345, 474
			sleep 300
			click 323, 593
			sleep 200		
			LogToFile("Shopping buy 1-3")				
		}

		if PixelColorExist("0x63B0FF",450, 474,100) ;1-4
		{
			click 450, 474
			sleep 300
			click 323, 593
			sleep 200		
			LogToFile("Shopping buy 1-4")				
		}


		if PixelColorExist("0x63B0FF",135, 474,100) ;Row 1-1
		{
			click 135, 474
			sleep 300
			click 323, 593 ;OK button	
			;click 462, 394	;Close button, for testing perpose	
			sleep 200			
			LogToFile("Shopping buy 1-1")		
		}

		if PixelColorExist("0x63B0FF",240, 600,100) ;2-2
		{
			click 240, 599
			sleep 300
			click 323, 593
			sleep 200
			LogToFile("Shopping buy 2-2")				
		}		

		sleep 100
		CaptureScreen()	
	}

	isBussinessSkillLight()
	{
		this.GetGroupPage()
		if (PixelColorExist("0xA1FF3D",144, 563) 
			and  PixelColorExist("0xA1FF3D",232, 561)
			and  PixelColorExist("0xA1FF3D",403, 562))
			return 1
		else
			Return 0
	}

	OpenSJ()
	{
		sleep 1000
		Click 146, 562 ;click zhuanqian 技能设置

		For index, value in this.OpenSJList  ;开启赚钱/偷猎/融资/地产技能
		{
			WaitPixelColor("0xFFFFF3",350, 503,1000)
			click, % value
			WaitPixelColorAndClick("0xFAFDFD", 380, 566,1000)	;开启 button
			;WaitPixelColorAndClick("0xFBFBFB", 482, 409,1000)	;关闭 button, for testing only
		}

		sleep 1000
		
		click 492, 249  ; 关闭subwindow
		sleep 100
	}

}