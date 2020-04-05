#SingleInstance, Force
SetBatchLines, -1

class RDPGame extends sfGame 
{
	__New()
	{
		global rdppw = ""
		global rdpdomain = ""

		IniRead, rdppw, config.ini, passwords, RDPpw
		IniRead, rdpdomain, config.ini, passwords, RDPdm
		IniRead, logPath, config.ini, path, logPath

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