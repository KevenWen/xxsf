#SingleInstance, Force
#Include, Functions.ahk
SetBatchLines, -1

class RDPGame ;extends sfGame 
{
	__New(isclose=1)
	{
		this.isclosed := isclose
		LogToFile("")
		LogToFile("Log started for ahk_exe mstsc.exe.")

		IfWinExist ahk_exe mstsc.exe
		{
			WinActivate ahk_exe mstsc.exe
			Winmove,ahk_exe mstsc.exe,,585,111,1120,872
			LogToFile("Found existing RDP window.")
			sleep 100
		}
		Else
		{
			run "C:\Windows\system32\mstsc.exe" "C:\Users\keven\Documents\phy.rdp"
			LogToFile("Started a new RDP window.")			
			sleep 10000
			Winmove,ahk_exe mstsc.exe,,585,111,1120,872
			sleep 200			
		}

		CaptureScreen()
	}

	__Delete()
	{
		if this.isclosed
			WinClose, ahk_exe mstsc.exe

		LogToFile("Log end for RDPGame.")
	}

	FixRDPConn()
	{
		WinActivate ahk_exe mstsc.exe
		;WinSet, AlwaysOnTop, On, ahk_exe mstsc.exe
		;The active window "CompanyPhy - 10.154.10.6 - Remote Desktop Connection" is 1120 wide, 872 tall, and positioned at 585,111.
		Winmove,ahk_exe mstsc.exe,,585,111,1120,872
		sleep 200

		Loop
		{
			if A_Index > 2
				Return 0

			if PixelColorExist("0xFFFCF8",1060, 500,200) ;the white color in the left pop up OK window
				Break
			Else
			{
				WinClose,ahk_exe mstsc.exe	
				sleep 200
				run "C:\Windows\system32\mstsc.exe" "C:\Users\keven\Documents\phy.rdp"
				sleep 10000	
			}
		}
		Return 1
	}

	RDP_0()
	{
		LogToFile("Start to run RDP_0().")	
		IfWinExist ahk_exe mstsc.exe
		{
			WinActivate ahk_exe mstsc.exe
			sleep 100
			CaptureScreen()	
			sleep 100

			;LDplayer
			click, % Arrayphy["btn1"]
			sleep, % s["short"]
			click, % Arrayphy["btn1"]
			sleep, % s["short"]
			sendinput {D}
			LogToFile("Clicked btn1 and send D.")

			;Supper
			if PixelColorExist("0xFFFFF3",798,633,10)
			{
				click % Arrayphy["btn_2"]
				sleep, % s["short"]
			}    
			click % Arrayphy["btn2"]
			sleep, % s["short"]
			click % Arrayphy["btn2"]
			sleep, % s["short"]
			LogToFile("Clicked btn2.")

			;Long
			if PixelColorExist("0xFFFFF3",522,633,10)
			{
				click % Arrayphy["btn_3"]
				sleep, % s["short"]
			}    
			click % Arrayphy["btn3"]
			sleep, % s["short"]
			click % Arrayphy["btn3"]
			sleep, % s["short"]
			LogToFile("Clicked btn3.")

			;Song
			if PixelColorExist("0xFFFFF3",253,633,10)
			{
				click % Arrayphy["btn_4"]
				sleep, % s["short"]
			}
			click % Arrayphy["btn4"]
			sleep, % s["short"]
			click % Arrayphy["btn4"]
			sleep, % s["short"]
			LogToFile("Clicked btn4.")

			CaptureScreen()	
		}
		Else
			LogToFile("Not found a RDP window")	
	}

	RDP_2()
	{
		LogToFile("Start to run RDP_2().")	
		IfWinExist ahk_exe mstsc.exe
		{
			WinActivate ahk_exe mstsc.exe
			;WinSet, AlwaysOnTop, On, ahk_exe mstsc.exe
			sleep 1000
			CaptureScreen()	
			sleep 200

			;LDplayer
			click, % Arrayphy["btn1"]
			sleep, % s["short"]
			click, % Arrayphy["btn1"]
			sleep, % s["short"]
			sendinput {Y}
			LogToFile("Clicked btn1 and send Y.")


			;Supper
			if PixelColorExist("0xFFFFF3",798,633,10)
			{
				click % Arrayphy["btn_2"]
				sleep, % s["short"]
			}    
			click % Arrayphy["btn2"]
			sleep, % s["short"]
			click % Arrayphy["btn2"]
			sleep, % s["short"]
			LogToFile("Clicked btn2.")


			;Long
			if PixelColorExist("0xFFFFF3",522,633,10)
			{
				click % Arrayphy["btn_3"]
				sleep, % s["short"]
			}    
			click % Arrayphy["btn3"]
			sleep, % s["short"]
			click % Arrayphy["btn3"]
			sleep, % s["short"]
			LogToFile("Clicked btn3.")


			;Song
			if PixelColorExist("0xFFFFF3",253,633,10)
			{
				click % Arrayphy["btn_4"]
				sleep, % s["short"]
			}
			click % Arrayphy["btn4"]
			sleep, % s["short"]
			click % Arrayphy["btn4"]
			sleep, % s["short"]
			LogToFile("Clicked btn4.")
			
			CaptureScreen()
		}
		Else
			LogToFile("Not found a RDP window")	
	}

	RDP_N()
	{
		LogToFile("Start to run RDP_N().")	
		IfWinExist ahk_exe mstsc.exe
		{
			WinActivate ahk_exe mstsc.exe
			sleep, % s["short"]
			CaptureScreen()	
			sleep, % s["short"]

			;LDplayer
			click, % Arrayphy["btn1"]
			sleep, % s["short"]
			click, % Arrayphy["btn1"]
			sleep, % s["short"]    
			sendinput {D}
			sleep, % s["mid"]  			
			LogToFile("Clicked btn1 and send D.")
			CaptureScreen()			
		} 
		Else
			LogToFile("Not found a RDP window")	
	}

	SendCommand(cmd)
	{
		IfWinExist ahk_exe mstsc.exe
		{
			WinActivate ahk_exe mstsc.exe
			sleep, % s["short"]
			sendinput {%cmd%}
		}	
	}
}
     