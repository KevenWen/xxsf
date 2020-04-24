
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
		loop
		{
			if A_index > 2
				throw, "Tried 2 times but still not able to prepare RongZi."

			this.GetGroupPage4()
			
			click, % BC[RZCom]
			sleep, % s["long"]		

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

			sleep, % s["mid"]
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
		sleep, % s["mid"]
		CaptureScreen()
		if PixelColorExist("0xFFFEF5", 401, 419,3000) ;close the sub window if the first window closed
			click % PopWin["clobtn"]
	}

    RongZiOKpublic()
	{
		loop 5
		{
			if !PixelColorExist("0xFFFFFF",139, 400,10) and !PixelColorExist("0xB2A68C",300, 650,10) ;左上白点和确定button下的第二个弹出窗口color
			{
				CaptureScreen()
				4399sfGame.CloseSpeSubWindow(1)								
			}	

			if PixelColorExist("0xFFFFFF",139, 400,10)
			{
				click % PopWin["okbtn"]
				sleep, % s["short"]
				click % PopWin["okbtn"]
				sleep, % s["short"]
				CaptureScreen()
				break
			}	

			if !4399sfGame.SubWindowExist()
				throw "Not found RongZi OK button!"
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

	CalculateRZ()
	{
		TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                       ; Tooltip positions
		Bvals := ["1621 353 1701 370","1624 379 1697 396","1626 457 1665 472"]               ; 企业加成的三个值的coordinates
		Totalpercent := 0        ;所在商会所有企业总加成
		Totalcount := 0          ;所在商会融资总注数
		TotalpercentAll := 0     ;本服所有企业总加成
		TotalcountAll := 0       ;本服融资总注数
		CloseAtEnd := 0          ;whether close the script, if started by this script then close it.
		WinGetActiveTitle, A_title
		Winmove,%A_title%,,1229,23,600,959
    	this.GetGroupPage4()

		loop 5
    	{
			;v22： 商会融资占股， 第二行数值， 百分比
			;v21： 企业总赚钱速度加成， 第一行数值，百分比
			;v23： 商会占有股份数， 第五行（最后一行）数值
			4399sfGame.CloseAnySubWindow()
			click, % BC[A_index]
			MouseMove, 0,0
			sleep, % s["longer"]

			RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1630 379 1694 396" "--clipboard",, Hide ;商会融资占股百分比
			sleep, % s["short"]
			v22 := StrReplace(StrReplace(Clipboard, " "), "%")   ;remove the % and space
			v22 := StrReplace(StrReplace(v22,"O","0"),"o","0")   ;remove the O / o 
			LogToFile(v22)
	
			v22 /= 100.0
			LogToFile(v22)
			if v22=0  ; 如果当前企业没有融资，跳过到下一个企业
				Continue

			RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1648 352 1675 369" "--clipboard",, Hide ;企业总赚钱速度加成
			sleep, % s["short"]
			v21 := StrReplace(StrReplace(StrReplace(Clipboard, " "), "+"),"%")
			v21 := StrReplace(StrReplace(v21,"O","0"),"o","0") ;remove the O / o
			LogToFile(v21)
			v21 += 0.0
			LogToFile(v21)

			if PixelColorExist("0xFFFEF5",446, 441,10)          ;融资份数0
				RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1632 457 1659 470" "--clipboard",, Hide   ;商会占有股份
			else if PixelColorExist("0xFFFEF5",451, 442,10)     ;融资份数两位数
				RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1632 457 1664 470" "--clipboard",, Hide
			Else                                                ;融资份数三位数
				RunWait, "D:\\Program Files\\Capture2Text\\Capture2Text_CLI.exe" "-s" "1632 457 1668 470" "--clipboard",,Hide

			sleep, % s["short"]    
			v23 := StrReplace(Clipboard, " ")
			v23 := StrReplace(StrReplace(v23,"O","0"),"o","0") ;remove the O / o
			LogToFile(v23)
			v23 += 0.0
			CurrentTotal := Round(v23 / v22)    
			Totalcount += Round(v23)
			Totalpercent += (v21 * v22)
			TotalcountAll += CurrentTotal
			TotalpercentAll += v21        

			click 486, 265
			sleep, % s["short"]
			TTCo := StrSplit(TT[A_index],",")
			ToolTip, % "+" . Round(v21) . "% / " . CurrentTotal . "`r`n"  ; The total number and percent
			. "+" . Round(v21 * v22) . "% / " . Round(v23) . ", " . Round(v21 * v22 / v23,4) . "`r`n"   ; How much we takes    
			. "+-38: +" . Round(v21 * (v23 + 38.0) / (CurrentTotal + 38.0) - v21 * v22,1) . "%, -"  ; If add / remove 38, waht's the change
			. ((v23 < 38.0)?Round(v21 * v22):Round(v21 * v22 - v21 * (v23 - 38.0) / (CurrentTotal - 38.0),1)) . "%" ;if the value minus big than current value,just show current
			, TTCo[1], TTCo[2]
			, A_index
    	}

		sleep, % s["short"]
		ToolTip, % "Total:" . "`r`n"
		. "+" . Round(TotalpercentAll) . "% / " . TotalcountAll . ", " . Round(TotalpercentAll / TotalcountAll,4) . "`r`n"    
		. "+" . Round(Totalpercent) . "% / " . Totalcount . ", " . Round(Totalpercent / Totalcount,4) . "`r`n"
		, 223, 337, 6
		sleep, % s["long"]
		CaptureScreen()
		sleep, % s["longest"]
		loop 6
			Tooltip,,,,A_index   ;Remove the tooltips
	}
	
	GetZhuZiList()
	{
		this.GetGroupPage2()
		sleep 200
		CaptureScreen()	
		sleep 200
		MouseClickDrag, Left, 302, 853,304, 483
		sleep 500
		CaptureScreen()		
		sleep 500
		MouseClickDrag, Left, 302, 853,304, 483
		sleep 500
		CaptureScreen()		
		sleep 1000
	}

	GetShangZhanList()
	{
		this.GetGroupPage()
		CaptureScreen()		
		sleep 2000
		if PixelColorExist("0xFFF8CE",121, 471,10) ;ShangZhang Button not exist
			throw "Shangzhnag not start yet!"

		click 120, 464 ;shangzhang button
		sleep 200
		CaptureScreen()		
		sleep 2000
		CaptureScreen()				
		/* 
		sleep 180000
		Loop
		{	CaptureScreen()		
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