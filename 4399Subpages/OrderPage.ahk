
class OrderPage{    

	GetOrderPage()
	{
		loop{
			if A_Index > 2
				throw "Not able to GetOrderPage, PixelColorExist 0xFFF8CE 499 804 not exist."
			closeAnySubWindow()
			click % HB[6]
            sleep 100
			if PixelColorExist("0xFFF8CE",499, 804,2000)			;第8名后的颜色
				break
		}
	}	

	GetBussinessWarOrder()
	{
		this.GetOrderPage()
		sleep 200
		Click 82, 707 ;ShangHui button
		sleep 2000
		MouseClickDrag, Left, 326, 676,326,326,50
		sleep 2000
		MouseClickDrag, Left, 326, 676,326,326
		sleep 2000			
	}

}
