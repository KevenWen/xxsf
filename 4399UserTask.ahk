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
		
		global logfilename := % logPath . "\\" . windowname  . "_" . A_now  . ".txt"

		LogToFile("Log started.")

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
			this.winName := windowname
			this.sequ := seq

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
		Switch % this.sequ
		{
			Case 18:
				this.LandPage.DiCanJinzhu(40)
			Case 20:
				this.LandPage.DiCanJinzhu(38)
			Case 24:
				this.LandPage.DiCanJinzhu(40)				
			Case 25:
				this.LandPage.DiCanJinzhu(38)
			Case 26:
				this.LandPage.DiCanJinzhu(38)							
			Case 27:
				this.LandPage.DiCanJinzhu(40)
		}
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

; <========================  每周商技开启  ===========================>

}


