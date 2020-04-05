#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#SingleInstance force
#Include 4399sfGame.ahk

supper := new 4399sfGame(27,"supper")
loop 2
{
    if supper.isBussinessSkillLight()
	{
		CaptureScreen()
		LogtoFile("BussinessSkillLight still light.")		
		click % supper.SB[2]
		sleep 1000		
	}	
	Else
    {
		CaptureScreen()
		LogtoFile("Find BussinessSkill not opened, going to open it.")				
		supper.OpenSJ()
		CaptureScreen()
		LogtoFile("After open BussinessSkill.")		
    }
	sleep 1000
}
ExitApp

F10::Pause   ;pause the script
F11::ExitApp ;stop the script