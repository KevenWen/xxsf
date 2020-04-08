#SingleInstance, Force
#KeyHistory, 0
/*
SetBatchLines, -1
ListLines, Off
SetTitleMatchMode, 2 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname
*/
class LandPage{    

	GetLandPage()
	{
		4399sfGame.closeAnySubWindow()
		click % HB[2]
		WaitPixelColor("0x706B59",398, 288,2000)		;升级button 旁边的灰色条	
	}

	GetLandPage2()
	{
		this.GetLandPage()
		WaitPixelColorAndClick("0xFFFFFF",284, 247,1000)	;地产投资白色点
		if !PixelColorExist("0xFFFEF5",421, 393,2000)		;白色总点击数框
        {
            WaitPixelColorAndClick("0xFFFFFF",284, 247,1000)	;click again just in case.
            WaitPixelColor("0xFFFEF5",421, 393,2000)
        }    
	}

    SuanKai()
    {
	    this.GetLandPage2()

        if !PixelColorExist("0x4BB2D9",318, 786,10) ;JBP not available
        {
            if PixelColorExist("0x81FBD6",398, 787,10) ; time tunnel available
            {
                click 398, 787
                sleep 200
                WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
                sleep 300
            }	
            Else
                throw "SuanKai():JBP not available!"
        }	

        if !PixelColorExist("0xE4E4E4",447, 756,10) 
            and PixelColorExist("0x4BB3D9",466, 786,10) 
            and !PixelColorExist("0xFFFDEF",447, 756,10) 
        {
            ;LogToFile("suankai done for 1,3")
            WaitPixelColorAndClick("0xDEF7EE",471, 737,500)  ; NiuShi button
            sleep 200
            WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
            sleep 300
        }

        sleep 200
        WaitPixelColorAndClickThrowErr("0xDEF7EE",317, 737,1500) ; JBP button
        sleep 200
        WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
        sleep 800
        ;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		

        /*  ;phy only
        click 458, 750
        sleep 500
        ;WaitPixelColorAndClickThrowErr("0xFBFBFB",481, 232,2000) ; close button for testing
        WaitPixelColorAndClickThrowErr("0x6BE8CF",445, 469,2000) ; Use button
        sleep 200
        click 298, 755
        sleep 500
        WaitPixelColorAndClickThrowErr("0x6BE8CF",445, 469,2000) ; Use button
        sleep 200
        Save_Refresh4399()
        */

        this.Save_Refresh4399()
    }

    DiCanJinzhu(num)
    {
        this.PrepareGameWindow()
        this.GetLandPage()        
        SendMode Event
        sleep 100
        Mousemove,510, 825
        send {LButton down}
        Mousemove,510, 95,10
        send {LButton up}
        click 510, 825
        sleep 200
        CaptureScreen()
        loop 25
        {
            4399sfGame.CloseAnySubWindow()
            ImageSearch, Px, Py, 113, 429, 504, 827, % A_ScriptDir . "\\blockofyellow.bmp"
            if (ErrorLevel = 2)  ;Execption when conduct the search
                throw "ImageSearch not work, please check." 
            else if (ErrorLevel = 1) ;Image not found 
            {
                sleep 500
                Mousemove,510, 825
                send {LButton down}
                Mousemove,510, 345,15
                send {LButton up}
                click 510, 825			
                sleep 200
            }
            else if (ErrorLevel = 0) and !PixelColorExist("0x706B59",424, 286,10) ;Image found and not on the first line
            {
                LogToFile("Image found when loop times: " . A_Index)
                CaptureScreen()	
                loop 2
                {
                    try
                    {
                        click %Px%, %Py%
                        sleep 200
                        if PixelColorExist("0xFFFEF5",185, 469,1000) 
                        {
                            Mousemove,255, 460
                            click, % round(num/2)+2 ;金币注经营资源
                            sleep 100
                            Mousemove,255, 520
                            click, % round(num/2)-3 ;金币注管理资源
                            sleep 100
                            Mousemove,414, 520
                            click, 6				;资源卡注管理资源
                            sleep 100
                            Mousemove,330,580
                            click, 5				;5份钻石注决策资源
                            CaptureScreen()	
                            sleep 100
                            click 361, 704			;确认注入
                            sleep 100
                            if PixelColorExist("0xFBFBFB",462, 396,500) ;确认注入提示框
                            {
                                click 302, 593 ;点击确定
                                sleep 300
                                if PixelColorExist("0x5A7965",329, 284,10)
                                    throw "Exception while DiCcanJinzhu1."
                                
                                WaitPixelColorAndClick("0xFBFBFB",479, 192,200)
                                CaptureScreen()	
                            }	
                            else
                                throw "Exception while DiCcanJinzhu2."
                        }
                        break					
                    }
                    Catch e
                    {
                        CaptureScreen()
                        4399sfGame.CloseAnySubWindow()
                        LogToFile("Land business meet an exception: " e)
                    }					
                }
                LogToFile("Land business done, num is " . num)
                break
            }
            sleep 200        
        }
        SendMode Input			
    }
}