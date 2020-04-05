#SingleInstance, Force
SetBatchLines, -1
#Include, sfGame.ahk
; click, % Arrayphy["btn1"]

class 4399sfGame extends sfGame
{
	__New(seq,windowname)
	{
		
		global logfilename := % logPath . "\\" . windowname  . "_" . A_now  . ".txt"

		LogToFile("Log started.")

		try
		{
			IfWinExist, %windowname%
			{
				WinActivate %windowname%
				Winmove,%windowname%,,829,23,600,959
				click % this.HB[1]
				LogToFile("Find existing window named: " . windowname)
				sleep 200
			}
			else
			{
				LogToFile("Going to open game: " . windowname)
				this.Launch4399Game(seq,windowname)
				LogToFile("Game opened.")
			}	

			WinGet IDVar,ID,A ; Get ID from Active window.		
			this.WID := IDVar
			this.winName := %windowname%

			LogToFile("Wid is： " . this.WID)
		}
		Catch, e
			{
				CaptureScreen()
				LogToFile("Game open failed: " . e)
			}
	}

    __Delete()
    {
		WinClose, %windowname%
		this.LogToFile("Log Ended.")
    }
	
	WID :=
	HB := ["110, 875","175, 875","240, 875","305, 875","370, 875","435, 875","500, 875"] ; home buttons
	SB := ["140, 260","245,260","350,260","455,260"]                                     ; shanghui buttons
	BC := ["170, 400","420, 400","310, 560","220, 690","410, 690"]                       ; 5个企业 coordinates
	TT := ["134, 481","391, 481","282, 605","232, 691","425, 691"]                       ; Tooltip positions
	PopWin := {okbtn: "324, 602", clobtn: "480, 266"}           						 ; button positions
	RZWin := {rzarea: "200,570", yesbtn: "333, 565", chezibtn: "430, 560"}
	OpenSJList := ["403, 330","403, 444","403, 675","403, 753"]


	PrepareGameWindow()
	{
		WinActivate, % ahk_id this.WID
		sleep 100
	}

	Close4399Game()
	{
		WinClose, %windowname%
	}

	Launch4399Game(Sequ,windowname)
	{
		WinClose, %windowname%
		Loop
		{
			if A_Index > 4
				{
					break
					throw "Cannot launch Game!"
				}

			try 
			{
				run %4399GamePath% -action:opengame -gid:1 -gaid:%Sequ%
				sleep 3000
				WinGetActiveTitle, Title
				WinWaitActive, %Title%
				WinSetTitle, %windowname%
				WinSet, AlwaysOnTop, On, %windowname%
				Winmove,%windowname%,,829,23,600,959
				WaitPixelColor("0x232D4D",544, 84,15000)			;Waiting for up array			{
				sleep 3000
				Click 566, 83
				sleep 1000	
				WaitPixelColorAndClickThrowErr("0x3BB1B2",343, 766,12000) ; Start game button
				WaitPixelColorNotExist("0xB5DF65",521, 601,8000)        ;Waiting for the login page gone.
			}
			Catch e
			{
				CaptureScreen()
				Continue
			}
			sleep 2000
			loop 3
			{
				sleep 1000
				if !PixelColorExist("0xAFC387",473, 105,10)
				{
					this.CloseAnySubWindow()
					break
				}
			}
			WinSet, AlwaysOnTop, off, %windowname%
			break
		}	
	}

	SuanKai()
	{
		WinActivate, %winName%
		sleep 500
		this.CloseAnySubWindow()
		sleep 200
		click 166, 893 ;TouZi
		sleep 200
		click 236, 267
		sleep 200
		loop
		{
			if (PixelColorExist("0xADFFEF",414, 825,10))
				break
			click 236, 267
			sleep 500
			if (A_Index > 4)
				throw "Nob able to open TouZi Page!"
		}
		;WaitPixelColorAndClickThrowErr("0xFFFFFF",283, 247,2000) ;

		if !PixelColorExist("0x4BB2D9",318, 786,10) ;JBP not available
		{
			if PixelColorExist("0x81FBD6",398, 787,10) ; time tunnel available
			{
				click 398, 787
				sleep 200
				WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
				sleep 300
			}	
			Else
			{
				throw "SuanKai():JBP not available!"
			}

		}	

		if !PixelColorExist("0xE4E4E4",447, 756,10) 
			and PixelColorExist("0x4BB3D9",466, 786,10) 
			and !PixelColorExist("0xFFFDEF",447, 756,10) 
		{
			;LogToFile("suankai done for 1,3")
			WaitPixelColorAndClick("0xDEF7EE",471, 737,500)  ; NiuShi button
			sleep 200
			WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
			sleep 300
		}

		sleep 200
		WaitPixelColorAndClickThrowErr("0xDEF7EE",317, 737,1500) ; JBP button
		sleep 200
		WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
		sleep 800
		;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		
		this.Save_Refresh4399()
	}

	Save_Refresh4399()
	{
		click 86, 893
		;Setting Button
		WaitPixelColorAndClickThrowErr("0xFFFFFF",496, 198,3000)
		;Setting page
		if !(WaitPixelColor("0xFFFFF3",405, 321,3000) = 0)
			throw "Setting page cannot found!"

		sleep 100
		click 404, 554 ;Save button
		sleep 1000
		Click, 476, 276 ;Close button
	}

	CloseAnySubWindow()
	{
		loop 5
		{
			ImageSearch, Px, Py, 400, 169, 511, 609, % A_ScriptDir . "\\blockofwhite.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
				Break
			else if (ErrorLevel = 0) ;Image found
			{
				if PixelColorExist("0x1657B0",324, 418,10) ;Daily awards
				{
					click 403, 573
					sleep 100
					click 402, 493
					sleep 100
					click 401, 415
				}
				if PixelColorExist("0xFBFBFB",471, 214,100) ;限时活动
				{
					click 449, 471
					sleep 100
				}
				
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
			ImageSearch, Px, Py, 400, 169, 511, 609, % A_ScriptDir . "\\blockofwhite.bmp"
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

	GetConsortiumMoney()
	{
		WaitPixelColorAndClickThrowErr("0x3E515C",307, 879,2000) ;cai tuan button
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFDFAB",457, 234,2000) ;Shou Ru button	
		sleep 100
	}

	GetDailayTaskMoney()
	{
		if PixelColorExist("0xD12A06",473, 308,20) ;每日任务,如偷满10次
		{
			Click 495, 315
			sleep 200
			Click 420, 420 ;Task 1
			sleep 50
			Click 420, 500 ;Task 2
			sleep 50		
			Click 420, 580 ;Task 3
			sleep 100
			Click 479, 344 ;Close Button
			sleep 200
		}
	}

	BuyTimeSpeedplus()
	{
		click 360, 896
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFFFFF",370, 260,2000) ;Shop button
		

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

	PlayZhuanPan(times = 6)
	{
		click 88, 896
		sleep 200
		WaitPixelColorAndClickThrowErr("0xD1762",505, 387,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times)
		{
			WaitPixelColorAndClickThrowErr("0xF4452A",395,746,2000) ;Ten Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",398, 267,5000) ;Finished once
			sleep 200
			click 398, 267
			sleep 300
			click 453, 388  ;Close double money window if any.
			sleep 200
			CaptureScreen()	
			n++  
		}
	}

	GetGiftScreen()
	{
		this.CloseAnySubWindow()
		sleep 100
		click 246, 196	;gift pack button
		sleep 300
		click 429, 577  ;card button
		sleep 500
		CaptureScreen()
		this.CloseAnySubWindow()
	}

	GetCard(times=150)
	{
		click 246, 196	;click 礼包 button
		sleep 500
		Loop %times%		;循环150次，可按需要调整
		{	
			WaitPixelColorAndClick("0x1657B0",288, 491,10,1000) ;click 每日分享 button
			WaitPixelColorAndClick("0xFCFEFE",347, 640,10,500)  ;click 立即分享 button
			if PixelColorExist("0x5BD157", 285, 530,10) 		;close "分享到" 提示
			{
				click 414, 432
				sleep 200
			}
			if !PixelColorExist("0x97E2E4",327, 633,10)	;close 分享成功或拼图窗口
				this.closeSpeSubWindow(1)
			sleep 200
		}
		this.CloseSpeSubWindow(30)	;关闭所有子窗口
	}


	GetHomePage1()
	{
		this.closeAnySubWindow()
		click % this.HB[1]
		WaitPixelColor("0xFFFFFF",500, 200,2000)		;设置按钮白色
	}

	GetHomePage2_1()
	{
		this.closeAnySubWindow()
		click % this.HB[2]
		WaitPixelColor("0x706B59",398, 288,2000)		;升级旁边的灰色条	
	}

	GetHomePage2_2()
	{
		this.closeAnySubWindow()
		click % this.HB[2]
		WaitPixelColorAndClick("0xFFFFFF",284, 247,1000)	;地产投资白色点
		WaitPixelColor("0xFFFEF5",421, 393,2000)			;白色总点击数框
	}

	GetHomePage3()
	{
		this.closeAnySubWindow()
		click % this.HB[3]
		WaitPixelColor("0xFFFEF5",494, 703,2000)			;The white in Hunt failure count area
	}

	GetHomePage4()
	{
		this.closeAnySubWindow()
		click % this.HB[4]
		WaitPixelColor("0xFFFEF5",497, 333,2000)			;白色公关资金框
	}

	GetHomePage5()
	{
		this.closeAnySubWindow()
		click % this.HB[5]
		WaitPixelColor("0xFFFEF5",492, 354,2000)			;白色人数框
	}	

	GetHomePage6()
	{
		this.closeAnySubWindow()
		click % this.HB[6]
		WaitPixelColor("0xFFF8CE",499, 804,2000)			;第8名后的颜色
	}	

	isBussinessSkillLight()
	{
		this.GetHomePage5(1)
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

	DiCanJinzhu(num)
	{
		this.GetHomePage2_1()
		SendMode Event
		sleep 100
		Mousemove,510, 825
		send {LButton down}
		Mousemove,510, 95,10
		send {LButton up}
		click 510, 825
		sleep 200
		CaptureScreen()
		loop 25
		{
			this.CloseAnySubWindow()
			ImageSearch, Px, Py, 113, 429, 504, 827, % A_ScriptDir . "\\blockofyellow.bmp"
			if (ErrorLevel = 2)  ;Execption when conduct the search
				throw "ImageSearch not work, please check." 
			else if (ErrorLevel = 1) ;Image not found 
			{
				sleep 500
				Mousemove,510, 825
				send {LButton down}
				Mousemove,510, 345,15
				send {LButton up}
				click 510, 825			
				sleep 200
			}
			else if (ErrorLevel = 0) and !PixelColorExist("0x706B59",424, 286,10) ;Image found and not on the first line
			{
				LogToFile("Image found when loop times: " . A_Index)
				CaptureScreen()	
				loop 2
				{
					try
					{
						click %Px%, %Py%
						sleep 200
						if PixelColorExist("0xFFFEF5",185, 469,1000) 
						{
							Mousemove,255, 460
							click, % round(num/2)+2 ;金币注经营资源
							sleep 100
							Mousemove,255, 520
							click, % round(num/2)-3 ;金币注管理资源
							sleep 100
							Mousemove,414, 520
							click, 6				;资源卡注管理资源
							sleep 100
							Mousemove,330,580
							click, 5				;5份钻石注决策资源
							CaptureScreen()	
							sleep 100
							click 361, 704			;确认注入
							sleep 100
							if PixelColorExist("0xFBFBFB",462, 396,500) ;确认注入提示框
							{
								click 302, 593 ;点击确定
								sleep 300
								if PixelColorExist("0x5A7965",329, 284,10)
									throw "Exception while DiCcanJinzhu1."
								
								WaitPixelColorAndClick("0xFBFBFB",479, 192,200)
								CaptureScreen()	
							}	
							else
								throw "Exception while DiCcanJinzhu2."
						}
						break					
					}
					Catch e
					{
						CaptureScreen()
						this.CloseAnySubWindow()
						LogToFile("Land business meet an exception: " e)
					}					
				}

				LogToFile("Land business done, num is " . num)
				break
			}
			sleep 200
		
		}
		SendMode Input			
	}
}










