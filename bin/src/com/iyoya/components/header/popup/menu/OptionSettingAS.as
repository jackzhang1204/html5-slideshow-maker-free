package com.iyoya.components.header.popup.menu
{
	import com.iyoya.components.header.popup.menu.options.ImageOptionsCom;
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.ConfigFileEvent;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import spark.components.Button;
	import spark.components.NavigatorContent;
	import spark.components.TitleWindow;
	
	public class OptionSettingAS extends TitleWindow
	{
		public var okButton:Button;
		public var cancelButton:Button;
		
		public var imgOptionsNC:NavigatorContent
		
		public var imageOptionsCom:ImageOptionsCom;
		
		public function OptionSettingAS()
		{
			super();
			////////////////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(CloseEvent.CLOSE, cancelButtonClickHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			///////////////////////////
			this.x = (this.parent.width - this.width)/2;
			this.y = (this.parent.height - this.height)/2;
			///////////////
			okButton.addEventListener(MouseEvent.CLICK, okButtonClickHandler);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(this, "title", "61001");
			LanguageManager.getInstance().binding(imgOptionsNC, "label", "61002");
			LanguageManager.getInstance().binding(okButton, "label", "10001");
			LanguageManager.getInstance().binding(cancelButton, "label", "10002");
		}
		private function okButtonClickHandler(e:MouseEvent):void
		{
			imageOptionsCom.submit();
			CommandDispatcher.getInstance().dispatchEvent(new ConfigFileEvent(ConfigFileEvent.SAVE_CONFIG_FILE));
			//////////
			PopUpManager.removePopUp(this);
			removeAllEventListener();
		}
		private function cancelButtonClickHandler(e:Event):void
		{
			PopUpManager.removePopUp(this);
			removeAllEventListener();
		}
		private function removeAllEventListener():void
		{
			removeEventListener(CloseEvent.CLOSE, cancelButtonClickHandler);
			okButton.removeEventListener(MouseEvent.CLICK, okButtonClickHandler);
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
			okButton = null;
			cancelButton = null;
			imageOptionsCom = null;
		}
		
	}
}