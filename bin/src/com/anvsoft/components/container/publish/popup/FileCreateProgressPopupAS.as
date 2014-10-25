package com.anvsoft.components.container.publish.popup
{
	import com.anvsoft.components.AppAlertCom;
	import com.anvsoft.events.CommandDispatcher;
	import com.anvsoft.events.components.container.publish.UploadAlbumEvent;
	import com.anvsoft.events.components.container.publish.popup.FileCreateProgressPopupComEvent;
	import com.anvsoft.components.header.popup.menu.SignInGo2AlbumCom;
	import com.anvsoft.data.SharedObjectData;
	import com.anvsoft.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.controls.ProgressBar;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.RadioButton;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	import spark.components.VGroup;
	
	public class FileCreateProgressPopupAS extends TitleWindow
	{
		public var progressVgroup:VGroup;
		public var completeVgroup:VGroup;
		public var uploadHgroup:HGroup;
		public var responseVgroup:VGroup;
		public var progressBar:ProgressBar;
		public var openHtmlFileButton:Button;
		public var openOutputFolderButton:Button;
		public var uploadToInternetButton:Button;
		public var cancelPopButton:Button;
		public var closePopButton:Button;
		public var uploadButton:Button;
		public var progressTitleLabel:Label;
		public var progressInfoLabel:Label;
		public var albumPublicRBtn:RadioButton;
		public var albumTileTI:TextInput;
		public var albumDescriptionTI:TextArea;
		public var albumTagsTI:TextInput;
		public var responseTitleLabel:Label;
		public var albumLinkLabel:Label;
		public var viewUplodLogBtn:Button;
		
		public var fileCreateProgessTopLabel:Label;
		public var createSuccessfullyLabel:Label;
		public var wouldYouLikeToLabel:Label;
		public var setAlbumInformationLabel:Label;
		public var albumTitleLabel:Label;
		public var albumDesLabel:Label;
		public var albumTagLabel:Label;
		public var albumPrivacyLabel:Label;
		public var albumPrivateRBtn:RadioButton;
		
		////////////////
		public var enableUpload:Boolean;
		private var progressType:String = "createFile";
		
		public function FileCreateProgressPopupAS()
		{
			super();
			////////////////////////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			CommandDispatcher.getInstance().addEventListener(FileCreateProgressPopupComEvent.FILE_CREATE_PROGRESS, fileCreateProgressHandler);
			CommandDispatcher.getInstance().addEventListener(FileCreateProgressPopupComEvent.FILE_CREATE_COMPLETE, fileCreateCompleteHandler);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.UPLOAD_OPEN, uploadOpenHandler);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.UPLOAD_PROGRESS, uploadProgressHandler);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.AUTHENTICATE_FAILED, uploadAuthenticateFailed);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.UPLOAD_FINISHED, uploadFinishedHandler);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.UPLOAD_CANCELED_COMPLETE, uploadCanceledCompleteHandler);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.UPLOAD_FAILED, uploadFailedHandler);
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.FILE_SIZE_LIMIT, fileSizeLimitHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			////////////////////////////////////
			completeVgroup.visible = false;
			uploadHgroup.visible = false;
			responseVgroup.visible = false;
			closePopButton.enabled = false;
			albumTileTI.text = AppMain.global_slideshow_name;
			this.x = (this.parent.width - this.width)/2;
			this.y = (this.parent.height - this.height)/2;
			/////////////////////
			addEventListener(CloseEvent.CLOSE, cancelPopButtonClickHandler);
			cancelPopButton.addEventListener(MouseEvent.CLICK, cancelPopButtonClickHandler);
			closePopButton.addEventListener(MouseEvent.CLICK, closePopUpHandler);
			openHtmlFileButton.addEventListener(MouseEvent.CLICK, openHtmlFileButtonClickHandler);
			openOutputFolderButton.addEventListener(MouseEvent.CLICK, openOutputFolderButtonClickHandler);
			uploadToInternetButton.addEventListener(MouseEvent.CLICK, uploadToInternetButtonClickHandler);
			uploadButton.addEventListener(MouseEvent.CLICK, uploadButtonClickHandler);
			albumLinkLabel.addEventListener(MouseEvent.CLICK, albumLinkLabelClickHandler);
			viewUplodLogBtn.addEventListener(MouseEvent.CLICK, viewUplodLogBtnClickHandler);
			dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.POPUP_CREATION_COMPLETE));
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(this, "title", "40001");
			LanguageManager.getInstance().binding(fileCreateProgessTopLabel, "text", "41001");
			LanguageManager.getInstance().binding(progressTitleLabel, "text", "41002");
			LanguageManager.getInstance().binding(createSuccessfullyLabel, "text", "41004");
			LanguageManager.getInstance().binding(wouldYouLikeToLabel, "text", "41005");
			LanguageManager.getInstance().binding(openHtmlFileButton, "label", "41006");
			LanguageManager.getInstance().binding(openOutputFolderButton, "label", "41007");
			LanguageManager.getInstance().binding(uploadToInternetButton, "label", "41008");
			LanguageManager.getInstance().binding(setAlbumInformationLabel, "text", "41009");
			LanguageManager.getInstance().binding(albumTitleLabel, "text", "41010");
			LanguageManager.getInstance().binding(albumDesLabel, "text", "41011");
			LanguageManager.getInstance().binding(albumTagLabel, "text", "41012");
			LanguageManager.getInstance().binding(albumPrivacyLabel, "text", "41013");
			LanguageManager.getInstance().binding(albumPublicRBtn, "label", "41014");
			LanguageManager.getInstance().binding(albumPrivateRBtn, "label", "41015");
			LanguageManager.getInstance().binding(responseTitleLabel, "text", "41016");
			LanguageManager.getInstance().binding(viewUplodLogBtn, "label", "41017");
			LanguageManager.getInstance().binding(uploadButton, "label", "41019");
			LanguageManager.getInstance().binding(cancelPopButton, "label", "10002");
			LanguageManager.getInstance().binding(closePopButton, "label", "10005");
		}
		private function settingProgressBar(progress:Number):void
		{
			progressBar.setProgress(progress, 100);
			progressBar.label = "Progress: " + progress + "%";
		}
		//CommandDispatcher EventListener Handler//////
		private function fileCreateProgressHandler(e:FileCreateProgressPopupComEvent):void
		{
			var progress:Number = Math.round(e.progress / e.totals * 100);
			settingProgressBar(progress);
		}
		private function fileCreateCompleteHandler(e:FileCreateProgressPopupComEvent):void
		{
			progressVgroup.visible = false;
			closePopButton.enabled = true;
			if(enableUpload)
			{
				uploadToInternetButtonClickHandler();
			}else{
				completeVgroup.visible = true;
				cancelPopButton.enabled = false;
			}
		}
		////////////////////
		private var uploadStartTime:Number;
		private function uploadOpenHandler(e:UploadAlbumEvent):void
		{
			progressTitleLabel.text = e.info;
			var now:Date = new Date();
			uploadStartTime = now.getTime();
		}
		private function uploadProgressHandler(e:UploadAlbumEvent):void
		{
			var progress:Number = Math.round(e.progress / e.totals * 100);
			settingProgressBar(progress);
			/////////
			var now:Date = new Date();
			var uploadCurrentTime:Number = now.getTime();
			var totalTime:Number = (uploadCurrentTime - uploadStartTime) / 1000;
			var totalKB:Number = 0;
			var speed:Number = 0;
			if (totalTime > 1)
			{
				totalKB = e.progress / 1024;
				speed = totalKB / totalTime;
			}
			/////////
			progressInfoLabel.text = "Bytes: " + Math.round(e.progress/1024) + " / " + Math.round(e.totals/1024) + " kb" + "  Speed: " + speed.toFixed(1) + " kb/s";
		}
		private function uploadFinishedHandler(e:UploadAlbumEvent):void
		{
			progressVgroup.visible = false;
			cancelPopButton.enabled = false;
			closePopButton.enabled = true;
			responseVgroup.visible = true;
			viewUplodLogBtn.visible = true;
			albumLinkLabel.visible = true;
			albumLinkLabel.text = e.info;
			navigateToURL(new URLRequest(e.info));
		}
		private function uploadAuthenticateFailed(e:UploadAlbumEvent):void
		{
			var authenticateFailedAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
			//authenticateFailedAlert.tipTitle = "Upload Failed";
			authenticateFailedAlert.tipTitle = LanguageManager.getInstance().getString("41020");
			authenticateFailedAlert.tipInfo = e.info;
			//////////////
			uploadCanceledCompleteHandler();
		}
		private function uploadCanceledCompleteHandler(e:UploadAlbumEvent = null):void
		{
			responseVgroup.visible = true;
			progressVgroup.visible = false;
			cancelPopButton.enabled = false;
			closePopButton.enabled = true;
			//responseTitleLabel.text = "Upload Canceled.";
			responseTitleLabel.text = LanguageManager.getInstance().getString("41018");
			albumLinkLabel.text = "";
		}
		private function uploadFailedHandler(e:UploadAlbumEvent):void
		{
			var uploadFailedAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
			//uploadFailedAlert.tipTitle = "Upload Failed";
			uploadFailedAlert.tipTitle = LanguageManager.getInstance().getString("41020");
			uploadFailedAlert.tipInfo = e.info;
			//////////////
			uploadCanceledCompleteHandler();
		}
		private function fileSizeLimitHandler(e:UploadAlbumEvent):void
		{
			var fileSizeLimitAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
			//fileSizeLimitAlert.tipTitle = "Upload Failed";
			fileSizeLimitAlert.tipTitle = LanguageManager.getInstance().getString("41020");
			fileSizeLimitAlert.tipInfo = e.info;
			//////////////
			uploadCanceledCompleteHandler();
		}
		////////////////////////////////////////////////
		private function cancelPopButtonClickHandler(event:Event):void
		{
			if(cancelPopButton.enabled && cancelPopButton.visible)
			{
				var title:String = LanguageManager.getInstance().getString("41021");
				var info:String = LanguageManager.getInstance().getString("41022");
				Alert.show(info, title, Alert.YES|Alert.NO, this, cancelConfirmHandler);
			}else{
				closePopUpHandler();
			}
		}
		private function cancelConfirmHandler(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)
			{
				if(progressType == "createFile")
				{
					CommandDispatcher.getInstance().dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.FILE_CREATE_CANCEL));
					closePopUpHandler();
				}else if(progressType == "uploadFile"){
					CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.UPLOAD_CANCELED));
				}
			}
		}
		private function closePopUpHandler(event:Event = null):void
		{
			PopUpManager.removePopUp(this);
			removeAllEventListener();
		}
		private function openHtmlFileButtonClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.OPEN_HTML_FILE));
		}
		private function openOutputFolderButtonClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.OPEN_SLIDESHOW_FOLDER));
		}
		private function uploadToInternetButtonClickHandler(event:MouseEvent = null):void
		{
			uploadToInternetButton.removeEventListener(MouseEvent.CLICK, uploadToInternetButtonClickHandler);
			completeVgroup.visible = false;
			uploadHgroup.visible = true;
			cancelPopButton.visible = false;
			uploadButton.visible = true;
			//check go2album user info////
			if(SharedObjectData.getSigninInfo().username == "" || SharedObjectData.getSigninInfo().password == "")
			{
				var signInGo2AlbumCom:SignInGo2AlbumCom = SignInGo2AlbumCom(PopUpManager.createPopUp(this, SignInGo2AlbumCom, true));
			}
			//////////////////////////////
		}
		private function uploadButtonClickHandler(event:MouseEvent):void
		{
			progressType = "uploadFile";
			progressTitleLabel.text = LanguageManager.getInstance().getString("41003");
			progressBar.setProgress(0, 100);
			progressBar.label = "Progress: 0%";
			////////
			uploadHgroup.visible = false;
			progressVgroup.visible = true;
			uploadButton.visible = false;
			cancelPopButton.enabled = true;
			cancelPopButton.visible = true;
			closePopButton.enabled = false;
			//////////////////////////////////
			var albumData:Object = new Object();
			albumData.uploadTitle = albumTileTI.text;
			albumData.uploadDescription = albumDescriptionTI.text;
			albumData.uploadTags = albumTagsTI.text;
			albumPublicRBtn.selected ? albumData.uploadPrivacy = "public" : albumData.uploadPrivacy = "private";
			////////////////
			dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.CREATE_UPLOAD_FILE, albumData));
		}
		private function albumLinkLabelClickHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(albumLinkLabel.text));
		}
		private function viewUplodLogBtnClickHandler(event:MouseEvent):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.OPEN_UPLOAD_LOG));
		}
		private function removeAllEventListener():void
		{
			CommandDispatcher.getInstance().removeEventListener(FileCreateProgressPopupComEvent.FILE_CREATE_PROGRESS, fileCreateProgressHandler);
			CommandDispatcher.getInstance().removeEventListener(FileCreateProgressPopupComEvent.FILE_CREATE_COMPLETE, fileCreateCompleteHandler);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_OPEN, uploadOpenHandler);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_PROGRESS, uploadProgressHandler);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.AUTHENTICATE_FAILED, uploadAuthenticateFailed);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_FINISHED, uploadFinishedHandler);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_CANCELED_COMPLETE, uploadCanceledCompleteHandler);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_FAILED, uploadFailedHandler);
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.FILE_SIZE_LIMIT, fileSizeLimitHandler);
			//////////////
			removeEventListener(CloseEvent.CLOSE, cancelPopButtonClickHandler);
			cancelPopButton.removeEventListener(MouseEvent.CLICK, cancelPopButtonClickHandler);
			closePopButton.removeEventListener(MouseEvent.CLICK, closePopUpHandler);
			openHtmlFileButton.removeEventListener(MouseEvent.CLICK, openHtmlFileButtonClickHandler);
			openOutputFolderButton.removeEventListener(MouseEvent.CLICK, openOutputFolderButtonClickHandler);
			uploadToInternetButton.removeEventListener(MouseEvent.CLICK, uploadToInternetButtonClickHandler);
			uploadButton.removeEventListener(MouseEvent.CLICK, uploadButtonClickHandler);
			albumLinkLabel.removeEventListener(MouseEvent.CLICK, albumLinkLabelClickHandler);
			viewUplodLogBtn.removeEventListener(MouseEvent.CLICK, viewUplodLogBtnClickHandler);
			///////////
			progressVgroup = null;
			completeVgroup = null;
			uploadHgroup = null;
			responseVgroup = null;
			progressBar = null;
			openHtmlFileButton = null;
			openOutputFolderButton = null;
			uploadToInternetButton = null;
			cancelPopButton = null;
			closePopButton = null;
			uploadButton = null;
			progressTitleLabel = null;
			progressInfoLabel = null;
			albumPublicRBtn = null;
			albumTileTI = null;
			albumDescriptionTI = null;
			albumTagsTI = null;
			responseTitleLabel = null;
			albumLinkLabel = null;
			viewUplodLogBtn = null;
			
		}
		
	}
}