#SingleInstance, Force
SetBatchLines, -1
#Include, 4399sfGame.ahk
SendMode Input 

class 4399UserTask extends 4399sfGame
{

; <==================================  Properties  ====================================>
	;Nothing for now.
; <================================  Constructure functions  ================================>

	__New(windowname)
	{
		this.winName := windowname

		IniRead, seqid, config.ini, users, %windowname%, 0

		LogToFile("")
		LogToFile("Log started for :" . windowname . ", seq: " . seqid)
		
		if (seqid = 0) or (StrLen(seqid) > 20)
		{
			LogToFile("seq is empty or too long, terminated. ")
			Return
		}

		try
		{
			IfWinExist, %windowname%
			{
				WinActivate %windowname%
				Winmove,%windowname%,,829,23,600,959
				click % HB[1]
				LogToFile("Find existing window named: " . windowname)
				sleep 200
			}
			else
			{
				LogToFile("Going to open game.")
				this.Launch4399Game(seqid,windowname)
				LogToFile("Game opened.")
			}	

			;Assign properties:
			WinGet IDVar,ID,A ; Get ID from Active window.		
			this.WID := IDVar

			LogToFile("Wid is： " . this.WID)
		}
		Catch e
			{
				CaptureScreen()
				LogToFile("Game open failed: " . e)
			}
	}

    __Delete()
    {
		WinClose, %windowname%
		sleep 100
		WinMinimize, 360游戏大厅
		LogToFile("Log Ended for: " . this.winName . ".`n")
    }
	
; <==================================  Command Tasks  ====================================>


; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow(this.winName)
		this.LandPage.DiCanJinzhu(this.Getzhushu())
		LogToFile("GetLand() done, winname: " . this.winName)
		}
		Catch e
		{
		LogToFile("GetLand() get exception: " . e)
		CaptureScreen()
		}
	}

; <========================  每周商技开启  ===========================>

	OpenBusSkill(){	
		try{
			this.PrepareGameWindow(this.winName)
			loop
			{
				this.GroupPage.GetGroupPage2()	
				this.GroupPage.GetGroupPage()
				if this.GroupPage.isBussinessSkillLight()
				{
					CaptureScreen()
					LogToFile("BussinessSkill is light, checking at index: " . A_Index)
					Break
				}	
				Else
				{
					if A_Index > 2
					{
						SendAlertEmail()
						LogToFile("BussinessSkill still gray after loop 2 times.")
						break
					}	
					CaptureScreen()
					LogToFile("Find BussinessSkill not opened, going to open it, index: " . A_Index)				
					this.GroupPage.OpenSJ()
					CaptureScreen()
					LogToFile("After open BussinessSkill.")		
				}
			sleep 1000
			}
		}
		Catch e {
			LogToFile("Open bussinessSkill failed with execption." . e)
			SendAlertEmail()		
		}

	}

; <========================  偷猎  ===========================>

	Hunter(islieshou){ ; 1 will from lieshou, 0 or others will from blacklist
		try{
		this.PrepareGameWindow(this.winName)
		this.GetCaiTuanPage.GetCaiTuanMoney()	
		LogToFile("this.GetCaiTuanPage.GetCaiTuanMoney() done. ")
		}
		Catch e{
		LogToFile("excetion while GetCaiTuanMoney(): " . e)
		CaptureScreen()
		}

		try{
		LogToFile("start to hunter, islieshou: " . islieshou)
		this.LandPage.SuanKai()	
		LogToFile("this.LandPage.SuanKai() done. ")
		this.ShopHomepage.Save_Refresh4399()
		LogToFile("this.ShopHomepage.Save_Refresh4399() done. ")		
		}
		Catch e{
		LogToFile("excetion while Sunkai or save_refresh: " . e)
		CaptureScreen()
		}

		try{
		this.HunterPage.SelectPeopleAndstolen(islieshou)
		this.HunterPage.GetResult()
		LogToFile("this.HunterPage.SelectPeopleAndstolen done. ")	
		}
		Catch e{
		LogToFile("excetion while SelectPeopleAndstolen or GetResult: " . e)
		CaptureScreen()
		}
	}

; <========================  注融资  ===========================>

	ZhuZi(which){
		if (which > 3) or (which = "")
		{
			LogToFile("The passed argument in ZhuZi is: " . which . " > 3, exit!")
			Return
		}

		try
			this.PrepareGameWindow(this.winName)
			this.GroupPage.GroupZhuZi(which)
		Catch e
		{
			LogToFile("this.GroupPage.GroupZhuZi get exception: " . e)
			CaptureScreen()
		}
	}

	RongZi(which){
		try{
		LogToFile("Start to RongZi at : " . which)
		this.PrepareGameWindow(this.winName)
		this.GroupPage.PreRongZi(which)
		this.GroupPage.RongZiOKinternal()
		LogToFile("RongZi done.")
		}
		Catch e{
		LogToFile("this.GroupPage.RongZi() get exception: " . e)
		CaptureScreen()
		}
	}

	PrepareRongZi(which){
		try{
		this.PrepareGameWindow(this.winName)
		this.GroupPage.PreRongZi(which)
		}
		Catch e{
		LogToFile("this.GroupPage.PreRongZi() get exception: " . e)
		CaptureScreen()
		}
	}

	ClickRongZiOK(){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to do ClickRongZiOK.")
		this.GroupPage.RongZiOKpublic()
		LogToFile("ClickRongZiOK() done.")
		}
		Catch e
			CaptureScreen()
	}	

; <========================  转盘  ===========================>

	ZhunPan(times){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("start to ZhuPan, times: " . times)
		this.LandPage.SuanKai()	
		LogToFile("this.LandPage.SuanKai() done. ")
		this.ShopHomepage.Save_Refresh4399()
		LogToFile("this.ShopHomepage.Save_Refresh4399() done. ")		
		}
		Catch e{
		LogToFile("excetion while Sunkai or save_refresh: " . e)
		CaptureScreen()
		}

		try{			
			this.ShopHomepage.PlayZhuanPan(times)
			LogToFile("this.ShopHomepage.PlayZhuanPan done!")			
		}
		Catch e{
		LogToFile("excetion while this.ShopHomepage.PlayZhuanPan: " . e)
		CaptureScreen()
		}
	}

}

