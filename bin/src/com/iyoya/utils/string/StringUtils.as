package com.iyoya.utils.string
{
	public class StringUtils
	{
		public static function ClearIllegalCharacters(str:String):String
		{
			var pattern:RegExp = /\\/g;
			str = str.replace(pattern, "");
			pattern = /\//g;
			str = str.replace(pattern, "");
			pattern = /:/g;
			str = str.replace(pattern, "");
			pattern = /\*/g;
			str = str.replace(pattern, "");
			pattern = /\?/g;
			str = str.replace(pattern, "");
			pattern = /"/g;
			str = str.replace(pattern, "");
			pattern = /</g;
			str = str.replace(pattern, "");
			pattern = />/g;
			str = str.replace(pattern, "");
			pattern = /\|/g;
			str = str.replace(pattern, "");
			return str;
		}
		public static function GetLeadingZeroString(target:Object, len:uint):String
		{
			var zeroStr:String;
			for(var i:uint = 0; i < len; i++)
			{
				zeroStr+="0";
			}
			var indexStr:String;
			if(target is String)
			{
				indexStr = zeroStr + target;
			}else{
				indexStr = zeroStr + String(target);
			}
			indexStr = indexStr.substring(indexStr.length - len);
			return indexStr;
		}
		public static function ConvertJsSpecialChar($str:String):String
		{
			var jsStr:String = $str;
			var pattern1:RegExp = /\\/g;
			jsStr = jsStr.replace(pattern1, "\\\\");
			var pattern2:RegExp = /'/g;
			jsStr = jsStr.replace(pattern2, "\\'");
			return jsStr;
		}
		
	}
}