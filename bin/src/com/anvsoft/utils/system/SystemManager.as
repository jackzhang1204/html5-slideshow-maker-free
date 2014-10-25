package com.anvsoft.utils.system
{
	import flash.system.System;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SystemManager
	{
		private var gcTimer:Timer;
		private var timerDelay:Number = 10000;
		private var repeatCount:int = 1;
		public function SystemManager()
		{
			gcTimer = new Timer(timerDelay, repeatCount);
			gcTimer.addEventListener(Event.DEACTIVATE, nativeWindowDeactivateHandler);
		}
		private function nativeWindowDeactivateHandler(e:Event):void
		{
			if(!gcTimer.running)
			{
				System.gc();
				//trace("start gc");
			}
		}
		public function startWaitingGC():void
		{
			if(gcTimer.running)
			{
				gcTimer.reset();
			}else{
				gcTimer.addEventListener(TimerEvent.TIMER, gcTimerHandler);
			}
			gcTimer.start();
		}
		private  function gcTimerHandler(e:TimerEvent):void
		{
			gcTimer.removeEventListener(TimerEvent.TIMER, gcTimerHandler);
			////////////////////////////////////
			System.gc();
			//trace("start gc");
		}
	}
}