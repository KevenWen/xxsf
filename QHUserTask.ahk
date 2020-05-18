#SingleInstance, Force
SetBatchLines, -1
#Include, QHsfGame.ahk

class QHUser extends QHsfGame
{

; <==================================  Properties  ====================================>

RZ[]{
	get{
		IniRead, value,% UserIni,xxsf,RZ,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni,xxsf,RZ
		IniWrite, % A_Min . ":" . A_Sec, % UserIni,xxsf,Rztime		
	}
}

DC[]{
	get{
		IniRead, value, % UserIni,xxsf,DC,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni,xxsf,DC
		IniWrite, % A_Min . ":" . A_Sec, % UserIni,xxsf,Dctime
	}
}
; <================================  Constructure functions  ================================>

	__New(isclose=1)
	{
		this.winName := xxsf
		this.isclosed := isclose
		LogToFile("`nLog started for QH xxsf.")

		try
		{
			IfWinExist, xxsf
        	{
				WinActivate, xxsf
				Winmove,xxsf,,933,19,600,959
				sleep, % s["short"]
				LogToFile("Find existing window named xxsf. " )
			}
			else
			{
				LogToFile("Going to open game.")
				this.LaunchQHGame()
				LogToFile("Game opened.")
			}
		}
		Catch e
			{
				CaptureScreen()
				LogToFile("Game open failed: " . e)
				return
			}
	}

    __Delete()
    {
		if this.isclosed
		{
			WinClose, xxsf
			sleep 100
			WinMinimize, 360游戏大厅
		}
		LogToFile("Log Ended. `n")
    }
	
; <==================================  Command Tasks  ====================================>

; <========================  地产入驻  ===========================>
	
	GetLand()
	{
		try{
		this.PrepareGameWindow()	
		this.DiCanJinzhu()
		this.DC := 1		
		LogtoFile("QH GetLand() done. ")
		}
		Catch e
		{
		LogtoFile("QH GetLand() get exception: " . e)
		CaptureScreen()
		}
	}

; <========================  注融资  ===========================>

	ZhuZi(which)
	{
		if which > 3
		{
			LogToFile("The passed argument in ZhuZi is: " . which . " > 3, exit!")
			Return
		}
		try{
			this.PrepareGameWindow()
			this.GroupZhuZi(which)
			LogToFile("this.GroupZhuZi done.")
		} Catch e{
			LogToFile("this.GroupZhuZi get exception: " . e)
			CaptureScreen()
		}
	}

	RongZi(which=5)
	{
		try{
			this.PrepareGameWindow()

			if this.isRongZiprepared(){			
			LogToFile("Find RongZi prepared, going to click OK. ")			
			this.RongZiOKpublic()
			} else {
			LogToFile("Start to RongZi at : " . which)
			this.PreRongZi(which)
			this.RongZiOKinternal()
			}
			this.RZ := 1			
			LogToFile("this.RongZi done.")
		}
		Catch e{
			LogToFile("this.RongZi() get exception: " . e)
			CaptureScreen()
		}
	}

	PrepareRongZi(which)
	{
		try{
		this.PrepareGameWindow()
		this.CheZi()
		this.PreRongZi(which)
		}
		Catch e{
		LogToFile("this.PreRongZi() get exception: " . e)
		CaptureScreen()
		}
	}

; <========================  转盘  ===========================>

	ZhuPan(times)
	{	
		LogtoFile("QH ZhuPan not implement yet.")
	}

; <========================  每周商技开启  ===========================>

	OpenBusinessSkill()
	{
		LogtoFile("QH open BussinessSkill not implement yet.")
	}

; <========================  偷猎  ===========================>

	Hunter(islieshou) ; 1 will from lieshou, 0 or others will from blacklist
	{	
		LogtoFile("QH Hunter not implement yet.")
	}

}