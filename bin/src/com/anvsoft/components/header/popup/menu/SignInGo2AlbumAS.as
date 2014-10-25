package com.anvsoft.components.header.popup.menu
{
	import com.anvsoft.components.AppAlertCom;
	import com.anvsoft.data.SharedObjectData;
	import com.anvsoft.utils.language.LanguageManager;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	
	public class SignInGo2AlbumAS extends TitleWindow
	{
		public var createAccountBtn:Button;
		public var go2albumIdTI:TextInput;
		public var passwordTI:TextInput;
		public var okButton:Button;
		
		public var tipLabel:Label;
		public var userTipLable:Label;
		public var go2albumIdLabel:Label;
		public var go2albumPasswordLabel:Label;
		
		public function SignInGo2AlbumAS()
		{
			super();
			///////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			/////////////////////////////////////
			getSigninInfo();
			this.title = "Sign in Go2Album";
			this.x = Math.round((this.parent.width - this.width) / 2);
			this.y = Math.round((this.parent.height - this.height) / 2);
			///////////////////////
			addEventListener(CloseEvent.CLOSE, closePopUpHandler);
			createAccountBtn.addEventListener(MouseEvent.CLICK, createAccountBtnClickHandler);
			okButton.addEventListener(MouseEvent.CLICK, okButtonClickHandler);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(this, "title", "60001");
			LanguageManager.getInstance().binding(tipLabel, "text", "60002");
			LanguageManager.getInstance().binding(createAccountBtn, "label", "60003");
			LanguageManager.getInstance().binding(userTipLable, "text", "60004");
			LanguageManager.getInstance().binding(go2albumIdLabel, "text", "60005");
			LanguageManager.getInstance().binding(go2albumPasswordLabel, "text", "60006");
			LanguageManager.getInstance().binding(okButton, "label", "10001");
		}
		private function closePopUpHandler(e:CloseEvent = null):void
		{
			PopUpManager.removePopUp(this);
			removeAllEventListener();
		}
		private function createAccountBtnClickHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(AppMain.global_go2album_register_url));
		}
		private function okButtonClickHandler(e:MouseEvent):void
		{
			if(go2albumIdTI.text == "" || passwordTI.text == "")
			{
				var userInfoErrorAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
				userInfoErrorAlert.tipTitle = "HTML5 Slideshow Maker";
				if(go2albumIdTI.text == "")
				{
					userInfoErrorAlert.tipInfo = "Please enter the ID of your Go2Album account!";
				}else if(passwordTI.text == ""){
					userInfoErrorAlert.tipInfo = "Please enter the password of your Go2Album account!";
				}
			}else{
				saveSigninInfo();
				closePopUpHandler();
			}
		}
		private function getSigninInfo():void
		{
			go2albumIdTI.text = SharedObjectData.getSigninInfo().username;
			passwordTI.text = SharedObjectData.getSigninInfo().password;
		}
		private function saveSigninInfo():void
		{
			SharedObjectData.saveSigninInfo(go2albumIdTI.text, passwordTI.text);
		}
		private function removeAllEventListener():void
		{
			removeEventListener(CloseEvent.CLOSE, closePopUpHandler);
			createAccountBtn.removeEventListener(MouseEvent.CLICK, createAccountBtnClickHandler);
			okButton.removeEventListener(MouseEvent.CLICK, okButtonClickHandler);
			createAccountBtn = null;
			go2albumIdTI = null;
			passwordTI = null;
			okButton = null;
		}
	}
}