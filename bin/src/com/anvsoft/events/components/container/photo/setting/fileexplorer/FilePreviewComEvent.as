package com.anvsoft.events.components.container.photo.setting.fileexplorer
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class FilePreviewComEvent extends Event
	{
		public static const FILE_PREVIEW_IMG_LOAD_COMPLETE:String = "filePreviewImgLoadComplete";
		
		public function FilePreviewComEvent(type:String, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new FilePreviewComEvent(type, bubbles, cancelable);
		}
		
	}
	
}