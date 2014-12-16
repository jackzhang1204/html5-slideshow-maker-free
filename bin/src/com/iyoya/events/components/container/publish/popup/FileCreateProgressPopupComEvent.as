package com.iyoya.events.components.container.publish.popup
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class FileCreateProgressPopupComEvent extends Event
	{
		public static const POPUP_CREATION_COMPLETE:String = "popupCreationComplete";
		public static const OPEN_HTML_FILE:String = "openHtmlFile";
		public static const OPEN_SLIDESHOW_FOLDER:String = "openSlideshowFolder";
		///////////
		public static const FILE_CREATE_PROGRESS:String = "fileCreateProgress";
		public static const FILE_CREATE_COMPLETE:String = "fileCreateComplete";
		public static const FILE_CREATE_CANCEL:String = "fileCreateCancel";
		//////////
		public static const OPEN_UPLOAD_LOG:String = "openUploadLog";
		//////////
		public var progress:uint;
		public var totals:uint;
		public function FileCreateProgressPopupComEvent(type:String, progress:uint = 0, totals:uint = 1, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.progress = progress;
			this.totals = totals;
		}
		public override function clone():Event
		{
			return new FileCreateProgressPopupComEvent(type, progress, totals, bubbles, cancelable);
		}
	}
	
}

