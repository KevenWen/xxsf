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

ExitApp

F10::Pause   ;pause the script
F11::ExitApp ;stop the script