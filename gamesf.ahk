#SingleInstance, Force
SetBatchLines, -1
#Include, Functions.ahk
SendMode Input 

class gamesf
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

SJ[]{
	get{
		IniRead, value, % UserIni,LDPlayer,SJ,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni,LDPlayer,SJ
		IniWrite, % A_Sec . ":" . A_Sec, % UserIni,LDPlayer,Sjtime					
	}
}

; <================================  Constructure functions  ================================>

	__New()
	{}

    __Delete()
    {}
	
; <==================================  Command Tasks  ====================================>

	ReloadGame(){
		try{
		LogToFile("Start to ReloadGame.")
		LogToFile("ReloadGame done.")
		}
		Catch e{
		LogToFile("excetion while ReloadGame: " . e)
		}
	}

; <========================  地产入驻  ===========================>
	
	GetLand(){
		try{
		LogToFile("GetLand() done, winname: " . this.winName)
		this.DC := 1
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
		GameRecordingOn()
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
		GameRecordingOff()		
		Return 1
		}
		Catch e{
		LogToFile("ShangZhanReport() get exception: " . e)
		GameRecordingOff()
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

	ZhuanPan(times,buytime=0,shoprefresh=0){
		try{
		this.PrepareGameWindow(this.winName)
		LogToFile("start to ZhuPan, times: " . times)
		;this.LandPage.SuanKai()	
		LogToFile("this.LandPage.SuanKai() done. ")
		;this.ShopHomepage.Save_Refresh4399()
		LogToFile("this.ShopHomepage.Save_Refresh4399() done. ")		
		}
		Catch e{
		LogToFile("excetion while Sunkai or save_refresh: " . e)
		}

		try{			
			if buytime = 1
			{
				;this.GroupPage.BuyTimeSpeedplus()
				LogToFile("this.GroupPage.BuyTimeSpeedplus done one time!")				
				if shoprefresh = 1
				{
					this.GroupPage.RefreshShoppingList()
					this.GroupPage.BuyTimeSpeedplus()
					LogToFile("this.GroupPage.BuyTimeSpeedplus done after refresh shopping list!")						
				}
			}
			
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
		LogToFile("Start to GetCard, times: " . times)

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
		
		LogToFile("Play Tian Ti Done.")		
		}
		Catch e{
		LogToFile("excetion while Play Tian Ti: " . e)
		}
	}	

	GetZZList(){
		try{
		LogToFile("Start to GetZZList.")			
		this.PrepareGameWindow(this.winName)
		SendMode Event
		;this.GroupPage.GetZhuZiList()
		SendMode input		
		}
		Catch e{
		LogToFile("excetion while GetZZList: " . e)
		}
	}	

}

