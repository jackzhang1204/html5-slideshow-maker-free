package com.anvsoft.components.container.theme.basic.preset
{
	import com.anvsoft.components.container.theme.basic.preset.preview.ThemeCategoryCom;
	import com.anvsoft.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.VGroup;
	
	public class PresetPanelAS extends VGroup
	{
		public var basePresetPanel:VGroup;
		
		public var categoryLabel:Label;
		
		private var templatFloderPath:String = "assets/template/";
		private var templatePresetClassFileName:String = "template_preset_class.xml";
		private var presetFolder:String;
		private var classCount:uint;
		private var themeFolderPathArray:Array = new Array();
		private var themeDisplayNameArray:Array = new Array();
		
		public function PresetPanelAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			//////////////////
			//load template preset class xml
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			xmlLoader.load(new URLRequest(templatFloderPath + templatePresetClassFileName));
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(categoryLabel, "text", "30003");
		}
		private function loadCompleteHandler(e:Event):void
		{
			var xmlDta:XML = new XML(e.target.data);
			xmlDta.ignoreWhitespace = true;
			////////////////////
			presetFolder = xmlDta.@preset_folder;
			classCount = uint(xmlDta.@class_count);
			for(var i:uint = 0; i < classCount; i++)
			{
				themeFolderPathArray.push(xmlDta.template_class.@folder[i]);
				themeDisplayNameArray.push(xmlDta.template_class.@display_name[i]);
			}
			createThemeCategory();
		}
		private function createThemeCategory():void
		{
			for(var i:uint = 0; i < classCount; i++)
			{
				var themeCategory:ThemeCategoryCom = new ThemeCategoryCom();
				basePresetPanel.addElement(themeCategory);
				var themeFolderPath:String = templatFloderPath + presetFolder + "/" + themeFolderPathArray[i];
				var themeDisplayName:String = themeDisplayNameArray[i];
				themeCategory.initData(themeFolderPath, themeDisplayName);
			}
		}
		
	}
}