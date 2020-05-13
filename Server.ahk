#NoEnv
SetBatchLines, -1

#Include Socket.ahk
#Include Jxon.ahk
#Include RemoteObj.ahk
#include 4399UserTask.ahk

MyClass := new ExampleClass()
Remote := new RemoteObj(MyClass, ["10.154.10.6", 1337])
return

class ExampleClass
{
	__New()
	{
    ToolTip, serversiderunning, 100, 0, 1
	}
	
	
  OpenGame(names)
  {
    user := new 4399UserTask(names,0)
    if !user = ""
      return 1
    Else
      return 0  
  }

  ZhuZi(names,which,isclose)
  {
    user := new 4399UserTask(names,isclose)
    result := user.ZhuZi(which)
    user := ""
    return result
  }

  RongZi(names,which,isclose)
  {
    user := new 4399UserTask(names,isclose)
    result := user.RongZi(which)
    user := ""
    return result
  }

  Getland(names,isclose)
  {
    user := new 4399UserTask(names,isclose)
    result := user.Getland()
    user := ""
    return result
  }


	Run(Target)
	{
		Run, %Target%
	}
	
	MsgBox(Text)
	{
		MsgBox, %Text%
	}
}

F7::ExitApp
return