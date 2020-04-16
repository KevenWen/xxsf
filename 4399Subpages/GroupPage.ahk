
class GroupPage{
	
	GetGroupPage()
	{
		loop{
			if A_Index > 2
				throw "Not able to GetGroupPage, PixelColorExist 0xFFFEF5 492 354 not exist."
			4399sfGame.closeAnySubWindow()
			click % HB[5]
            sleep 100			
			if PixelColorExist("0xFFFEF5",492, 354,2000)			;白色人数框
				break
		}
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
		Click 146, 562 ;click 赚钱 技能设置

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

	GroupZhuZi(which)
	{
		this.GetGroupPage2()
		CaptureScreen()
		loop 8		;有可能有红包挡住，等几秒钟再试
		{
			if PixelColorExist("0xFFF8CE",272, 320,10)
				Break
			else
				sleep, % s["mid"]
		}
		if PixelColorExist("0xFFF8CE",272, 302,100) ; 还没有注过资.
		{
			num := % 4399sfGame.Getzhushu()
			loop %num%
			{
				click % StockPos[which]
				sleep 50
			}
			sleep % s["short"]
			click % PopWin["zhuziok"]
			sleep, % s["short"] 
			click % PopWin["okbtn"]
			LogToFile("zhuzi done for which: " . which . " num: " . num)
		}	
		else
			LogToFile("ZhuZi already done yet, no need do again.")

		sleep, % s["short"]
		CaptureScreen()
	}

	GroupCheZi()
	{
		this.GetGroupPage4()
		Loop 5
		{
			click % BC[A_index]
			sleep, % s["long"]
			if PixelColorExist("0xFBFBFB",480, 269,1000)   
			and (PixelColorExist("0xFDFBF0",212, 573,10) or PixelColorExist("0xFFFEF5",212, 573,10)) ;FDFBF0 in home, FFFEF5 in phy
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
		SetDefaultMouseSpeed 30
		SendMode Event
		click, % 4399sfGame.Getzhushu()-1
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

    RongZiOKpublic()
	{
		loop 5
		{
			if !4399sfGame.SubWindowExist()
				break
			if !PixelColorExist("0xF4FCFC",348, 581,10)
				4399sfGame.CloseSpeSubWindow(1)
			if PixelColorExist("0xF4FCFC",348, 581,10)
			{
				click % PopWin["okbtn"]
				sleep, % s["short"]
				click % PopWin["okbtn"]
				sleep, % s["short"]
				CaptureScreen()
			}	
		}
	}

	GetRongZiCom()
	{
		this.GetGroupPage4()
		if PixelColorNotExist("0xCDCDCD",156, 514,500) ;查看连接到游乐的融资线是否存在
			Return 1
		else if PixelColorNotExist("0xCCCCCC",362, 483,500) ;科技
			Return 2
		else if PixelColorNotExist("0xCCCCCC",252, 631,500) ;金融
			Return 3	
		else if PixelColorNotExist("0xABA9A5",166, 737,500) ;能源
			Return 4
		else if PixelColorNotExist("0x7DAECA",321, 734,500) ;洒店
			Return 5
		else
			Return 3
	}

}