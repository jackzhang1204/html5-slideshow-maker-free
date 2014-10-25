package com.anvsoft.components.header
{
	import com.anvsoft.components.header.popup.menu.AboutCom;
	import com.anvsoft.components.header.popup.menu.OptionSettingCom;
	import com.anvsoft.components.header.popup.menu.SignInGo2AlbumCom;
	import com.anvsoft.utils.language.LanguageManager;
	import com.anvsoft.events.CommandDispatcher;
	import com.anvsoft.events.ConfigFileEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.MenuBar;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	
	public class HSMHeaderAS extends Group
	{
		public var menuBar:MenuBar;
		public var appWinControlButton:HGroup;
		public var closeAppButton:Button;
		public var minimizeAppButton:Button;
		public var maximizeAppButton:Button;
		public var restoreAppButton:Button;
		public var appWinConBtnRollOutBg:Image;
		public var appWinConBtnRollOverBg:Image;
		public var appWinConBtnDisableBg:Image;
		public var headBackground:Group;
		public var upgradeButtonHG:HGroup;
		public var upgradeButton:Button;
		[Bindable]
		public var title:String = AppMain.NAME;
		private var helpFielName:String = "HTML5 Slideshow Maker Help";
		public function HSMHeaderAS()
		{
			super();
			/////////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			////////////
			menuBar.addEventListener(MenuEvent.ITEM_CLICK, menuBarItemClickHandler);
			appWinControlButton.addEventListener(MouseEvent.CLICK, appWinControlButtonClickHandler);
			appWinControlButton.addEventListener(MouseEvent.ROLL_OVER, appWinControlButtonRollHandler);
			appWinControlButton.addEventListener(MouseEvent.ROLL_OUT, appWinControlButtonRollHandler);
			headBackground.addEventListener(MouseEvent.MOUSE_DOWN, headBackgroundMouseDownHandler);
			headBackground.addEventListener(MouseEvent.DOUBLE_CLICK, headBackgroundDoubleClickHandler);
			////////////////////////////
			if(AppMain.isFree)
			{
				upgradeButton.addEventListener(MouseEvent.CLICK, upgradeButtonClickHandler);
				LanguageManager.getInstance().binding(upgradeButton, "label", "10006");
			}else{
				this.removeElement(upgradeButtonHG);
				upgradeButtonHG = null;
				upgradeButton = null;
			}
		}
		private function upgradeButtonClickHandler(e:MouseEvent):void
		{
			openWebsite(AppMain.UPGRADELINK);
		}
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			////////////
			stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, nativeWindowResizeHandler);
			stage.nativeWindow.addEventListener(Event.ACTIVATE, nativeWindowActivateHandler);
			stage.nativeWindow.addEventListener(Event.DEACTIVATE, nativeWindowActivateHandler);
		}
		private function nativeWindowActivateHandler(e:Event):void
		{
			switch(e.type)
			{
				case "activate":
					appWinConBtnDisableBg.visible = false;
					appWinConBtnRollOutBg.visible = true;
					break;
				case "deactivate":
					appWinConBtnDisableBg.visible = true;
					appWinConBtnRollOutBg.visible = false;
					break;
				default:
			}
		}
		private function appWinControlButtonRollHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case "rollOver":
					appWinConBtnRollOverBg.visible = true;
					break;
				case "rollOut":
					appWinConBtnRollOverBg.visible = false;
					break;
				default:
			}
		}
		private function headBackgroundMouseDownHandler(e:MouseEvent):void
		{
			if(e.target == e.currentTarget)
			{
				stage.nativeWindow.startMove();
			}
		}
		private function headBackgroundDoubleClickHandler(e:MouseEvent):void
		{
			if(e.target == e.currentTarget)
			{
				if(stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
				{
					stage.nativeWindow.restore();
				}else{
					stage.nativeWindow.maximize();
				}
			}
		}
		private function menuBarItemClickHandler(e:MenuEvent):void
		{
			var item:String = e.item.@data;
			openMenuItem(item);
		}
		private function openMenuItem(item:String):void
		{
			switch(item)
			{
				case "createGo2AlbumAccount":
					openWebsite(AppMain.global_go2album_register_url);
					break;
				case "signInGo2Album":
					openSignInSetting();
					break;
				case "options":
					openOptionsSetting();
					break;
				//////////////////////
				case "help":
					openHelpFile();
					break;
				case "website":
					openWebsite(AppMain.WEBSITE);
					break;
				case "visitGo2Album":
					openWebsite(AppMain.global_go2album_url);
					break;
				case "upgrade":
					openWebsite(AppMain.UPGRADELINK);
					break;
				case "about":
					openAbout();
					break;
				
				//support languages: da_DK de_DE en_US es_ES fi_FI fr_FR it_IT ja_JP ko_KR nb_NO nl_NL ru_RU sv_SE pt_BR zh_CN zh_TW
				case "es_ES":  case "it_IT":  case "en_US":  case "de_DE":  case "fr_FR":  case "ja_JP":  case "zh_CN":  case "zh_TW":
					settingLanguage(item);
					break;
				default:
				
			}
		}
		private function openSignInSetting():void
		{
			var signInGo2AlbumCom:SignInGo2AlbumCom = SignInGo2AlbumCom(PopUpManager.createPopUp(this, SignInGo2AlbumCom, true));
		}
		private function openOptionsSetting():void
		{
			var optionsSettingCom:OptionSettingCom = OptionSettingCom(PopUpManager.createPopUp(this, OptionSettingCom, true));
		}
		private function openHelpFile():void
		{
			var helpPath:String;
			if(AppMain.global_system_os == "Mac")
			{
				helpPath = AppMain.global_app_assets_folder + helpFielName + ".pdf";
			}else{
				helpPath =  AppMain.global_app_assets_folder + helpFielName + ".chm";
			}
			var helpFile:File = AppMain.global_app_storage_directory.resolvePath(helpPath);
			if(helpFile.exists == false)
			{
				var sourceHelpFile:File = AppMain.global_app_directory.resolvePath(helpPath);
				sourceHelpFile.copyTo(helpFile, true);
			}
			helpFile.openWithDefaultApplication();
		}
		private function openWebsite(url:String):void
		{
			navigateToURL(new URLRequest(url));
		}
		private function openAbout():void
		{
			var aboutCom:AboutCom = AboutCom(PopUpManager.createPopUp(this, AboutCom, true));
			
		}
		///////////////////////////////////
		private function appWinControlButtonClickHandler(e:MouseEvent):void
		{
			controlAppWindow(e.target.id);
		}
		private function controlAppWindow(id:String):void
		{
			switch(id)
			{
				case "minimizeAppButton":
					stage.nativeWindow.minimize();
					break;
				
				case "maximizeAppButton":
					stage.nativeWindow.maximize();
					break;
				
				case "restoreAppButton":
					stage.nativeWindow.restore();
					break;
				
				case "closeAppButton":
					stage.nativeWindow.close();
					break;
				default:
					
			}
		}
		private function nativeWindowResizeHandler(e:NativeWindowBoundsEvent):void
		{
			var winState:String = e.target.displayState;
			switch(winState)
			{
				case NativeWindowDisplayState.NORMAL:
					restoreAppButton.visible = false;
					maximizeAppButton.visible = true;
					break;
				
				case NativeWindowDisplayState.MAXIMIZED:
					restoreAppButton.visible = true;
					maximizeAppButton.visible = false;
					break;
				
				default:
					
			}
		}
		private function settingLanguage(languageName:String):void
		{
			LanguageManager.getInstance().changeLanguage(languageName);
			AppMain.global_current_language = languageName;
			CommandDispatcher.getInstance().dispatchEvent(new ConfigFileEvent(ConfigFileEvent.SAVE_CONFIG_FILE));
		}
		
	}
}