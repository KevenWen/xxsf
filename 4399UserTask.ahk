#SingleInstance, Force
SetBatchLines, -1
#Include, 4399sfGame.ahk
SendMode Input 

class 4399UserTask extends 4399sfGame
{

; <==================================  Properties  ====================================>

RZ[]{
	get{
		IniRead, value, % UserIni, % this.winName,RZ,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni, % this.winName,RZ
	}
}

DC[]{
	get{
		IniRead, value, % UserIni, % this.winName,DC,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni, % this.winName,DC
	}
}

; <================================  Constructure functions  ================================>

	__New(windowname,isclose=1)
	{
		this.winName := windowname
		this.isclosed := isclose
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
				WinSet, AlwaysOnTop, On, %windowname%				
				Winmove,%windowname%,,829,23,600,959
				click % HB[1]
				LogToFile("Find existing window named: " . windowname)
				sleep 200
			}
			else
			{
				LogToFile("Going to open game.")
				this.Launch4399Game(seqid,windowname)
				CaptureScreen()
				LogToFile("Game opened.")
			}
		}
		Catch e
			{
				CaptureScreen()
				LogToFile("Game open failed: " . e)
			}
	}

    __Delete()
    {
		WinSet, AlwaysOnTop, Off, %windowname%	
		if this.isclosed
		{
			WinClose, % this.winName
			sleep 100
			WinMinimize, 360游戏大厅
		}

		LogToFile("Log Ended for: " . this.winName . ".`n")
    }
	
; <==================================  Command Tasks  ====================================>


; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow(this.winName)
		this.LandPage.DiCanJinzhu(this.Getzhushu())
		LogToFile("GetLand() done, winname: " . this.winName)
		this.DC := 1
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
		SendMode Input
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

; <========================  商会相关  ===========================>

	ZhuZi(which){
		if (which > 3) or (which = "")
		{
			LogToFile("The passed argument in ZhuZi is: " . which . " > 3, exit!")
			Return
		}

		try{
			this.PrepareGameWindow(this.winName)
			this.GroupPage.GroupZhuZi(which)
		}
		Catch e{
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
		this.RZ := 1		
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
		this.GroupPage.GroupCheZi()
		this.GroupPage.PreRongZi(which)
		CaptureScreen()
		LogToFile("this.GroupPage.PreRongZi() done. ")
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
		CaptureScreen()		
		this.RZ := 1		
		LogToFile("ClickRongZiOK() done.")
		}
		Catch e{
		LogToFile("ClickRongZiOK get exception: " . e)
		CaptureScreen()
		}
	}	

	CalcRongZi(){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to CalcRongZi.")
		this.GroupPage.CalculateRZ()
		LogToFile("CalcRongZi() done.")
		}
		Catch e{
		LogToFile("CalcRongZi() get exception: " . e)
		CaptureScreen()
		}
	}	

	ShangZhanReport(){
		try{
		SendMode Event
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to get ShangZhanReport.")
		this.OrderPage.GetBussinessWarOrder()
		LogToFile("Start to get GetBussinessWarOrder.")		
		this.GroupPage.CalculateRZ()
		LogToFile("Start to get CalculateRZ.")		
		this.GroupPage.GetZhuZiList()
		LogToFile("Start to get GetZhuZiList.")		
		this.GroupPage.GetShangZhanList()
		LogToFile("ShangZhanReport task done.")		
		}
		Catch e{
		LogToFile("ShangZhanReport() get exception: " . e)
		CaptureScreen()
		}
	}	

	Shopping(which){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to GetShopping at:" . which)
		this.GroupPage.GetShopping(which)
		LogToFile("GetShopping done.")
		CaptureScreen()
		}
		Catch e{
		LogToFile("GetShopping() get exception: " . e)
		CaptureScreen()
		}
	}

; <========================  转盘  ===========================>

	ZhuanPan(times,buytime=1){
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
			if buytime = 1
				this.GroupPage.BuyTimeSpeedplus()
			
			this.ShopHomepage.PlayZhuanPan(times)
			LogToFile("this.ShopHomepage.PlayZhuanPan done!")			
		}
		Catch e{
		LogToFile("excetion while this.ShopHomepage.PlayZhuanPan: " . e)
		CaptureScreen()
		}
	}
; <========================  天梯  ===========================>
	GetTianTi(){
		try{
		LogToFile("Start to Play Tian Ti.")			
		this.PrepareGameWindow(this.winName)
		this.CaiTuanPage.TTOperation()
		}
		Catch e{
		LogToFile("excetion while Play Tian Ti: " . e)
		CaptureScreen()
		WinClose, % this.winName
		}
	}	

}

