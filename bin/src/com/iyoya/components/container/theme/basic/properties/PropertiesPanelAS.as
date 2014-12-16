package com.iyoya.components.container.theme.basic.properties
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.theme.basic.properties.PropertiesPanelComEvent;
	import com.iyoya.utils.color.ColorConverter;
	import com.iyoya.utils.language.LanguageManager;
	
	import mx.controls.ColorPicker;
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.TextInput;
	import spark.components.VGroup;
	
	public class PropertiesPanelAS extends VGroup
	{
		public var html_title:TextInput;
		public var movieWidth:NumericStepper;
		public var movieHeight:NumericStepper;
		public var frameRate:NumericStepper;
		public var backgroundColor:ColorPicker;
		public var startAutoPlay:CheckBox;
		public var clickToAutoPlay:CheckBox;
		public var randomPlayingPhotos:CheckBox;
		public var continuum:CheckBox;
		public var enableURL:CheckBox;
		
		public var propertiesLabel:Label;
		public var htmlTitleLabel:Label;
		public var widthLabel:Label;
		public var heightLabel:Label;
		public var frameRateLabel:Label;
		public var bgColorLabel:Label;
		
		public function PropertiesPanelAS()
		{
			super();
			////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			CommandDispatcher.getInstance().addEventListener(PropertiesPanelComEvent.UPDATE_PROPERTIES_PANEL, updatePropertiesPanelHandler);
			CommandDispatcher.getInstance().addEventListener(PropertiesPanelComEvent.GET_PROPERTIES_PANEL_DATA, getPropertiesPanelDataHandler);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(propertiesLabel, "text", "30004");
			LanguageManager.getInstance().binding(htmlTitleLabel, "text", "31001");
			LanguageManager.getInstance().binding(widthLabel, "text", "31002");
			LanguageManager.getInstance().binding(heightLabel, "text", "31003");
			LanguageManager.getInstance().binding(frameRateLabel, "text", "31004");
			LanguageManager.getInstance().binding(bgColorLabel, "text", "31005");
			LanguageManager.getInstance().binding(startAutoPlay, "label", "31006");
			LanguageManager.getInstance().binding(clickToAutoPlay, "label", "31007");
			LanguageManager.getInstance().binding(randomPlayingPhotos, "label", "31008");
			LanguageManager.getInstance().binding(continuum, "label", "31009");
			LanguageManager.getInstance().binding(enableURL, "label", "31010");
		}
		private function updatePropertiesPanelHandler(e:PropertiesPanelComEvent):void
		{
			update(e.propertiesObj);
		}
		private function getPropertiesPanelDataHandler(e:PropertiesPanelComEvent):void
		{
			var obj:Object = new Object();
			obj.html_title = html_title.text;
			obj.movieWidth = movieWidth.value;
			obj.movieHeight = movieHeight.value;
			obj.frameRate = frameRate.value;
			obj.backgroundColor = ColorConverter.UintToRGB(backgroundColor.selectedColor);
			obj.startAutoPlay = startAutoPlay.selected;
			obj.clickToAutoPlay = clickToAutoPlay.selected;
			obj.randomPlayingPhotos = randomPlayingPhotos.selected;
			obj.continuum = continuum.selected;
			obj.enableURL = enableURL.selected;
			
			///////////////////////
			CommandDispatcher.getInstance().dispatchEvent(new PropertiesPanelComEvent(PropertiesPanelComEvent.PROPERTIES_DATA_UPDATE, obj));
		}
		
		private function update(obj:Object):void
		{
			//html_title.text = obj.html_title;
			html_title.text = "Title";
			movieWidth.value = obj.movieWidth;
			movieHeight.value = obj.movieHeight;
			frameRate.value = obj.frameRate;
			backgroundColor.selectedColor = obj.backgroundColor;
			startAutoPlay.selected = obj.startAutoPlay;
			clickToAutoPlay.selected = obj.clickToAutoPlay;
			randomPlayingPhotos.selected = obj.randomPlayingPhotos;
			continuum.selected = obj.continuum;
			enableURL.selected = obj.enableURL;
			
		}
		
	}
}