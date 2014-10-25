package com.anvsoft.utils.color
{
	public class ColorConverter
	{
		public static function BGRToRGB(bgrStr:String):String
		{
			var rgbStr:String = bgrStr.substr(bgrStr.length - 6);
			rgbStr = rgbStr.replace(/([\w]{2})([\w]{2})([\w]{2})/, "$3$2$1");
			rgbStr = "0x" + rgbStr;
			return rgbStr;
		}
		public static function UintToRGB(color:uint):String
		{
			var colorStr:String = "000000" + color.toString(16);
			colorStr = colorStr.substring(colorStr.length - 6);
			colorStr = "0x" + colorStr;
			return colorStr;
		}
		
	}
}