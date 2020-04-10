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
        click % HB[1]
        sleep 200
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

        if !PixelColorExist("0x4BB2D9",318, 786,10) and !PixelColorExist("0x4AB2D9",318, 786,10) ;JBP not available
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

                click %Px%, %Py%
                sleep 200                        
                if PixelColorExist("0xFFFEF5",169, 472,1000)    ;经营资源输入框存在
                and PixelColorExist("0x5A7965",331, 353,10)     ;且上面图片显示是闲置土地
                {
                    Mousemove,255, 460
                    click, % round(num/2)+2 ;金币注经营资源
                    sleep 100
                    Mousemove,255, 520
                    click, % round(num/2)-3 ;金币注管理资源
                    sleep 100
                    Mousemove,414, 520
                    click, 3				;资源卡注管理资源
                    sleep 100
                    Mousemove,330,580
                    click, 3				;5份钻石注决策资源
                    CaptureScreen()	
                    sleep 100
                    click 361, 704			;确认注入
                    sleep 100
                    if PixelColorExist("0xFBFBFB",462, 396,500)     ;确定提示框存在
                    and PixelColorExist("0x909090",187, 363,10)     ;没有金钱不够提示                      
                    {
                        click 302, 593 ;点击确定
                        sleep 500
                        ;if PixelColorExist("0x5A7965",329, 284,10)  ; Very dengrous at doing this!
                        ;    throw "Exception while DiCcanJinzhu1, still show geen after click one time."
                        
                        WaitPixelColorAndClick("0xFBFBFB",479, 192,1000)
                        CaptureScreen()
                        LogToFile("Land business done, num is " . num)
                    }	
                    else
                    {
                        CaptureScreen()
                        LogToFile("Exception while DiCcanJinzhu2: 0xFBFBFB or 0x909090") 
                    }
                }
                else
                {
                    LogToFile("0xFFFEF5 and 0x5A7965 exception.")
                    CaptureScreen()
                }
            
                Break    
            }  
        }
        SendMode Input			
    }


}