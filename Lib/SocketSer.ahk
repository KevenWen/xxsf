;Socket Server
#SingleInstance force
#include Socket.ahk
#Include Functions.ahk

myTcp := new SocketTCP()
myTcp.bind("10.154.10.6", 1377)
myTcp.listen()
myTcp.onAccept := Func("OnTCPAccept")
return

OnTCPAccept()
{
    global myTcp
    newTcp := myTcp.accept()
    rece := newTcp.recvText()
    if (rece = "song")
    {
        IniRead, _DC, % UserIni,song, DC,0
        IniRead, _RZ, % UserIni,song, RZ,0        
        newTcp.sendText("song," . _DC . "," . _RC)
    }    
    else if (rece = "yun")
    {
        IniRead, _DC, % UserIni,yun, DC,0
        IniRead, _RZ, % UserIni,yun, RZ,0        
        newTcp.sendText("yun," . _DC . "," . _RC) 
    }
    else if (rece = "long")
    {
        IniRead, _DC, % UserIni,long, DC,0
        IniRead, _RZ, % UserIni,long, RZ,0        
        newTcp.sendText("long," . _DC . "," . _RC)
    }
    return
}

F12::
    myTcp.disconnect()
    ExitApp
return