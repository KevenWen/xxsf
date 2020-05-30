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
		IniWrite, % A_Min . ":" . A_Sec, % UserIni, % this.winName,Rztime
	}
}

DC[]{
	get{
		IniRead, value, % UserIni, % this.winName,DC,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni, % this.winName,DC
		IniWrite, % A_Min . ":" . A_Sec, % UserIni, % this.winName,Dctime		
	}
}

; <================================  Constructure functions  ================================>

	__New(windowname,isclose=1)
	{
		this.winName := windowname
		this.isclosed := isclose
		seqid := idtable[windowname]

		LogToFile("")
		LogToFile("Log started for :" . windowname . ", seq: " . seqid)
		
		if (seqid = "") or (StrLen(seqid) > 20)
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
				LogToFile("Find existing window named: " . windowname)
				sleep 200
			}
			else
			{
				LogToFile("Going to open game.")
				this.Launch4399Game(seqid,windowname)
				LogToFile("Game opened.")
			}
		}
		Catch e
			{
				LogToFile("Game open failed: " . e)
				return
			}
	}

    __Delete()
    {
		if this.isclosed
		{
			WinClose, % this.winName
			sleep 100
			WinMinimize, 360游戏大厅
		}
		else
			WinMinimize, % this.winName

		LogToFile("Log Ended for: " . this.winName . ".`n")
    }
	
; <==================================  Command Tasks  ====================================>

	ReloadGame(){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to ReloadGame.")			
		this.ShopHomepage.Reload()
		LogToFile("ReloadGame done.")
		return 1
		}
		Catch e{
		LogToFile("excetion while ReloadGame: " . e)
		WinClose, % this.winName
		return 0
		}
	}

; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		this.PrepareGameWindow(this.winName)
		this.LandPage.DiCanJinzhu(this.Getzhushu())
		LogToFile("GetLand() done, winname: " . this.winName)
		this.DC := 1
		return 1
		}
		Catch e
			LogToFile("GetLand() get exception: " . e)
	}

; <========================  每周商技开启  ===========================>

	OpenBusinessSkill(){	
		try{
			this.PrepareGameWindow(this.winName)
			loop
			{
				this.GroupPage.GetGroupPage2()	
				this.GroupPage.GetGroupPage()
				if this.GroupPage.isBussinessSkillLight()
				{
					LogToFile("BussinessSkill is light, checking at index: " . A_Index)
					Break
				}	
				Else
				{
					if A_Index > 3
					{
						SendAlertEmail()
						throw "BussinessSkill still gray after loop 2 times."
					}
					LogToFile("Find BussinessSkill not opened, going to open it, index: " . A_Index)				
					this.GroupPage.OpenSJ()
					sleep 500
					LogToFile("After open BussinessSkill.")
					Return 1		
				}
			sleep 1000
			}
		}
		Catch e {
			LogToFile("Open bussinessSkill failed with execption." . e)	
			SendAlertEmail()
			Return 0		
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
		}

		try{
		this.HunterPage.SelectPeopleAndstolen(islieshou)
		this.HunterPage.GetResult()
		LogToFile("this.HunterPage.SelectPeopleAndstolen done. ")
		Return 1	
		}
		Catch e{
		LogToFile("excetion while SelectPeopleAndstolen or GetResult: " . e)
		}
	}

	GetCaiTuan()
	{
		try{
		this.PrepareGameWindow(this.winName)
		this.CaiTuanPage.GetCaiTuanMoney()	
		LogToFile("this.GetCaiTuanPage.GetCaiTuanMoney() done. ")
		}
		Catch e{
		LogToFile("excetion while GetCaiTuanMoney(): " . e)
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
			Return 1
		}
		Catch e{
			LogToFile("this.GroupPage.GroupZhuZi get exception: " . e)
			Return 0
		}
	}

	RongZi(which=3){
		try{
			this.PrepareGameWindow(this.winName)

			if this.GroupPage.isRongZiprepared(){
			LogToFile("Find RongZi prepared, going to click OK. ")			
			this.GroupPage.RongZiOKpublic()
			}
			else {
			LogToFile("Start to RongZi at : " . which)
			this.GroupPage.PreRongZi(which)
			this.GroupPage.RongZiOKinternal()
			}
			this.RZ := 1		
			LogToFile("RongZi done.")
			Return 1
		}
		Catch e{
			LogToFile("this.GroupPage.RongZi() get exception: " . e)
			Return 0
		}
	}

	PrepareRongZi(which){
		try{
		this.PrepareGameWindow(this.winName)
		this.GroupPage.GroupCheZi()
		this.GroupPage.PreRongZi(which)
		LogToFile("this.GroupPage.PreRongZi() done. ")
		Return 1
		}
		Catch e{
		LogToFile("this.GroupPage.PreRongZi() get exception: " . e)
		Return 0
		}
	}

	CalcRongZi(){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to CalcRongZi.")
		this.GroupPage.CalculateRZ()
		LogToFile("CalcRongZi() done.")
		Return 1
		}
		Catch e{
		LogToFile("CalcRongZi() get exception: " . e)
		Return 0
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
		Return 1		
		}
		Catch e{
		LogToFile("ShangZhanReport() get exception: " . e)
		Return 0
		}
	}	

	Shopping(which){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to GetShopping at:" . which)
		this.GroupPage.GetShopping(which)
		LogToFile("GetShopping done.")
		Return 1
		}
		Catch e{
		LogToFile("GetShopping() get exception: " . e)
		Return 0
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
		}

		try{			
			if buytime = 1
				this.GroupPage.BuyTimeSpeedplus()
			
			this.ShopHomepage.PlayZhuanPan(times)
			LogToFile("this.ShopHomepage.PlayZhuanPan done!")
			Return 1
		}
		Catch e{
		LogToFile("excetion while this.ShopHomepage.PlayZhuanPan: " . e)
		Return 0
		}
	}

; <========================  拼图  ===========================>

	GetCard(times){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("Start to GetCard, times: " . times)
		this.ShopHomepage.GetDailayTaskMoney()					
		this.ShopHomepage.GetCards(times)
		LogToFile("GetCard done.")
		}
		Catch e{
		LogToFile("excetion while GetCard: " . e)
		WinClose, % this.winName
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
		WinClose, % this.winName
		}
	}	

}

