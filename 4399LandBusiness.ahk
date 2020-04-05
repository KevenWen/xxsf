#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#SingleInstance force
#Include 4399sfGame.ahk

supper := new 4399sfGame(27,"supper")
Try 
{
    supper.DiCanJinzhu(40)
}
Catch e
    MsgBox, % e


supper := ""
ExitApp

F10::Pause   ;pause the script
F11::ExitApp ;stop the script