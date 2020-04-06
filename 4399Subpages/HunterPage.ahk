#NoEnv
#SingleInstance, Force
#KeyHistory, 0

class HunterPage{    

	GetHunterPage()
	{
		4399sfGame.closeAnySubWindow()
		click % HB[3]
		WaitPixelColor("0xFFFEF5",494, 703,2000)			;The white in Hunt failure count area
	}

    SelectPeopleAndstolen(fromList)
    {
        n :=1
        SuccessCount :=1
        while (n<7 and SuccessCount<6)
        {
            ;CloseAnySubWindow()
            sleeptime := n=1? 500:600
            sleep %sleeptime%

            (fromList = "lieshou")?(this.OpenTouLiePage(n)):(4399sfGame.ShopHomePage.OpenTouLiePageFromBlackList(n))

            CaptureScreen()	
            try
            {
                sleep 500
                this.TouLieOpration()	
                SuccessCount++	
                LogToFile("Hunter one`n")
            }
            catch e ;Ignore any error during one operation and go ahead to next one.
            {
                LogToFile("Exception within ToulieOpreation.")		
                LogToFile(e)		
            }	
            Finally 
            {
                CaptureScreen()	
                n++
            }
        }  
    }

    OpenTouLiePage(Num)
    {
        this.GetHunterPage()
        ;click 501,252
        WaitPixelColorAndClickThrowErr("0x2E3030",212, 879,2000) ;LieShou button
        sleep 500

        if PixelColorExist("0xF39181",126, 187,100) ;Return button if exist.
            {
                click 126, 187
                sleep 500
            }
        
        if PixelColorExist("0xFBFBFB",459,399,100) ; Houbao window or shangzhan window if exist.
            {
                click 459,399
                sleep 500
            }	
        ; Click corresponding people 
        click % (Num=1)?(LieshoucoList[1])
        :((Num=2)?(LieshoucoList[2])
        :((Num=3)?(LieshoucoList[3])
        :((Num=4)?(LieshoucoList[4])
        :((Num=5)?(LieshoucoList[5])
        :(LieshoucoList[6])))))
        Return
    }

    TouLieOpration()
    {
        4399sfGame.CloseAnySubWindow()
        if !PixelColorExist("0x74BDFA",431, 530,2000)
            throw "Not able to open people Stolen page!"

        if PixelColorExist("0xFFFEF5",262, 617,10) and PixelColorExist("0xFFFFFF",318, 784,10)
        {
            click 293, 805 ;start TouLie Button		
            sleep 1000

            if PixelColorExist("0xFBFBFB",463, 395,10) ; >5 times, the window ask for 500 money.
            {
                mousemove 462, 391
                click
                throw ">5 times, the window ask for 500 money."
            }
            WaitPixelColorAndClickThrowErr("0x2A1E17",228, 744,3000)
            Loop
            {
                if PixelColorExist("0xFEC120",440, 742,1) ;进度条到了		
                    break
                if PixelColorExist("0xE2413E",334, 611,1) ;OK button
                    break
                if A_Index > 10  ;Total 20 loop times
                    break
                sleep 30	
                Mousemove 293, 805
                click 20
            }
            sleep 200	 
            click 461, 321 ; Close the get card page
        }
        Else
        {
            throw "Already stoled in hours or the target is full!"
        }
    }
}
