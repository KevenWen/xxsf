
class ShopHomePage{   

    GetHomePage()
	{
		loop{
			if A_Index > 2
				throw "Not able to ShopHomePage, PixelColorExist 0xFFFFFF 500 200 not exist."
            4399sfGame.closeAnySubWindow()
            click % HB[1]
            sleep 100
            if PixelColorExist("0xFFFFFF",500, 200,2000)		;设置按钮白色
                Break
        }
	}

    Save_Refresh4399()
    {
        this.GetHomePage()
        ;Setting Button
        WaitPixelColorAndClickThrowErr("0xFFFFFF",496, 198,3000)
        ;Setting page
        if !PixelColorExist("0xFFFFF3",405, 321,3000) ;off上面的空白
            throw "Setting page cannot found!"

        sleep 100
        click 404, 554 ;Save button
        sleep 1000
        4399sfGame.CloseAnySubWindow()
    }

	PlayZhuanPan(times = 6)
	{
        this.GetHomePage()
		WaitPixelColorAndClickThrowErr("0xD17622",505, 387,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times+1)
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
			n++  
		}
        sleep 1000
	}

	PlayZhuanPan1()
	{
        this.GetHomePage()
		WaitPixelColorAndClickThrowErr("0xD17622",505, 387,2000) ;ZhuanPan
		sleep 200
		n=1  ; 10 x n times
		while (n < times+1)
		{
			WaitPixelColorAndClickThrowErr("0xF4452A",163, 747,2000) ;One Times Button
			sleep 200
			LogToFile("one time..")	
			PixelColorExist("0xFBFBFB",398, 267,5000) ;Finished once
			sleep 200
			click 398, 267
			sleep 300
			click 453, 388  ;Close double money window if any.
			sleep 200
			n++  
		}
        sleep 1000
	}

    Reload()
    {
        this.GetHomePage()
        click 496, 200      ;settings button
        PixelColorExist("0xFFFFF3",150, 698,2000) ;Setting Window
        click 403, 640   ;switch server
        if !PixelColorExist("0xFFFEF5",371, 686,15000) ;Setting Window        
            throw, "Reload waiting 10 secs and timeout!"
        click 297, 771
        sleep 2000
        colcount := 0
        loop
        {				
            if PixelColorExist("0xCEC870",524, 91,10) ;the color in the top right corner
                colcount++
            else
                4399sfGame.CloseAnySubWindow()

            if colcount	> 1
                break
            if A_Index > 5
            {
                LogToFile("homepage not show expected and not sub window found!")
                throw "Reload waiting 5 times still not get the homepage!"
            }
            sleep 1000		
        }
    }

	GetGiftScreen()
	{
		4399sfGame.CloseAnySubWindow()
		sleep 100
		click 246, 196	;gift pack button
		sleep 300
		click 429, 577  ;card button
		sleep 500
		4399sfGame.CloseAnySubWindow()
	}

	GetCards(times=120)
	{
        c := 0
		Loop
		{	
            if PixelColorExist("0xFF5D5D",238, 206,10)     ;click 礼包 button
            {
                click 246, 196
                sleep 500
            }
			if PixelColorExist("0x1657B0",288, 491,10)     ;click 每日分享 button
            {
                click 288, 491
                sleep 100
            }
			if PixelColorExist("0x5BD157", 285, 531,10) 		;close "分享到" 提示
			{
				click 414, 432
				sleep 200
                c++
                LogToFile("find share to tip when loop: " . A_Index)
			}            
            if PixelColorExist("0xFFFFF3",126, 612,10)      ;click 立即分享 button
            {
                click 294, 651
                LogToFile("clicked share to at: " . A_Index . ", click pop window count: " . c)
                sleep 100
            }
			if !PixelColorExist("0xFFFFF3",306, 620,10)	;close 分享成功或拼图窗口
			{
	            4399sfGame.closeSpeSubWindow(1)
                c++
            }
            if (c > times or A_Index > 500)
            {
                LogToFile("loop times: " . A_Index . ", click pop window total count: " . c)
                break   
            }
		}
        sleep 5000
		4399sfGame.CloseSpeSubWindow(30)	;关闭所有子窗口
	}


	GetDailayTaskMoney()
	{
        this.GetHomePage()
		if !PixelColorExist("0xE4FCFF",479, 310,100) ;每日任务,如偷满10次
		{
		    LogToFile("Find a daily task award, going to click. ")
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
        PixelColorExist("0xFFFFF3",372, 244,2000)                ; Wait until the green icon gone

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