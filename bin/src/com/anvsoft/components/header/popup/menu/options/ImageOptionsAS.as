package com.anvsoft.components.header.popup.menu.options
{
	import com.anvsoft.utils.language.LanguageManager;
	
	import mx.controls.ColorPicker;
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.RadioButton;
	import spark.components.NumericStepper;
	import spark.components.VGroup;
	
	public class ImageOptionsAS extends VGroup
	{
		public var imgScaleToFitRadioButton:RadioButton;
		public var imgScaleToFillRadioButton:RadioButton;
		public var imgBgColorPicker:ColorPicker;
		public var thumScaleToFitRadioButton:RadioButton;
		public var thumScaleToFillRadioButton:RadioButton;
		public var thumBgColorPicker:ColorPicker;
		public var jpgQualityNumStepper:NumericStepper;
		
		public var imgOptionsLabel:Label;
		public var imgScaleOptionsLabel:Label;
		public var imgBgColorLabel:Label;
		public var thumScaleOptionsLabel:Label;
		public var thumBgColorLabel:Label;
		public var jpgQualityLabel:Label;
		
		public function ImageOptionsAS()
		{
			super();
			/////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			////////////////
			initOptions();
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(imgOptionsLabel, "text", "61002");
			LanguageManager.getInstance().binding(imgScaleOptionsLabel, "text", "61003");
			LanguageManager.getInstance().binding(imgScaleToFitRadioButton, "label", "61004");
			LanguageManager.getInstance().binding(imgScaleToFillRadioButton, "label", "61005");
			LanguageManager.getInstance().binding(imgBgColorLabel, "text", "61006");
			LanguageManager.getInstance().binding(thumScaleOptionsLabel, "text", "61007");
			LanguageManager.getInstance().binding(thumScaleToFitRadioButton, "label", "61004");
			LanguageManager.getInstance().binding(thumScaleToFillRadioButton, "label", "61005");
			LanguageManager.getInstance().binding(thumBgColorLabel, "text", "61006");
			LanguageManager.getInstance().binding(jpgQualityLabel, "text", "61008");
		}
		private function initOptions():void
		{
			if(AppMain.global_photo_fill_style == "fit")
			{
				imgScaleToFitRadioButton.selected = true;
				imgScaleToFillRadioButton.selected = false;
			}else{
				imgScaleToFitRadioButton.selected = false;
				imgScaleToFillRadioButton.selected = true;
			}
			imgBgColorPicker.selectedColor = AppMain.global_photo_fill_color;
			
			if(AppMain.global_thum_fill_style == "fit")
			{
				thumScaleToFitRadioButton.selected = true;
				thumScaleToFillRadioButton.selected = false;
			}else{
				thumScaleToFitRadioButton.selected = false;
				thumScaleToFillRadioButton.selected = true;
			}
			thumBgColorPicker.selectedColor = AppMain.global_thum_fill_color;
			jpgQualityNumStepper.value = AppMain.global_jpeg_quality;
		}
		public function submit():void
		{
			if(imgScaleToFitRadioButton.selected)
			{
				AppMain.global_photo_fill_style = "fit";
			
			}else{
				AppMain.global_photo_fill_style = "fill";
			}
			AppMain.global_photo_fill_color = imgBgColorPicker.selectedColor;
			
			if(thumScaleToFitRadioButton.selected)
			{
				AppMain.global_thum_fill_style = "fit";
				
			}else{
				AppMain.global_thum_fill_style = "fill";
			}
			AppMain.global_thum_fill_color = thumBgColorPicker.selectedColor;
			AppMain.global_jpeg_quality = jpgQualityNumStepper.value;
		}
		
	}
}