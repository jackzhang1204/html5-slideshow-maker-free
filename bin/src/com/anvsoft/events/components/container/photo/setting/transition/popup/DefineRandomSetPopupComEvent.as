package com.anvsoft.events.components.container.photo.setting.transition.popup
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class DefineRandomSetPopupComEvent extends Event
	{
		public static const SELECT_ALL_TRANSITION:String = "selectAllTransition";
		public static const SELECT_OUT_ALL_TRANSITION:String = "selectOutAllTransition";
		public static const UPDATE_ITEM_RENDERER:String = "updateItemRenderer";
		
		public function DefineRandomSetPopupComEvent(type:String, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new DefineRandomSetPopupComEvent(type, bubbles, cancelable);
		}
	}
}