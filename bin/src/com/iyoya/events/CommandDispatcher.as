package com.iyoya.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class CommandDispatcher implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		private static  var instance:CommandDispatcher;
		public function CommandDispatcher(singletonEnforcer:SingletonEnforcer) 
		{
			if (singletonEnforcer==null) {
				throw new Error("singletonEnforcer");
			}else {
				dispatcher = new EventDispatcher(this);
			}
		}
		public static function getInstance():CommandDispatcher {
			if (CommandDispatcher.instance == null) {
				CommandDispatcher.instance = new CommandDispatcher(new SingletonEnforcer());
			}
			return CommandDispatcher.instance;
		}
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(e:Event):Boolean{
			return dispatcher.dispatchEvent(e);
		}
		
		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}

	}
		
}
class SingletonEnforcer {
	
}