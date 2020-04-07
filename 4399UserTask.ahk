#SingleInstance, Force
SetBatchLines, -1
#Include, 4399sfGame.ahk
; click, % Arrayphy["btn1"]

class 4399UserTask extends 4399sfGame
{

; <==================================  Properties  ====================================>
	;Nothing for now.
; <================================  Constructure functions  ================================>

	__New(seq,windowname)
	{
		this.winName := windowname
		this.sequ := seq
		global logfilename := % logPath . "\\" . windowname  . "_" . A_now  . ".txt"

		LogToFile("Log started.")
		if !this.CheckName()
		{
			LogToFile("seq and windowname not consistent, stop further process: " 
			. seq . " is seq and windowname is: " . windowname)
			ExitApp
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
				LogToFile("Going to open game: " . windowname)
				this.Launch4399Game(seq,windowname)
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
		this.LogToFile("Log Ended.")
    }
	
; <==================================  Command Tasks  ====================================>

; <========================  地产入驻  ===========================>
	
	GetLand()
	{
		this.LandPage.DiCanJinzhu(this.Getzhushu())
		LogtoFile("DiCanJinzhu done: " . this.winName . "sequ: " . this.sequ)
	}

; <========================  每周商技开启  ===========================>

	OpenBusSkill()
	{	
		loop
		{
			this.GroupPage.GetGroupPage2()	
			this.GroupPage.GetGroupPage()
			if this.GroupPage.isBussinessSkillLight()
			{
				CaptureScreen()
				LogtoFile("BussinessSkill is light, checking at index: " . A_Index)
				Break
			}	
			Else
			{
				if A_Index > 2
				{
					SendAlertEmail()
					LogtoFile("BussinessSkill still gray after loop 2 times.")
					break
				}	
				CaptureScreen()
				LogtoFile("Find BussinessSkill not opened, going to open it, index: " . A_Index)				
				this.GroupPage.OpenSJ()
				CaptureScreen()
				LogtoFile("After open BussinessSkill.")		
			}
		sleep 1000
		}
	}

; <========================  偷猎  ===========================>

	Hunter(fromList)
	{	
		this.LandPage.SuanKai()	
		this.ShopHomepage.Save_Refresh4399()
		this.HunterPage.SelectPeopleAndstolen(fromList)
	}

; <========================  注融资  ===========================>

	ZhuZi(which)
	{
		if which > 3
		{
			LogToFile("The passed argument in ZhuZi is: " . which . " > 3, exit!")
			Return
		}
		this.GroupPage.GroupZhuZi(which)
	}

	CheZi()
	{
		this.GroupPage.GroupCheZi()
	}

	RongZi(which)
	{
		this.GroupPage.PreRongZi(which)
		this.GroupPage.RongZiOK()
	}

	ClickRongZiOK()
	{
		this.GroupPage.RongZiOK()
	}	
}