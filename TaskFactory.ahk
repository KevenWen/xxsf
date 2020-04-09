#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#Persistent
#SingleInstance force
#Include 4399UserTask.ahk

;ResizeWindow()
; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper

CoordMode, Pixel, window  
CoordMode, Mouse, window

class test{
    __New(fname){
        this.filename := fname        
       ; this.logfile := fname . ".txt"
        global logfile := fname . ".txt"
        msgbox % "creating " . this.logfile
    }


    showname(){
        return this.filename
    }

    Activedic(){
        WinActivate, % this.filename
        sleep 200
        click 272, 157
        sleep 200
        Send, % texts . this.filename
        sleep 200
    }

    __Delete(){
        MsgBox, % "deleting " . logfile
    }
}

a := new test("Untitled - Notepad")
b := new test("ahk_exe YoudaoDict.exe")


a.Activedic()
sleep 1000
b.Activedic()

;msgbox, % a.showname()

b := ""
msgbox, % a.showname()
msgbox, % b.showname()
;a := ""

;supper := new 4399UserTask(27,"supper")


;Supper.OpenBusSkill()
;supper.GetLand()

;sf01.GetGiftScreen()
;sf01.GetCard(10)
;sf01.GetGiftScreen()
;sf01.Close4399Game()
;sf01.Destroy

ExitApp

; 18-xhhz, 19-01, 20-02,21-03, 22-04,23-05,35-06, 24-yun, 25-long,26-hou, 27-supper, order by money count
^Numpad1::     ;02/song
    run %4399GamePath% -action:opengame -gid:1 -gaid:20
return
^Numpad2::     ;Long
    run %4399GamePath% -action:opengame -gid:1 -gaid:25 
return
^Numpad3::      ;Yun
    run %4399GamePath% -action:opengame -gid:1 -gaid:24 
return
^Numpad4::    ;88888
    run %4399GamePath% -action:opengame -gid:4 -gaid:30 
return
^Numpad5::    ;SF27_Supper
    run %4399GamePath% -action:opengame -gid:1 -gaid:27 
return

^Numpad6::     ;06
    run %4399GamePath% -action:opengame -gid:1 -gaid:35 
    ;run %LDGamePath% launchex --index 0 --packagename "com.wydsf2.ewan" 
return
^Numpad0::     ;01
    run %4399GamePath% -action:opengame -gid:1 -gaid:19
return
^Numpad7::     ;03
    run %4399GamePath% -action:opengame -gid:1 -gaid:21
return
^Numpad8::     ;04
    run %4399GamePath% -action:opengame -gid:1 -gaid:32 
return
^Numpad9::     ;05
    run %4399GamePath% -action:opengame -gid:1 -gaid:23 
return
^NumpadMult::     ;SF27_Hou
    run %4399GamePath% -action:opengame -gid:1 -gaid:26 
return
^NumpadDiv::    ;xhhz
    run %4399GamePath% -action:opengame -gid:1 -gaid:18
return

F10::Pause   ;pause the script
F11::ExitApp ;stop the script