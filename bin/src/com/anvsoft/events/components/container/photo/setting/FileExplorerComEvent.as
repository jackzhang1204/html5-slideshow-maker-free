package com.anvsoft.events.components.container.photo.setting
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class FileExplorerComEvent extends Event
	{
		public static const ADD_PHOTO_FROM_FILE_EXPLORER:String = "addPhotoFromFileExplorer";
		public static const SELECTED_FILE_FROM_FILE_EXPLORER:String = "selectedFileFromFileExplorer";
		public static const REMOVE_SELECTED_FILE_FROM_FILE_EXPLORER:String = "removeSelectedFileFromFileExplorer";
		//2013.3.20 add filePreview drag drop function///////////
		public static const FILE_PREVIEW_MOUSE_DOWN:String = "filePreviewMouseDown";
		public static const FILE_PREVIEW_MOUSE_MOVE:String = "filePreviewMouseMove";
		public static const FILE_PREVIEW_MOUSE_UP:String = "filePreviewMouseUp";
		////////////////////////////////////////
		public var photoURL:String;
		public var photoTitle:String;
		//////////////////
		public var filePreviewBitmapData:BitmapData;
		
		public function FileExplorerComEvent(type:String, photoURL:String = "", photoTitle:String = "", filePreviewBitmapData:BitmapData = null, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.photoURL = photoURL;
			this.photoTitle = photoTitle;
			//////////////
			this.filePreviewBitmapData = filePreviewBitmapData;
		}
		public override function clone():Event
		{
			return new FileExplorerComEvent(type, photoURL, photoTitle, filePreviewBitmapData, bubbles, cancelable);
		}
	}
}