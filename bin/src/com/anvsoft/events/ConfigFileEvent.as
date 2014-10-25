package com.anvsoft.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class ConfigFileEvent extends Event
	{
		public static const SAVE_CONFIG_FILE:String = "saveConfigFile";
		
		public function ConfigFileEvent(type:String, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new ConfigFileEvent(type, bubbles, cancelable);
		}
		
	}
	
}