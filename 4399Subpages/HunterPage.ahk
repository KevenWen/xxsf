
class HunterPage{    

	GetHunterPage()
	{
		loop{
			if A_Index > 2
				throw "Not able to GetHunterPage, PixelColorExist 0xFFFEF5 494 703 not exist."
            4399sfGame.closeAnySubWindow()
            click % HB[1]
            sleep 200
            click % HB[3]
            sleep 100            		
            if PixelColorExist("0xFFFEF5",494, 703,2000)			;The white in Hunt failure count area
                break
        }
    }

    SelectPeopleAndstolen(islieshou)
    {
        n :=1
        SuccessCount :=1
        CaptureScreen()
        while (n<7 and SuccessCount<6)
        {
            try
            {
                sleep 200
                (islieshou = 1)?(this.OpenTouLiePage(n)):(4399sfGame.ShopHomePage.OpenTouLiePageFromBlackList(n))

                this.TouLieOpration()
                LogToFile("Huntered num: " . n . " SuccessCount: " . SuccessCount)	
                SuccessCount++
            }
            catch e ;Ignore any error during one operation and go ahead to next one.
            {
                CaptureScreen()
                LogToFile("Exception within ToulieOpreation:" . e)                	
            }
            Finally 
            {
                n++
            }
        }
        sleep 500  
    }

    OpenTouLiePage(Num)
    {
        if PixelColorExist("0xF39181",126, 187,100) ;Return button if exist.
        {
            click 126, 187
            sleep 500
        }
        Else
            this.GetHunterPage()
    
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
            click 293, 805,2 ;start TouLie Button	    	
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
                if PixelColorExist("0xFEC120",450, 742,10) ;进度条到了		
                    break
                if PixelColorExist("0xE2413E",334, 611,10) ;OK button
                    break
                if A_Index > 10  ;Total 20 loop times
                    break
                sleep 30	
                click, 293, 805,20
            }
        }
        Else
            throw "Already stoled in hours or the target is full!"
    }

    GetResult()
    {
        this.GetHunterPage()
        WaitPixelColorAndClick("0xFFC7BB",166, 805,1000)
        CaptureScreen()
        sleep 200
        WaitPixelColorAndClick("0xFBFBFB",492, 217,1000)
        LogToFile("Huntered GetResult done.")	
    }
}
