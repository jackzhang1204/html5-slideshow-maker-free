package com.anvsoft.components.container.theme.basic.preset.preview
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.TileGroup;
	import spark.components.VGroup;
	
	
	public class ThemeCategoryAS extends VGroup
	{
		private var themeFolderPath:String;
		private var themeDisplayName:String;
		private var themeTotalsPerCategory:uint;
		private var configXmlFilePathArray:Array = new Array();
		private var themeFolderGlobalURL:String;
		//////////////
		public var displayName:Label;
		public var ThemeCategoryTileGroup:TileGroup;
		
		public function ThemeCategoryAS()
		{
			super();
			///////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			////////////
			
		}
		public function initData($themeFolderPath:String, $themeDisplayName:String):void
		{
			themeFolderPath = $themeFolderPath;
			themeDisplayName = $themeDisplayName;
			
			////////////////////////////
			var file:File = File.applicationDirectory.resolvePath(themeFolderPath);
			themeFolderGlobalURL = file.url;
			var list:Array = file.getDirectoryListing();
			for (var i:uint = 0; i < list.length; i++)
			{
				if(list[i].extension == "xml")
				{
					configXmlFilePathArray.push(list[i].url);
				}
			}
			themeTotalsPerCategory = configXmlFilePathArray.length;
			//////////////////////////////
			initThemePerCategory();
		}
		private function initThemePerCategory():void
		{
			displayName.text = themeDisplayName;
			/////////////////////
			for(var i:uint = 0; i < themeTotalsPerCategory; i++)
			{
				var xmlLoader:URLLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
				xmlLoader.load(new URLRequest(configXmlFilePathArray[i]));
				
				//trace(configXmlFilePathArray[i]);
			}
			
		}
		private function loadCompleteHandler(e:Event):void
		{
			var xmlData:XML = new XML(e.target.data);
			xmlData.ignoreWhitespace = true;
			////////////////////
			var previewThemeXmlData:XML = new XML(xmlData);
			var previewThemewCom:PreviewThemeCom = new PreviewThemeCom();
			ThemeCategoryTileGroup.addElement(previewThemewCom);
			previewThemewCom.initData(themeFolderPath, previewThemeXmlData);
		}
		
	}
}