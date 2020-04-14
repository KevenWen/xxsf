#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force
#Include 4399UserTask.ahk


SetTimer, Task202004, 1000  ;run every 1 secs
Return

Task202004:

    FormatTime, TimeToMeet,,HHmmss

    ;TimeToMeet = 235959

    If (TimeToMeet = 235959) ; Bussniss war started
    {        
        sleep 30000
        WinClose, yun
        winclose, supper
        WinClose, long
        ;winclose, hou
        runwait "C:\ChangZhi\LDPlayer\dnconsole.exe" "quitall"
        WinClose 360游戏大厅
        ExitApp
    }

return

^NumpadDot::

   For index,value in  ["supper","yun","long"]
   {
       %value% := new 4399UserTask(value)
       %value%.PrepareRongZi(index)
   }

return

^Numpad9::

   For index,value in  ["supper"]
   {
       %value% := new 4399UserTask(value)
       %value%.ZhunPan(2)
   }

return

/*
; 8-yun, 7-long, 9-hou, 10-supper, 2-02/song	
^NumpadAdd::      ;Yun
    sleep 1000
    run "C:\ChangZhi\LDPlayer\dnconsole.exe" launchex --index 0 --packagename "com.wydsf2.ewan"    
return

*/
;https://www.autohotkey.com/boards/viewtopic.php?f=7&t=41332

