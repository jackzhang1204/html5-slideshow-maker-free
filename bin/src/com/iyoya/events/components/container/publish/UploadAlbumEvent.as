package com.iyoya.events.components.container.publish
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class UploadAlbumEvent extends Event
	{
		public static const CREATE_UPLOAD_FILE:String = "createUploadFile";
		public static const UPLOAD_OPEN:String = "uploadOpen";
		public static const UPLOAD_PROGRESS:String = "uploadProgress";
		public static const AUTHENTICATE_FAILED:String = "authenticateFailed";
		public static const UPLOAD_FINISHED:String = "uploadFinished";
		public static const UPLOAD_CANCELED:String = "uploadCanceled";
		public static const UPLOAD_CANCELED_COMPLETE:String = "uploadCanceledComplete";
		public static const UPLOAD_FAILED:String = "uploadFailed";
		public static const FILE_SIZE_LIMIT:String = "fileSizeLimit";
		public static const SAVE_UPLOAD_LOG:String = "saveUploadLog";
		////////
		public var data:Object;
		public var progress:Number;
		public var totals:Number;
		public var info:String;
		public function UploadAlbumEvent(type:String, data:Object = null, progress:Number = 0, totals:Number = 1, info:String = "", bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.data = data;
			this.progress = progress;
			this.totals = totals;
			this.info = info;
		}
		public override function clone():Event
		{
			return new UploadAlbumEvent(type, data, progress, totals, info, bubbles, cancelable);
		}
	}
}

