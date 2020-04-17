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
		loop{
            if A_Index > 2
                throw "Not able to GetLandPage."
            4399sfGame.closeAnySubWindow()
            click % HB[1]
            sleep 200
            click % HB[2]
            sleep 200
            if PixelColorExist("0x9E9E9E",72, 797,4000)		;No5 左边的灰色带
                Break
        }    
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

        if !PixelColorExist("0x4BB2D9",318, 786,10) ;JBP not available home
        and !PixelColorExist("0x4AB2D9",318, 786,10) ;JBP not available phy
        and !PixelColorExist("0x4AB1D8",318, 786,10)  ;JBP not available remote
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
            sleep 100
            WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
        }

        sleep 200
        WaitPixelColorAndClickThrowErr("0xDEF7EE",317, 737,1500) ; JBP button
        sleep 200
        WaitPixelColorAndClickThrowErr("0x6CE8D0",445, 469,2000) ; Use button
        sleep 500
        ;if !(WaitPixelColorAndClick("0xDEF7EE",471, 737,500)) or !(WaitPixelColorAndClick("0xDEF7EE",317, 737,500))		

        this.Save_Refresh4399()
    }

    DiCanJinzhu(num)
    {
        this.GetLandPage()        
        SendMode Event
        sleep 300
        Mousemove,510, 825
        send {LButton down}
        Mousemove,510, 200,10
        send {LButton up}
        click 510, 825
        sleep 200
        CaptureScreen()
        loop
        {
			if A_index > 15
				throw "DicanJinzhu loop more than 15 times still not get a free land."

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
                ;MouseMove, %Px%, %Py%
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
                    click,414, 520, 2				;2资源卡注管理资源
                    sleep 100
                    click,330,580, 3				;3份钻石注决策资源
                    CaptureScreen()	
                    sleep 300
                    if !PixelColorExist("0xFEEDC7",122, 389,10) and !PixelColorExist("0xFEEDC7",466, 389,10) ;左右两边都没有显示金钱不够提示
                        throw "Not enough money warning show!"

                    click 361, 704			;确认注入
                    sleep 100
                    if PixelColorExist("0xFBFBFB",462, 396,3000)     ;确定提示框存在              
                    {
                        click 302, 593      ;点击确定
                        CaptureScreen()      
                        WaitPixelColorAndClick("0xFBFBFB",479, 192,1000)
                    }	
                    else
                    {
                        CaptureScreen()
                        LogToFile("Exception while DiCcanJinzhu2: not found the OK button") 
                    }
                }
                else
                {
                    LogToFile("0xFFFEF5 and 0x5A7965 exception.")
                    CaptureScreen()
                }

                if !PixelColorExist("0xF2B21B",Px, Py,200)  ;double check 
                {
                    CaptureScreen()
                    LogToFile("Land business done, num is " . num)
                    Break  
                }
                      
            }  
        }
        SendMode Input			
    }


}