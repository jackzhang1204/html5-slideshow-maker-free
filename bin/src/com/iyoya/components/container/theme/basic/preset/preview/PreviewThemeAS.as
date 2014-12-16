package com.iyoya.components.container.theme.basic.preset.preview
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.theme.basic.preset.preview.PreviewThemeComEvent;
	import com.iyoya.events.components.container.theme.basic.properties.PropertiesPanelComEvent;
	import com.iyoya.data.TemplateProfileParser;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	
	public class PreviewThemeAS extends Group
	{
		public var outSildeContainer:BorderContainer;
		public var previewImg:Image;
		public var previewName:Label;
		////////////////
		private var themeFolderPath:String;
		private var templateProfileParser:TemplateProfileParser;
		
		public function PreviewThemeAS()
		{
			super();
			/////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			//////////////////
			addEventListener(MouseEvent.CLICK, thisClickHandler);
			CommandDispatcher.getInstance().addEventListener(PreviewThemeComEvent.REMOVE_SELECT, removeSelectHandler);
			//////////////////
			if(AppMain.global_template_first_select)
			{
				AppMain.global_template_first_select = false;
				thisClickHandler();
			}
		}
		public function initData($themeFolderPath:String, $previewThemeXmlData:XML):void
		{
			themeFolderPath = $themeFolderPath;
			var xmlData:XML = $previewThemeXmlData;
			///////////////
			templateProfileParser = new TemplateProfileParser(xmlData);
			initPreviewTheme();
		}
		private function initPreviewTheme():void
		{
			previewName.text = templateProfileParser.profile_display_name;
			previewImg.source = themeFolderPath + "/" + templateProfileParser.profile_folder + "/" + templateProfileParser.profile_preview;
		}
		private function thisClickHandler(event:MouseEvent = null):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new PreviewThemeComEvent(PreviewThemeComEvent.REMOVE_SELECT));
			CommandDispatcher.getInstance().dispatchEvent(new PropertiesPanelComEvent(PropertiesPanelComEvent.UPDATE_PROPERTIES_PANEL, templateProfileParser.getBasicProperties()));
			CommandDispatcher.getInstance().dispatchEvent(new PreviewThemeComEvent(PreviewThemeComEvent.TEMPLATE_PROFILE_UPDATE, templateProfileParser));
			onSelect();
		}
		private function removeSelectHandler(e:PreviewThemeComEvent):void
		{
			outSildeContainer.setStyle("borderColor", 0x000000);
		}
		private function onSelect():void
		{
			outSildeContainer.setStyle("borderColor", 0xff9900);
		}
		
	}
}