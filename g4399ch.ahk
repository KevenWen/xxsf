#include gamesf.ahk
#include .\Lib\Chrome.ahk

class 4399ch extends gamesf 
{

; <===================================  Sub Classes for each page  ================================>
/*
	#Include, .\4399Subpages\Shophomepage.ahk
	#Include, .\4399Subpages\Landpage.ahk
	#Include, .\4399Subpages\HunterPage.ahk
	#Include, .\4399Subpages\CaiTuanPage.ahk
	#Include, .\4399Subpages\GroupPage.ahk
	#Include, .\4399Subpages\OrderPage.ahk
*/
; <==================================  Properties  ====================================>


; <================================  Constructure functions  ================================>

	__New(uname,isclose=1)
	{
		this.winName := uname
		this.isclosed := isclose

		try
		{
			IfWinExist, ahk_exe chrome.exe
			{
				WinActivate, ahk_exe chrome.exe			
				WinGetPos, X, Y, W, H, ahk_exe chrome.exe	
				if not (W=609 and H=1006)
					Winmove,ahk_exe chrome.exe,,829,12,609,1006
				LogToFile("Find existing chrome window.")
				sleep 200
			}
			else
			{
				LogToFile("Going to open game.")
				;this.Launch4399Game(seqid,windowname)
				LogToFile("Game opened.")
			}

			if (Chromes := Chrome.FindInstances())
				ChromeInst := {"base": Chrome, "DebugPort": Chromes.MinIndex()}
			page := ChromeInst.GetPageByURL(uname,"contains")
			if !IsObject(page)
			{
				LogToFile("The page in new doesnot find! ")
				return
			}
			page.call("Page.bringToFront")
			sleep 100
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
			if (Chromes := Chrome.FindInstances())
				ChromeInst := {"base": Chrome, "DebugPort": Chromes.MinIndex()}
			page := ChromeInst.GetPageByURL(this.winName,"contains")
			if !IsObject(page)
			{
				LogToFile("The page in delete() not find! ")
				return
			}
			page.call("Page.close")
			sleep 200
		}
		LogToFile("Log Ended for: " . this.winName . ".`n")
	}
	
; <==================================  Command Tasks  ====================================>

	
; <========================  地产入驻  ===========================>
	


; <========================  商会相关  ===========================>
isRongZiprepared()
{
	return 0
}

RongZiOKpublic()
{
	ToolTip, "RongZiOKPublicClick",825,25
	sleep 5000
}
PreRongZi(which)
{}
RongZiOKinternal()
{
	ToolTip, "RongZiOKinternal",825,25
	sleep 5000	
}


; <========================  偷猎  ===========================>



; <==================================  Command functionalities  ====================================>
	PrepareGameWindow(name)
	{	
		WinClose Cisco AnyConnect				;The VPN windows may exist					
		WinClose, IrfanView						;The capture screen error windows may exist	
/*
		WinGetActiveTitle, CurTitle
		if (CurTitle = name)
			Return
*/
		LogToFile("")
		LogToFile("Log switch for: " . name)
		
		IfWinExist,ahk_exe chrome.exe
		{
			WinActivate, ahk_exe chrome.exe		

			if (Chromes := Chrome.FindInstances())
				ChromeInst := {"base": Chrome, "DebugPort": Chromes.MinIndex()}
			page := ChromeInst.GetPageByURL(name,"contains")
			if !IsObject(page)
			{
				LogToFile("The page doesnot find! ")
				throw "Chrome page not exist: " . name
			}

			page.call("Page.bringToFront")
			sleep 200	
		}
		Else
			throw "Window name not exist: " . name
	}

	Close4399Game(name)
	{
		if (Chromes := Chrome.FindInstances())
			ChromeInst := {"base": Chrome, "DebugPort": Chromes.MinIndex()}
		page := ChromeInst.GetPageByURL(name,"contains")
		if !IsObject(page)
		{
			LogToFile("The page doesnot find for: " . name)
			return
		}

		page.call("Page.bringToFront")
		sleep 200
	}

	Launch4399Game(Sequ,windowname)
	{
		; not implement yet
	}

	Mid4399Game()
	{
		; not implement yet
	}


}

