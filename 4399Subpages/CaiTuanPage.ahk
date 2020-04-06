#NoEnv
#SingleInstance, Force
#KeyHistory, 0

class CaiTuanPage{    

	GetCaiTuanPage()
	{
		4399sfGame.closeAnySubWindow()
		click % HB[4]
		WaitPixelColor("0xFFFEF5",497, 333,2000)			;白色公关资金框
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
