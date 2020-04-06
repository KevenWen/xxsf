
class OrderPage{    

	GetOrderPage()
	{
		4399sfGame.closeAnySubWindow()
		click % HB[6]
		WaitPixelColor("0xFFF8CE",499, 804,2000)			;第8名后的颜色
		sleep 100
	}	

	GetBussinessWarOrder()
	{
		this.GetOrderPage()
		Click 82, 707 ;ShangHui button
		sleep 500
		CaptureScreen()
		sleep 500
		CaptureScreen()	;the first 11 entry	
		sleep 1000
		CaptureScreen()	;the first 11 entry	again
		MouseMove, 326, 676
		sleep 1000
		MouseClickDrag, Left, 326, 676,326,326,50
		sleep 2000
		mousemove 557, 398
		CaptureScreen()		;the seconrd entries
		sleep 1000			
		MouseClickDrag, Left, 326, 676,326,326
		sleep 2000			
		mousemove 557, 398
		CaptureScreen()		;the third entries
		sleep 2000
	}

}
