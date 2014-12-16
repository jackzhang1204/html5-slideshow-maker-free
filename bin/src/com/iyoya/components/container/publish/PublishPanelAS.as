package com.iyoya.components.container.publish
{
	import com.iyoya.components.AppAlertCom;
	import com.iyoya.components.container.publish.popup.FileCreateProgressPopupCom;
	import com.iyoya.components.container.publish.popup.FileOverwritePopupCom;
	import com.iyoya.data.SlidesDataParser;
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.ConfigFileEvent;
	import com.iyoya.events.components.container.photo.preview.PreviewPanelComEvent;
	import com.iyoya.events.components.container.publish.UploadAlbumEvent;
	import com.iyoya.events.components.container.publish.popup.FileCreateProgressPopupComEvent;
	import com.iyoya.events.components.container.theme.basic.properties.PropertiesPanelComEvent;
	import com.iyoya.utils.file.FileCompress;
	import com.iyoya.utils.file.FileManager;
	import com.iyoya.utils.file.FileUpload;
	import com.iyoya.utils.string.StringUtils;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButton;
	import spark.components.TextInput;
	public class PublishPanelAS extends Group
	{
		public var outputFolderTextInput:TextInput;
		public var selectOutputFolderButton:Button;
		public var openOutputFolderButton:Button;
		public var htmlFileNameTextInput:TextInput;
		public var jsFileNameTextInput:TextInput;
		public var xmlFileNameTextInput:TextInput;
		public var publishButton:Button;
		public var createFileOnlyRBtn:RadioButton;
		public var createFileAndUploadRBtn:RadioButton;
		public var outputDescriptionLabel:Label
		
		public var outputOptionsLabel:Label;
		public var descriptionLabel:Label;
		public var outputSettingsLabel:Label;
		public var outputFolderLabel:Label;
		public var htmlFileNameLabel:Label;
		public var jsFileNameLabel:Label;
		public var xmlFileNameLabel:Label;
		
		////////////////
		private var slidesDataParser:SlidesDataParser;
		private var fileManager:FileManager;
		private var outputFolderFile:File;
		private var slideshowFloderFile:File;
		private var tempFolderFile:File;
		private var indexHtmlFile:File;
		private var uploadLogHtmlFile:File;
		private var slidesXmlData:XML;
		private var slideshowFolderName:String;
		private var fsmFooterHtmlString:String = '<div class="text_createdby"><p><a href="http://www.html5-slideshow-maker.com" target="_blank">Created by HTML5 Slideshow Maker</a></p></div>';
		private var embedTipHtmlString:String = '<p><strong>Tip:</strong> Upload all the published files to the same folder of your website, then copy and paste the "embed code" below to your webpage to embed this html5 slideshow on your website.</p><p><strong>Embed Code:</strong></p>';
		private var uploadToInternet:Boolean = false;
		
		public function PublishPanelAS()
		{
			super();
			///////////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			///////////////////////
			slidesDataParser = new SlidesDataParser();
			fileManager = new FileManager();
			/////////
			outputFolderFile = AppMain.global_output_directory;
			outputFolderTextInput.text = outputFolderFile.nativePath;
			tempFolderFile = AppMain.global_temp_directory;
			/////////////////
			selectOutputFolderButton.addEventListener(MouseEvent.CLICK, selectOutputFolderButtonClickHandler);
			openOutputFolderButton.addEventListener(MouseEvent.CLICK, openOutputFolderButtonClickHandler);
			publishButton.addEventListener(MouseEvent.CLICK, publishButtonClickHandler);
			createFileOnlyRBtn.addEventListener(MouseEvent.CLICK, outputOptionsClickHandler);
			createFileAndUploadRBtn.addEventListener(MouseEvent.CLICK, outputOptionsClickHandler);
			////////////////
			CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.SAVE_UPLOAD_LOG, saveUploadLogHandler);
			CommandDispatcher.getInstance().addEventListener(FileCreateProgressPopupComEvent.OPEN_UPLOAD_LOG, openUploadLogHandler);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(outputOptionsLabel, "text", "40002");
			LanguageManager.getInstance().binding(createFileOnlyRBtn, "label", "40003");
			LanguageManager.getInstance().binding(createFileAndUploadRBtn, "label", "40004");
			LanguageManager.getInstance().binding(descriptionLabel, "text", "21003");
			LanguageManager.getInstance().binding(outputDescriptionLabel, "text", "40005");
			LanguageManager.getInstance().binding(outputSettingsLabel, "text", "40007");
			LanguageManager.getInstance().binding(outputFolderLabel, "text", "40008");
			LanguageManager.getInstance().binding(htmlFileNameLabel, "text", "40009");
			LanguageManager.getInstance().binding(jsFileNameLabel, "text", "40010");
			LanguageManager.getInstance().binding(xmlFileNameLabel, "text", "40011");
			LanguageManager.getInstance().binding(publishButton, "label", "40012");
			LanguageManager.getInstance().binding(selectOutputFolderButton, "label", "10003");
			LanguageManager.getInstance().binding(openOutputFolderButton, "label", "10004");
		}
		private function outputOptionsClickHandler(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "createFileOnly":
					uploadToInternet = false;
					outputDescriptionLabel.text = LanguageManager.getInstance().getString("40005");
					break;
				case "createFileAndUpload":
					uploadToInternet = true;
					outputDescriptionLabel.text = LanguageManager.getInstance().getString("40006");
					break;
				default:
			}
		}
		private function selectOutputFolderButtonClickHandler(e:MouseEvent):void
		{
			var inputFile:File = new File(outputFolderTextInput.text);
			if(inputFile.exists == true)
			{
				outputFolderFile = inputFile;
			}
			outputFolderFile.browseForDirectory("Select Directory");
			outputFolderFile.addEventListener(Event.SELECT, directorySelectedHandler);
		}
		private function directorySelectedHandler(e:Event):void
		{
			outputFolderTextInput.text = outputFolderFile.nativePath;
			if(AppMain.global_output_directory_path != outputFolderFile.nativePath)
			{
				AppMain.global_output_directory_path = outputFolderFile.nativePath;
				CommandDispatcher.getInstance().dispatchEvent(new ConfigFileEvent(ConfigFileEvent.SAVE_CONFIG_FILE));
			}
		}
		private function openOutputFolderButtonClickHandler(e:MouseEvent):void
		{
			fileManager.openFileWithDefaultApp(outputFolderFile, "F");
		}
		private function publishButtonClickHandler(e:MouseEvent):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new PropertiesPanelComEvent(PropertiesPanelComEvent.GET_PROPERTIES_PANEL_DATA));
			CommandDispatcher.getInstance().dispatchEvent(new PreviewPanelComEvent(PreviewPanelComEvent.GET_ALBUM_DATA_PARSER));
			//check file name/////////////////
			slideshowFolderName = checkFileNameForTextInput(htmlFileNameTextInput, ".html");
			checkFileNameForTextInput(xmlFileNameTextInput, ".xml");
			checkFileNameForTextInput(jsFileNameTextInput, ".js");
			//////////////////////////////////
			slidesXmlData = slidesDataParser.getXmlData();
			if(slidesXmlData)
			{
				createOutputFolder();
			}else{
				var noImageAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
				noImageAlert.tipTitle = "HTML5 Slideshow Maker";
				noImageAlert.tipInfo = LanguageManager.getInstance().getString("42005");
			}
		}
		private function createOutputFolder():void
		{
			//check and create output floder//
			try
			{
				outputFolderFile = new File(outputFolderTextInput.text);
				if(outputFolderFile.exists == false)
				{
					outputFolderFile.createDirectory();
				}
				
				if(AppMain.global_output_directory_path != outputFolderFile.nativePath)
				{
					AppMain.global_output_directory_path = outputFolderFile.nativePath;
					CommandDispatcher.getInstance().dispatchEvent(new ConfigFileEvent(ConfigFileEvent.SAVE_CONFIG_FILE));
				}
				
			}catch(e:Error){
				var directoryError:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
				directoryError.tipTitle = "HTML5 Slideshow Maker";
				directoryError.tipInfo = LanguageManager.getInstance().getString("42006");
				return;
				
			}
			slideshowFloderFile = outputFolderFile.resolvePath(slideshowFolderName);
			if(slideshowFloderFile.exists == false)
			{
				slideshowFloderFile.createDirectory();
				/////////
				fileCreateProgessPopup();
			}else{
				fileOverwritePopup();
			}
		}
		private function fileOverwritePopup():void
		{
			var fileOverwritePopupCom:FileOverwritePopupCom = FileOverwritePopupCom(PopUpManager.createPopUp(this, FileOverwritePopupCom , true));
			fileOverwritePopupCom.floderPath = slideshowFloderFile.nativePath;
			fileOverwritePopupCom.addEventListener("yesButtonClick", fileOverwritePopupClickHandler);
		}
		private function fileOverwritePopupClickHandler(e:Event):void
		{
			fileCreateProgessPopup();
		}
		private function fileCreateProgessPopup():void
		{
			var fileCreateProgressPopupCom:FileCreateProgressPopupCom = FileCreateProgressPopupCom(PopUpManager.createPopUp(this, FileCreateProgressPopupCom , true));
			fileCreateProgressPopupCom.enableUpload = uploadToInternet;
			fileCreateProgressPopupCom.addEventListener(FileCreateProgressPopupComEvent.POPUP_CREATION_COMPLETE, progessPopupComCreationComplete);
			fileCreateProgressPopupCom.addEventListener(FileCreateProgressPopupComEvent.OPEN_HTML_FILE, openHtmlFileHandler);
			fileCreateProgressPopupCom.addEventListener(FileCreateProgressPopupComEvent.OPEN_SLIDESHOW_FOLDER, openSlideshowFolderHandler);
			fileCreateProgressPopupCom.addEventListener(UploadAlbumEvent.CREATE_UPLOAD_FILE, createUploadFileHandler);
		}
		private function progessPopupComCreationComplete(e:FileCreateProgressPopupComEvent):void
		{
			createSlideshowFloder();
		}
		private function openHtmlFileHandler(e:FileCreateProgressPopupComEvent):void
		{
			fileManager.openFileWithDefaultApp(indexHtmlFile, "S");
		}
		private function openSlideshowFolderHandler(e:FileCreateProgressPopupComEvent):void
		{
			fileManager.openFileWithDefaultApp(slideshowFloderFile, "F");
		}
		private function createUploadFileHandler(e:UploadAlbumEvent):void
		{
			createTempFileAndUpload(e.data);
		}
		private function saveUploadLogHandler(e:UploadAlbumEvent):void
		{
			uploadLogHtmlFile = tempFolderFile.parent.resolvePath("upload.html");
			var htmlLink:String = e.info;
			var uploadLogStr:String;
			if(!uploadLogHtmlFile.exists)
			{
				uploadLogStr = '<p style="font-family: Verdana, Arial, Helvetica, sans-serif;color: #006633;font-weight: bold;">upload successfully! </p>'
							 + '\n' + '<p style="font-family: Verdana, Arial, Helvetica, sans-serif;color: #006699;font-weight: bold;">html link</span>: <a href="' + htmlLink + '">' + htmlLink + '</a> </p>'
			}else{
				uploadLogStr = '\n' + '<p style="font-family: Verdana, Arial, Helvetica, sans-serif;color: #006699;font-weight: bold;">html link</span>: <a href="' + htmlLink + '">' + htmlLink + '</a> </p>'
			}
			fileManager.appendWritedUtfBytes(uploadLogHtmlFile, uploadLogStr);
		}
		private function openUploadLogHandler(e:FileCreateProgressPopupComEvent):void
		{
			fileManager.openFileWithDefaultApp(uploadLogHtmlFile, "S");
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function createSlideshowFloder():void
		{
			copyFiles();
			saveXmlFile(slidesXmlData);
			createHtmlFile();
		}
		private function copyFiles():void
		{
			var sourceFolderPath:String = AppMain.global_app_assets_folder + slidesDataParser.sourceFolderPath;
			var sourceJsFilePath:String = slidesDataParser.sourceJsFilePath;
			
			//1.copy source folder///////////////
			var destinationSourceFile:File = slideshowFloderFile;
			var sourceFolderFile:File = AppMain.global_app_directory.resolvePath(sourceFolderPath);
			fileManager.copyFile(sourceFolderFile, destinationSourceFile);
			//rename js file////
			if(jsFileNameTextInput.text != sourceJsFilePath)
			{
				var sourceJsFile:File = destinationSourceFile.resolvePath(sourceJsFilePath);
				var destinationJsFile:File = destinationSourceFile.resolvePath(jsFileNameTextInput.text);
				fileManager.moveFile(sourceJsFile, destinationJsFile);
			}
			
			//2.copy preloader files//////////////
			var sourcePreloaderFilePath:String = AppMain.global_app_assets_folder + slidesDataParser.preloaderPathBase + slidesDataParser.preloaderName;
			var destinationPreloaderFilePath:String = slidesDataParser.outputResFolderPath + slidesDataParser.preloaderName;
			var destinationPreloaderFile:File = slideshowFloderFile.resolvePath(destinationPreloaderFilePath);
			var sourcePreloaderFile:File = AppMain.global_app_directory.resolvePath(sourcePreloaderFilePath);
			fileManager.copyFile(sourcePreloaderFile, destinationPreloaderFile);
			
			//3.copy image files////////////////
			var imageURLArray:Array = slidesDataParser.imageURLArray;
			fileManager.saveWritedImageWithArray(slideshowFloderFile, imageURLArray);
			
		}
		private function saveXmlFile(xmlData:XML):void
		{
			var slidesXmlFile:File = new File(slideshowFloderFile.resolvePath(xmlFileNameTextInput.text).nativePath);
			fileManager.saveWritedUtfBytes(slidesXmlFile, xmlData, "xml");
			//2012.11.5 save data.js file////////////////////////////////////
			var dataJsStr:String = xmlData.toString();
			var pattern:RegExp = /\n/g;
			dataJsStr =  dataJsStr.replace(pattern, "");
			dataJsStr = "var anvsoftJavaScriptSlideshowData = '" + StringUtils.ConvertJsSpecialChar(dataJsStr) + "';";
			var dataJsFile:File = new File(slideshowFloderFile.resolvePath("data.js").nativePath);
			fileManager.saveWritedUtfBytes(dataJsFile, dataJsStr);
			/////////////////////////////////////////////////////////////////
		}
		private function createHtmlFile():void
		{
			var fs_auxHtmlPath:String = AppMain.global_app_assets_folder + slidesDataParser.httPathBase + slidesDataParser.auxHttFile;
			var indexHtmlPath:String = AppMain.global_app_assets_folder + slidesDataParser.httPathBase + slidesDataParser.indexHttFile;
			var fsauxSourceHtmlFile:File = AppMain.global_app_directory.resolvePath(fs_auxHtmlPath);
			var indexHtmlSourceFile:File = AppMain.global_app_directory.resolvePath(indexHtmlPath);
			var fsauxHtmlFileStr:String = fileManager.readOpenFile(fsauxSourceHtmlFile);
			var indexHtmlFileStr:String = fileManager.readOpenFile(indexHtmlSourceFile);
			//setting variable value/////////
			var encoding:String = "UTF-8";
			var albumTitle:String = slidesDataParser.htmlTitle;
			var mainSWF:String = jsFileNameTextInput.text + "?xml_path=" + xmlFileNameTextInput.text;
			var movieWidth:String = AppMain.global_movie_width + "px";
			var movieHeight:String = AppMain.global_movie_height + "px";
			//replace variable/////////////////
			var charsetPattern:RegExp = /\$Encoding/g;
			fsauxHtmlFileStr = fsauxHtmlFileStr.replace(charsetPattern, encoding);
			indexHtmlFileStr = indexHtmlFileStr.replace(charsetPattern, encoding);
			var albumTitlePattern:RegExp = /\$AlbumTitle/g;
			fsauxHtmlFileStr = fsauxHtmlFileStr.replace(albumTitlePattern, albumTitle);
			indexHtmlFileStr = indexHtmlFileStr.replace(albumTitlePattern, albumTitle);
			var mainSWFPattern:RegExp = /\$MainSWF/g;
			fsauxHtmlFileStr = fsauxHtmlFileStr.replace(mainSWFPattern, mainSWF);
			indexHtmlFileStr = indexHtmlFileStr.replace(mainSWFPattern, mainSWF);
			var movieWidthPattern:RegExp = /\$MovieWidth/g;
			fsauxHtmlFileStr = fsauxHtmlFileStr.replace(movieWidthPattern, movieWidth);
			indexHtmlFileStr = indexHtmlFileStr.replace(movieWidthPattern, movieWidth);
			var movieHeightPattern:RegExp = /\$MovieHeight/g;
			fsauxHtmlFileStr = fsauxHtmlFileStr.replace(movieHeightPattern, movieHeight);
			indexHtmlFileStr = indexHtmlFileStr.replace(movieHeightPattern, movieHeight);
			var fsm_FooterPattern:RegExp = /\$FSM_Footer/g;
			fsmFooterHtmlString = LanguageManager.getInstance().getString("42007");
			indexHtmlFileStr = indexHtmlFileStr.replace(fsm_FooterPattern, fsmFooterHtmlString);
			var embedTipPattern:RegExp = /\$EmbedTip/g;
			embedTipHtmlString = LanguageManager.getInstance().getString("42008");
			indexHtmlFileStr = indexHtmlFileStr.replace(embedTipPattern, embedTipHtmlString);
			//save html file///
			var fsauxHtmlFile:File = slideshowFloderFile.resolvePath(slidesDataParser.auxHtmlFile);
			fileManager.saveWritedUtfBytes(fsauxHtmlFile, fsauxHtmlFileStr);
			indexHtmlFile = slideshowFloderFile.resolvePath(htmlFileNameTextInput.text);
			fileManager.saveWritedUtfBytes(indexHtmlFile, indexHtmlFileStr);
			
		}
		private function createTempFileAndUpload(albumData:Object):void
		{
			if(tempFolderFile.exists == false)
			{
				tempFolderFile.createDirectory();
			}
			//1.create Go2Album thumbnail///////
			var go2AlbumThumFile:File = tempFolderFile.resolvePath("Go2Album_thumbnail.jpg");
			fileManager.saveGo2AlbumThumImg(go2AlbumThumFile);
			//2.create album config file//////////
			var albumConfigFile:File = tempFolderFile.resolvePath("xoxo.xml");
			fileManager.saveAlbumConfigFile(albumConfigFile);
			//3.compress slideshowFloderFile////
			var fileCompress:FileCompress = new FileCompress(slideshowFloderFile, tempFolderFile, ["data.js"]);
			var outputZipFile:File = fileCompress.compress("upload", [go2AlbumThumFile, albumConfigFile]);
			//4.upload zip file/////////////////
			var albumFileUpload:FileUpload = new FileUpload(outputZipFile, albumData);
			albumFileUpload.upload();
			
		}
		////////////////////////////////////
		private function checkFileNameForTextInput($textInput:TextInput, $fileType:String = ".html"):String
		{
			var fileName:String;
			var textInputValue:String = $textInput.text;
			//Clear Illegal Characters For File Name////
			textInputValue = StringUtils.ClearIllegalCharacters(textInputValue);
			var dotIndex:int = textInputValue.lastIndexOf(".");
			var fileExtension:String = textInputValue.substring(dotIndex);
			var firstChar:String = textInputValue.charAt(0);
			if(dotIndex > 0 && fileExtension == $fileType && firstChar != " ")
			{
				fileName = textInputValue.substring(0, dotIndex);
			}else{
				if(textInputValue == "" || firstChar == " ")
				{
					switch($fileType)
					{
						case ".html":
							fileName = AppMain.global_slideshow_name;
							break;
						case ".xml":
							fileName = "slides";
							break;
						case ".js":
							fileName = "anvsoftJavaScriptSlideshow-1.0.0.min";
							break;
						default:
							fileName = AppMain.global_slideshow_name;
					}
				}else{
					fileName = textInputValue;
				}
			}
			$textInput.text = fileName + $fileType;
			return fileName;
		}
	}
}