#NoEnv
SetBatchLines, -1

#Include Socket.ahk
#Include Jxon.ahk
#Include RemoteObj.ahk

Remote := new RemoteObjClient(["10.154.10.6", 1337])

if !Remote.Index
	Remote.Index := 1

msgbox % Remote.ZhuZi("song",2,0)
;Remote.AddButton(Remote.Index++ ". Run Notepad", "Run", "notepad")
;Remote.AddButton(Remote.Index++ ". Show MsgBox", "MsgBox", "Hello!")
ExitApp
return
