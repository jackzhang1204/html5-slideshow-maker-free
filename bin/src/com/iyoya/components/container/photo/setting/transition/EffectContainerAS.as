package com.iyoya.components.container.photo.setting.transition
{
	import com.iyoya.utils.string.StringUtils;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.BorderContainer;
	import spark.components.Image;
	import spark.components.Label;
	
	public class EffectContainerAS extends Group
	{
		public var borderContainer:BorderContainer;
		public var effectImg:Image;
		public var effectTitle:Label
		public var url:String;
		public var index:uint;
		
		[Bindable]
		public var title:String;
		[Bindable]
		public var indexStr:String;
		
		public function EffectContainerAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			//////////////
			effectImg.source = url;
			//var indexStr:String = StringUtils.GetLeadingZeroString((index + 1), 2);
			//effectTitle.text = "[" + indexStr + "] " + title;
			
			indexStr = StringUtils.GetLeadingZeroString((index + 1), 2);
		}
		////public method///////////////////////////////
		public function onSelect():void
		{
			borderContainer.setStyle("borderColor", 0xff6600);
		}
		public function removeSelect():void
		{
			borderContainer.setStyle("borderColor", 0x222222);
		}
		
	}
}