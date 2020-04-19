
class CaiTuanPage{    

	GetCaiTuanPage()
	{
		loop{
			if A_Index > 2
				throw "Not able to GetCaiTuanPage.PixelColorExist 0xFFFEF5 497 333 not exist."
			4399sfGame.closeAnySubWindow()
			click % HB[1]
			sleep 100
			click % HB[4]
			sleep 200
			if PixelColorExist("0xFFFEF5",497, 333,2000)			;白色公关资金框
				Break
		}	
	}

	GetTianTiPage()
	{
		This.GetCaiTuanPage()
		click 121, 188
		WaitPixelColor("0xFFFEF5",134, 333,2000)  ;白色股份资金框
	}

	GetCaiTuanMoney()
	{
		this.GetCaiTuanPage()
		WaitPixelColorAndClickThrowErr("0x3E515C",307, 879,2000) ;cai tuan button
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFDFAB",457, 234,2000) ;Shou Ru button	
		sleep 100
	}

	TTOperation()
	{
		this.GetTianTiPage()	
		if PixelColorExist("0xF9FCFA",440, 450,200) ; Check if the 0 exist, if yes, still waiting for money ready!
			return

		WaitPixelColorAndClickThrowErr("0xFEFDFB",479, 279,2000) ; start button
		sleep 100
		if !PixelColorExist("0xFFFEF5",243, 830, 1000) ; if the color is unexpected, close the game and exit. so next time it will fix itself. 
		{
			click 470,440  ;in case not enough money allocated.
			sleep 300
			Throw "Color 0xFFFEF5,243, 830 unexpected.."
		}
		sleep 100
		click 234, 836  ;add one for 1
		PixelColorExist("0xFFF8CE",167, 843,40000)

		if PixelColorExist("0xDC3131",262, 807,100)
			LogtoFile("Tian Ti Failed..")
		Else if PixelColorExist("0x619C31",262, 807,100)
			LogtoFile("Tian Ti Succeed..")
		else 
			LogtoFile("Tian Ti result unknown..")

		CaptureScreen()
		sleep 500		
		click 294, 813   	;close result page, return 
		sleep 1000
		click 470,440		;last time allocated money button
		sleep 200
	}
}

