package com.anvsoft.skins.menuBar
{   
	import mx.skins.ProgrammaticSkin;
	import flash.display.Graphics;
	import mx.utils.ColorUtil;
	
	public class MenuBarActiveSkin extends ProgrammaticSkin   
	{   
		public function MenuBarActiveSkin()   
		{   
			super();
		}   
		override protected function updateDisplayList(w:Number, h:Number):void  
		{   
			var borderColor:uint = 0x000000;							//getStyle("chromeColor");
			var rollOverColor:uint = 0x333333;							//getStyle("rollOverColor");
			var backgroundAlpha:Number = getStyle("backgroundAlpha");
			/////////////////////////
			graphics.clear();
			graphics.lineStyle(1, borderColor);
			drawRoundRect(0, 0, w, h, 0, rollOverColor, backgroundAlpha);
		}
	}   
}  