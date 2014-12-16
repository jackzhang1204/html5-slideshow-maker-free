package com.iyoya.components.container.photo.setting
{
	import com.iyoya.data.AlbumDataParser;
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.photo.preview.PreviewPanelComEvent;
	import com.iyoya.events.components.container.photo.setting.PropertiesPanelComEvent;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.VGroup;
	import spark.events.TextOperationEvent;
	
	public class PropertiesPanelAS extends Group
	{
		public var leftArea:VGroup;
		public var imgTitle:TextInput;
		public var imgDescription:TextArea;
		public var imgURL:TextInput;
		public var openURL:Button;
		public var applyToSelected:Button;
		public var applyToAll:Button;
		
		public var imgTitleLabel:Label;
		public var descriptionLabel:Label;
		public var linkLabel:Label;
		
		public function PropertiesPanelAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			////////////////////////
			imgTitle.addEventListener(TextOperationEvent.CHANGE, textChangHandler);
			imgDescription.addEventListener(TextOperationEvent.CHANGE, textChangHandler);
			imgURL.addEventListener(TextOperationEvent.CHANGE, textChangHandler);
			////////////
			openURL.addEventListener(MouseEvent.CLICK, openURLClickHandler);
			applyToSelected.addEventListener(MouseEvent.CLICK, applyToSelectedClickHandler);
			applyToAll.addEventListener(MouseEvent.CLICK, applyToAllClickHandler);
			CommandDispatcher.getInstance().addEventListener(PreviewPanelComEvent.THUM_CONTAINER_SELECTED, thumContainerSelected);
			CommandDispatcher.getInstance().addEventListener(PreviewPanelComEvent.THUM_CONTAINER_UNSELECTED, thumContainerUnselected);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(imgTitleLabel, "text", "21002");
			LanguageManager.getInstance().binding(descriptionLabel, "text", "21003");
			LanguageManager.getInstance().binding(linkLabel, "text", "21004");
			LanguageManager.getInstance().binding(openURL, "label", "21005");
			LanguageManager.getInstance().binding(applyToSelected, "label", "20006");
			LanguageManager.getInstance().binding(applyToAll, "label", "20008");
		}
		private function textChangHandler(e:Event):void
		{
			applyProperties("applyToSelected");
		}
		private function openURLClickHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(imgURL.text));
		}
		private function applyToSelectedClickHandler(e:MouseEvent):void
		{
			applyProperties("applyToSelected");
		}
		private function applyToAllClickHandler(e:MouseEvent):void
		{
			applyProperties("applyToAll");
		}
		private function applyProperties($applyType:String = "applyToSelected"):void
		{
			var title:String = imgTitle.text;
			var description:String = imgDescription.text;
			var url:String = imgURL.text;
			var applyType:String = $applyType;
			CommandDispatcher.getInstance().dispatchEvent(new PropertiesPanelComEvent(PropertiesPanelComEvent.SET_IMAGE_PROPERTIES, title, description, url, applyType));
		}
		private function thumContainerSelected(e:PreviewPanelComEvent):void
		{
			leftArea.enabled = true;
			var albumDataParser:AlbumDataParser = e.albumDataObj as AlbumDataParser;
			var index:int = e.thumIndex;
			imgTitle.text = albumDataParser.getTitle(index);
			imgDescription.text = albumDataParser.getDescription(index);
			imgURL.text = albumDataParser.getURL(index);
		}
		private function thumContainerUnselected(e:PreviewPanelComEvent):void
		{
			leftArea.enabled = false;
			leftArea.setFocus();
		}
	}
}