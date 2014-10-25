package com.anvsoft.components.footer
{
	import flash.events.MouseEvent;
	import mx.events.FlexEvent;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	
	public class HSMFooterAS extends Group
	{
		public var resizeWinHGrou:HGroup;
		
		public function HSMFooterAS()
		{
			super();
			/////////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			//////////////
			resizeWinHGrou.addEventListener(MouseEvent.MOUSE_DOWN, resizeWinHGrouMouseDownHandler);
			
		}
		private function resizeWinHGrouMouseDownHandler(e:MouseEvent):void
		{
			stage.nativeWindow.startResize("BR");
		}
		
	}
}