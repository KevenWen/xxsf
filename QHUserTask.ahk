#SingleInstance, Force
SetBatchLines, -1
#Include, QHsfGame.ahk

class QHUser extends QHsfGame
{

; <==================================  Properties  ====================================>

RZ[]{
	get{
		IniRead, value,% UserIni,% this.winName,RZ,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni,% this.winName,RZ
		IniWrite, % A_Min . ":" . A_Sec, % UserIni,% this.winName,Rztime		
	}
}

DC[]{
	get{
		IniRead, value, % UserIni,% this.winName,DC,0
		return %value%
	}

	set{
		IniWrite, % value, % UserIni,% this.winName,DC
		IniWrite, % A_Min . ":" . A_Sec, % UserIni,% this.winName,Dctime
	}
}
; <================================  Constructure functions  ================================>

	__New(windowname,isclose=1)
	{
		LogToFile("`nLog started for QH user: " . windowname)
		this.winName := windowname
		this.isclosed := isclose
		seqid := idtable[windowname]

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
				Winmove,%windowname%,,933,19,600,959
				sleep, % s["short"]
				LogToFile("Find existing window named: " . windowname)
			}
			else
			{
				LogToFile("QH user not exist, terminated. ")
				Return
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
			WinClose, 360游戏大厅
		}
		else
			WinMinimize, % this.winName
		LogToFile("Log Ended. `n")
    }
	
; <==================================  Command Tasks  ====================================>

; <========================  地产入驻  ===========================>
	
	GetLand()
	{
		try{
		this.PrepareGameWindow(this.winName)	
		this.DiCanJinzhu()
		this.DC := 1		
		LogtoFile("QH GetLand() done. ")
		}
		Catch e
		{
		LogtoFile("QH GetLand() get exception: " . e)
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
			this.PrepareGameWindow(this.winName)
			this.GroupZhuZi(which)
			LogToFile("this.GroupZhuZi done.")
		} Catch e{
			LogToFile("this.GroupZhuZi get exception: " . e)
		}
	}

	RongZi(which=5)
	{
		try{
			this.PrepareGameWindow(this.winName)

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
		}
	}

	PrepareRongZi(which)
	{
		try{
		this.PrepareGameWindow(this.winName)
		this.CheZi()
		this.PreRongZi(which)
		}
		Catch e{
		LogToFile("this.PreRongZi() get exception: " . e)
		}
	}

; <========================  转盘  ===========================>

	Zhuanpan(times,buytimeplus = 0){
		try{
		this.PrepareGameWindow(this.winName)
		this.Suankai()
		LogToFile("Suankai() done for QH user.")
		}
		Catch e
		{
		LogToFile("Suankai() get exception: " . e)
		}

		try{	
		this.PlayZhuanPan(times,buytimeplus)
		LogToFile("PlayZhuanPan done!")		
		}
		Catch e
		{
		LogToFile("PlayZhuanPan() get exception: " . e)
		}		
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

	TianTi(Times)
	{
		try{
		LogtoFile("Start QH TianTi task.")
		this.PrepareGameWindow(this.winName)
		this.TianTiOpration(Times)
		LogtoFile("QH TianTi task done.")		
		}
		Catch e{
		LogToFile("TianTi task get exception: " . e)
		}
	}

}