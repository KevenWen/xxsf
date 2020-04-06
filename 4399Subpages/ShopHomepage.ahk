#SingleInstance, Force
#KeyHistory, 0

class ShopHomePage{   

    GetHomePage()
	{
		4399sfGame.closeAnySubWindow()
		click % HB[1]
		WaitPixelColor("0xFFFFFF",500, 200,2000)		;设置按钮白色
	}

    Save_Refresh4399()
    {
        this.GetHomePage()
        ;Setting Button
        WaitPixelColorAndClickThrowErr("0xFFFFFF",496, 198,3000)
        ;Setting page
        if !(WaitPixelColor("0xFFFFF3",405, 321,3000) = 0)
            throw "Setting page cannot found!"

        sleep 100
        click 404, 554 ;Save button
        sleep 1000
        4399sfGame.CloseAnySubWindow()
    }

	PlayZhuanPan(times = 6)
	{
		click 88, 896
		sleep 200
		WaitPixelColorAndClickThrowErr("0xD1762",505, 387,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times)
		{
			WaitPixelColorAndClickThrowErr("0xF4452A",395,746,2000) ;Ten Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",398, 267,5000) ;Finished once
			sleep 200
			click 398, 267
			sleep 300
			click 453, 388  ;Close double money window if any.
			sleep 200
			CaptureScreen()	
			n++  
		}
	}

	GetGiftScreen()
	{
		this.CloseAnySubWindow()
		sleep 100
		click 246, 196	;gift pack button
		sleep 300
		click 429, 577  ;card button
		sleep 500
		CaptureScreen()
		this.CloseAnySubWindow()
	}

	GetCard(times=150)
	{
		click 246, 196	;click 礼包 button
		sleep 500
		Loop %times%		;循环150次，可按需要调整
		{	
			WaitPixelColorAndClick("0x1657B0",288, 491,10,1000) ;click 每日分享 button
			WaitPixelColorAndClick("0xFCFEFE",347, 640,10,500)  ;click 立即分享 button
			if PixelColorExist("0x5BD157", 285, 530,10) 		;close "分享到" 提示
			{
				click 414, 432
				sleep 200
			}
			if !PixelColorExist("0x97E2E4",327, 633,10)	;close 分享成功或拼图窗口
				this.closeSpeSubWindow(1)
			sleep 200
		}
		this.CloseSpeSubWindow(30)	;关闭所有子窗口
	}


	GetDailayTaskMoney()
	{
		if PixelColorExist("0xD12A06",473, 308,20) ;每日任务,如偷满10次
		{
			Click 495, 315
			sleep 200
			Click 420, 420 ;Task 1
			sleep 50
			Click 420, 500 ;Task 2
			sleep 50		
			Click 420, 580 ;Task 3
			sleep 100
			Click 479, 344 ;Close Button
			sleep 200
		}
	}

    OpenTouLiePageFromBlackList(Num)
    {
        this.GetHomePage()
        WaitPixelColorAndClickThrowErr("0xD26D24",500, 250,2000) ;HaoYou button
        sleep 500
        WaitPixelColorAndClickThrowErr("0xFFFFFF",449, 776,2000) ;BlackList button
        sleep 1000

        if PixelColorExist("0xFBFBFB",459,399,100) ; Hongbao window or shangzhan window if exist.
            {
                click 459,399
                sleep 300
            }	

        ; Click corresponding people

        if Num=1
        { 
            WaitPixelColorAndClickThrowErr("0x6EEACE",455, 373,1000) ;Click people in the blacklist
            sleep 500	
            WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
            return 
        } 

        if Num=2
        {
            WaitPixelColorAndClickThrowErr("0x6EEACE",455, 440,1000)
            sleep 500	
            WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
            return 
        }

        if Num=3
        {
            WaitPixelColorAndClickThrowErr("0x6EEACE",455, 507,1000)
            sleep 500	
            WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
            sleep 100
            return 
        } 
        
        if Num=4
        {
            WaitPixelColorAndClickThrowErr("0x6EEACE",455, 575,1000)
            sleep 500	
            WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
            sleep 100
            return 
        } 		
        
        if Num=5 
        {
            WaitPixelColorAndClickThrowErr("0x6EEACE",455, 643,1000)
            sleep 500	
            WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
            sleep 100
            return 
        }

            if Num=6 
        {
            WaitPixelColorAndClickThrowErr("0x6EEACE",455, 708,1000)
            sleep 500	
            WaitPixelColorAndClickThrowErr("0x6DE9CF",204, 608,2000) ;TouLie Button	in People Page
            sleep 100
            return 
        }
    }

}