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
	}
}

DC[]{
	get{
		IniRead, value, % UserIni,xxsf,DC,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni,xxsf,DC
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
				WinSet, AlwaysOnTop, On, xxsf		
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
			}
	}

    __Delete()
    {
		WinSet, AlwaysOnTop, Off, xxsf	
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

	RongZi(which)
	{
		try{
		LogToFile("Start to RongZi at : " . which)
		this.PrepareGameWindow()
		this.PreRongZi(which)
		this.RongZiOKinternal()
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

	ClickRongZiOK()
	{
		try{
		this.PrepareGameWindow()
		LogToFile("Start to do ClickRongZiOK.")
		this.RongZiOKpublic()
		CaptureScreen()			
		this.RZ := 1			
		LogToFile("ClickRongZiOK() done.")
		}
		Catch e
			CaptureScreen()
	}	

; <========================  转盘  ===========================>

	ZhuPan(times)
	{	
		LogtoFile("QH ZhuPan not implement yet.")
	}

; <========================  每周商技开启  ===========================>

	OpenBusSkill()
	{
		LogtoFile("QH open BussinessSkill not implement yet.")
	}

; <========================  偷猎  ===========================>

	Hunter(islieshou) ; 1 will from lieshou, 0 or others will from blacklist
	{	
		LogtoFile("QH Hunter not implement yet.")
	}

}