#NoEnv
#SingleInstance, Force
#KeyHistory, 0

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

	GetCaiTuanMoney()
	{
		this.GetCaiTuanPage()
		WaitPixelColorAndClickThrowErr("0x3E515C",307, 879,2000) ;cai tuan button
		sleep 200
		WaitPixelColorAndClickThrowErr("0xFFDFAB",457, 234,2000) ;Shou Ru button	
		sleep 100
	}
}
