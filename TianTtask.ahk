#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SingleInstance force

DetectHiddenWindows, On
SetTitleMatchMode, 2

SetTimer, TaskTianTi, 300000
;SetTimer, TaskTianTi, 10000
Return

TaskTianTi:
   IfWinNotExist, 4399TouLie.ahk  
   {
      IfWinNotExist,ShangZhanReport.ahk
      {
         ;IfWinNotExist,RongZiTask.ahk
            runwait "QHTianTi.ahk"
      }  
         
   }      
Return

F12::Pause   ;pause the script