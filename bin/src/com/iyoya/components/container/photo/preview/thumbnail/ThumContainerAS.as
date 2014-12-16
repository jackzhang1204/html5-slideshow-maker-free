package com.iyoya.components.container.photo.preview.thumbnail
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.utils.display.getDisplayObjectSameRatioBitmapData;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import mx.events.FlexEvent;
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	
	public class ThumContainerAS extends Group
	{
		private var loader:Loader;
		public var outSildeContainer:BorderContainer;
		public var thumImg:Image;
		public var thumTitle:Label;
		public var transitionImg:Image;
		public var transDurationLabel:Label;
		public var photoShowDuraLabel:Label;
		
		public var url:String;
		public var title:String = "Title";
		public var transitionId:String = "0";
		[Bindable]
		public var transitionDuration:String = "2";
		[Bindable]
		public var photoShowDuration:String = "2";
		
		public function ThumContainerAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			//////////////////////////////////
			thumTitle.text = title;
			updateImageSource();
		}
		private function updateImageSource():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.load(new URLRequest(url));
		}
		private function loaderCompleteHandler(e:Event):void
		{
			var targetDisplayObject:DisplayObject = e.currentTarget.content
			var destinationW:Number = thumImg.width;
			var destinationH:Number = thumImg.height;
			var fillStyle:String = "fit";
			var fillColor:uint = 0x222222;
			var fillTransparent:Boolean = false;
			thumImg.source = getDisplayObjectSameRatioBitmapData(targetDisplayObject, destinationW, destinationH, fillStyle, fillColor, fillTransparent);
			targetDisplayObject = null;
			loader.unload();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader = null;
		}
		////public method///////////////////////////////
		public function onSelect():void
		{
			outSildeContainer.setStyle("backgroundColor", 0xff9900);
			//2013.3.19 add delete keydown Listener for remove photo////
			this.setFocus();
		}
		public function removeSelect():void
		{
			outSildeContainer.setStyle("backgroundColor", 0x333333);
		}
		
	}
}