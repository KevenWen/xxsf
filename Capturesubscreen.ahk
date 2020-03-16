#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#NoTrayIcon				; No system tray icon
#SingleInstance force
#Persistent

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
p_DesiredColor := "0xF9FFF4"
p_DesiredColors := "0xF9FFF5"

F7::
 loop 42
    {
    if PixelColorExist("0xFFFFFF",1150, 821,10) 
        Gosub, small
    else
        Gosub, big
    }
return

big:
    dot := 0
    PixelGetColor, l_OutputColor, 949, 778, RGB	
    If ( l_OutputColor = p_DesiredColor )
        dot := 1

    MouseMove,613, 257
    send {Ctrl down}
    send {Alt down}
    send {a}
    sleep 50
    send {Alt up}
    send {Ctrl up}
    sleep 50
    send {LButton down}
    MouseMove, 1157, 347
    send {LButton up}
    sleep 100
    If ( dot = 1 )
    {
        click, 866, 369
        sleep 100
        click 623, 268
        sleep 100
    }

    send ^{s}
    sleep 300
    send {Enter}
    sleep 300
    click 1157, 347
    sleep 200
    send {Right}
    sleep 500
return

small:
    dots := 0
    PixelGetColor, l_OutputColor, 994, 768, RGB	
    If ( l_OutputColor = p_DesiredColors )
        dots := 1

    MouseMove,656, 228
    send {Ctrl down}
    send {Alt down}
    send {a}
    sleep 50
    send {Alt up}
    send {Ctrl up}
    sleep 50
    send {LButton down}
    MouseMove, 1114, 320
    send {LButton up}
    sleep 100    
    If ( dots = 1 )
    {
        click, 807, 338
        sleep 100
        click 668, 242
        sleep 100
    }
    send ^{s}
    sleep 200
    send {Enter}
    sleep 300
    click 1114, 320
    sleep 200
    send {Right}
    sleep 300
return


PixelColorExist(p_DesiredColor,p_PosX,p_PosY,p_TimeOut=0) 
{
    l_Start := A_TickCount
    Loop {
        PixelGetColor, l_OutputColor, %p_PosX%, %p_PosY%, RGB	
		If ( ErrorLevel )
            Return 0
        If ( l_OutputColor = p_DesiredColor )
            Return 1
        If ( p_TimeOut ) && ( A_TickCount - l_Start >= p_TimeOut)
            Return 0
    }
}


F10::Pause   ;pause the script
F11::ExitApp ;stop the script