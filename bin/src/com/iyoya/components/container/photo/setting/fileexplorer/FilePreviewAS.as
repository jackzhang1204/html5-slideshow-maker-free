package com.iyoya.components.container.photo.setting.fileexplorer
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.photo.setting.fileexplorer.FilePreviewComEvent;
	import com.iyoya.utils.display.getDisplayObjectSameRatioBitmapData;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	
	public class FilePreviewAS extends Group
	{
		private var loader:Loader;
		public var borderContainer:BorderContainer;
		public var fileImg:Image;
		public var fileTitle:Label
		public var imgURL:String;
		public var title:String;
		public var url:String;
		public var isDirectory:Boolean;
		public var selected:Boolean = false;
		
		public function FilePreviewAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			///////////
			fileTitle.text = title;
			if(isDirectory)
			{
				imgURL = AppMain.global_app_assets_folder + "img/folder.jpg";
			}else{
				this.toolTip = "Double Click To Add Photo";
			}
			updateImageSource();
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(this, "toolTip", "20013");
		}
		private function updateImageSource():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.load(new URLRequest(imgURL));
		}
		private function loaderCompleteHandler(e:Event):void
		{
			var targetDisplayObject:DisplayObject = e.currentTarget.content
			var destinationW:Number = fileImg.width;
			var destinationH:Number = fileImg.height;
			var fillStyle:String = "fit";
			var fillColor:uint = 0x222222;
			var fillTransparent:Boolean = false;
			fileImg.source = getDisplayObjectSameRatioBitmapData(targetDisplayObject, destinationW, destinationH, fillStyle, fillColor, fillTransparent);
			targetDisplayObject = null;
			loader.unload();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader = null;
			//////////////////////////////
			CommandDispatcher.getInstance().dispatchEvent(new FilePreviewComEvent(FilePreviewComEvent.FILE_PREVIEW_IMG_LOAD_COMPLETE));
		}
		private function loadErrorHandler(e:IOErrorEvent):void
		{
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			loader.unload();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader = null;
			//////////////////////////////
			CommandDispatcher.getInstance().dispatchEvent(new FilePreviewComEvent(FilePreviewComEvent.FILE_PREVIEW_IMG_LOAD_COMPLETE));
		}
		////public method///////////////////////////////
		public function onSelect():void
		{
			selected = true;
			borderContainer.setStyle("borderColor", 0xff6600);
			//2013.3.19 add delete keydown Listener for remove photo////
			this.setFocus();
		}
		public function removeSelect():void
		{
			selected = false;
			borderContainer.setStyle("borderColor", 0x333333);
		}
		
	}
}