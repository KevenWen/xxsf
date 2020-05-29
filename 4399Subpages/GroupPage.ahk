
class GroupPage{
	
	GetGroupPage()
	{
		loop{
			if A_Index > 2
				throw "Not able to GetGroupPage, PixelColorExist 0xFFFEF5 492 354 not exist."
			closeAnySubWindow()
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
	}

    GetShopping(flag)
	{
		this.GetGroupPage3() ;Shop button
		Switch flag
		{
			Case "1-1":
				Click 120,500
			Case "1-2":
				Click 230,500
			Case "1-3":
				Click 340,500
			Case "1-4":
				Click 450,500
			Case "2-1":
				Click 120,620
			Case "2-2":
				Click 230,620
			Case "2-3":
				Click 340,620
			Case "2-4":
				Click 450,620
			Default:
				Throw "Not a correct flag, out of scope."	
		}

		sleep 300
		click 323, 593
		sleep 200
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

	isRongZiprepared()
	{
		return (PixelColorExist("0xB0B0B0",480, 268,100) or PixelColorExist("0x7C7C7C",480, 268,10))
	}

	OpenSJ()
	{
		sleep 1000
		Click 146, 562 ;click 赚钱 技能设置

		For index, value in OpenSJList  ;开启赚钱/偷猎/融资/地产技能
		{
			sleep 100	
			PixelColorExist("0xFFFFF3",350, 503,2000)
			sleep 100
			click, % value
			PixelColorExist("0xFAFDFD",380, 566,2000)	;开启 button
			click, 380, 566
			;WaitPixelColorAndClick("0xFBFBFB", 482, 409,1000)	;关闭 button, for testing only
			LogToFile("Open BussinessSkill for index: " . index)
		}

		sleep 1000
		
		click 492, 249  ; 关闭subwindow
		sleep 100
		return 1
	}

	GroupZhuZi(which)
	{
		this.GetGroupPage2()
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
			sleep % s["mid"]
			if !PixelColorExist("0xFFF8CE",62, 393,100) ; 没有金币不足提示.
				throw, "Not enough money warning exit!"

			click % PopWin["zhuziok"]
			sleep, % s["short"] 
			click % PopWin["okbtn"]
			LogToFile("zhuzi done for which: " . which . " num: " . num)
		}	
		else
			LogToFile("ZhuZi already done yet, no need do again.")

		sleep, % s["longer"]		
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
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to prepare RongZi."

			this.GetGroupPage4()
			
			click, % BC[RZCom]
			if !PixelColorExist("0xFFFEF5",230, 574,2000) ; 不是显示0份
			throw, "Already RongZi, not zero!"

			mousemove, 200, 574
			sleep, % s["short"]
			SetDefaultMouseSpeed 30
			SendMode Event
			click, % 4399sfGame.Getzhushu()-1
			SetDefaultMouseSpeed 2		
			sleep, % s["mid"]

			if !PixelColorExist("0xFFFFF3",268, 396,10) ;存在没有更多金币提示.!
				Throw, "Not enough money warnning exist!"    

			click % RZWin["yesbtn"]
			if !PixelColorExist("0xFFFFFF",139, 400,2000)
				Continue
			else
				Break   
		}

	}

	RongZiOKinternal()
	{
		click % PopWin["okbtn"]
		sleep, % s["short"]
		if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
			click % PopWin["clobtn"]
	}

    RongZiOKpublic()
	{
		loop 5
		{
			if !PixelColorExist("0xFFFFFF",139, 400,10) and !PixelColorExist("0xB2A68C",300, 650,10) ;左上白点和确定button下的第二个弹出窗口color
			{
				CloseSpeSubWindow(1)
				LogToFile("RongZiOKpublic closed an unexpected window.")															
			}	

			if PixelColorExist("0xFFFFFF",139, 400,10)
			{
				LogToFile("RongZiOKpublic find OK window, going to click")			
				click % PopWin["okbtn"]
				sleep, % s["short"]
				click % PopWin["okbtn"]		
				sleep, % s["short"]
				break
			}	

			if !SubWindowExist()
				throw "Not found RongZi OK button!"
		}
	}

	GetZhuZiList()
	{
		this.GetGroupPage2()
		sleep 1000
		MouseClickDrag, Left, 302, 853,304, 483
		sleep 1000
		MouseClickDrag, Left, 302, 853,304, 483
		sleep 1000
	}

	GetShangZhanList()
	{
		this.GetGroupPage()
		sleep 2000
		if PixelColorExist("0xFFF8CE",121, 471,10) ;ShangZhang Button not exist
			throw "Shangzhnag not start yet!"

		click 120, 464 ;shangzhang button
		sleep 200		
		sleep 2000			
		/* 
		sleep 180000
		Loop
		{
			sleep 2000

			if PixelColorExist("0xFFFFF3",417, 474,10)
				break  ; Check if End
			if (A_Index > 35)
				break ; if timeout	

			sleep 90000
		}
		*/
	}

}