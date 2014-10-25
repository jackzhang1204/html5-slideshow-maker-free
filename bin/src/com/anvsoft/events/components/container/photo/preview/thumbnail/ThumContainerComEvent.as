package com.anvsoft.events.components.container.photo.preview.thumbnail
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class ThumContainerComEvent extends Event
	{
		public static const THUM_CONTAINER_IMG_LOAD_COMPLETE:String = "thumContainerImgLoadComplete";
		
		public function ThumContainerComEvent(type:String, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new ThumContainerComEvent(type, bubbles, cancelable);
		}
		
	}
	
}