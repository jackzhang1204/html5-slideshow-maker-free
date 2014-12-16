package com.iyoya.utils.file
{
	import com.iyoya.components.AppAlertCom;
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.publish.popup.FileCreateProgressPopupComEvent;
	import com.iyoya.utils.display.getDisplayObjectSameRatioBitmapData;
	import com.iyoya.utils.string.StringUtils;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class FileManager
	{
		private var imgLoader:Loader;
		private var jpgEncoderOptions:JPEGEncoderOptions;
		private var slideshowFloderFile:File;
		private var imageURLArray:Array;
		private var imgIndex:uint = 0;
		private var imgTotals:uint = 1;
		private var state:Boolean = true;
		private var process:NativeProcess;
		private var go2albumThumBytes:ByteArray;
		
		public function FileManager()
		{
			jpgEncoderOptions = new JPEGEncoderOptions();
			/////////////////
			CommandDispatcher.getInstance().addEventListener(FileCreateProgressPopupComEvent.FILE_CREATE_CANCEL, fileCreateCancelHandler);
		}
		private function fileCreateCancelHandler(e:FileCreateProgressPopupComEvent):void
		{
			state = false;
		}
		public function openFileWithDefaultApp($file:File, $type:String = "S"):void
		{
			if(AppMain.global_system_os == "Mac")
			{
				if(NativeProcess.isSupported)
				{
					if(process && process.running)
					{
						process.exit(true);
					}else{
						try
						{
							var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
							var processLocalPath:String = AppMain.global_app_assets_folder + "toview";
							var processFile:File = AppMain.global_app_directory.resolvePath(processLocalPath);
							nativeProcessStartupInfo.executable = processFile;
							var processArgs:Vector.<String> = new Vector.<String>();
							processArgs.push($type);
							processArgs.push($file.nativePath);
							/*if($type == "S")
							{
								//processArgs.push("--disable-web-security");
								//processArgs.push("--disable-web-security --disable-caches");
								//processArgs.push("--disable-local-file-restrictions");
							}*/
							nativeProcessStartupInfo.arguments = processArgs;
							process = new NativeProcess();
							process.start(nativeProcessStartupInfo);
						}catch(e:Error){
							//trace("Process Startup Error");
							var processAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
							processAlert.tipTitle = "Toview Process Startup Error";
							processAlert.tipInfo = "Open fail: " + $file.nativePath;
						}
					}
				}else{
					$file.openWithDefaultApplication();
				}
			}else{
				$file.openWithDefaultApplication();
			}
		}
		public function clearFolder(file:File):void
		{
			var fileList:Array = file.getDirectoryListing();
			for (var i:uint = 0; i < fileList.length; i++) {
				if(fileList[i].isDirectory)
				{
					fileList[i].deleteDirectory(true);
				}else{
					fileList[i].deleteFile();
				}
			}
		}
		public function copyFile(sourceFile:File, destinationFile:File):void
		{
			try{
				sourceFile.copyTo(destinationFile, true);
			}catch(e:Error){
				//trace("Error Overwrite File");
				var overwriteErrorAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp((FlexGlobals.topLevelApplication as DisplayObject), AppAlertCom, true));
				overwriteErrorAlert.tipTitle = "Error Overwrite File";
				overwriteErrorAlert.tipInfo = "Cannot overwrite file(folder), please close the file(folder) first.";
			}
		}
		public function moveFile(sourceFile:File, destinationFile:File):void
		{
			try{
				sourceFile.moveTo(destinationFile, true);
			}catch(e:Error){
				//trace("Error Move/Rename File");
				var moveFileErrorAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp((FlexGlobals.topLevelApplication as DisplayObject), AppAlertCom, true));
				moveFileErrorAlert.tipTitle = "Error Move/Rename File";
				moveFileErrorAlert.tipInfo = "Cannot move/rename open file(folder), please close the file(folder) first.";
			}
		}
		public function saveWritedUtfBytes(file:File, data:String, type:String = ""):void
		{
			var head:String = "";
			switch(type)
			{
				case "xml":
					head = '<?xml version="1.0" encoding="UTF-8" ?> \n';
					break;
				
				default:
					
			}
			var fileString:String = head + data;
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.position = 0;
			fileStream.writeUTFBytes(fileString);
			fileStream.close();
		}
		public function appendWritedUtfBytes(file:File, data:String):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.APPEND);
			fileStream.writeUTFBytes(data);
			fileStream.close();
		}
		public function readOpenFile(file:File):String
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var fileString:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			return fileString;
		}
		public function saveWritedImageWithArray($file:File, $imageURLArray:Array):void
		{
			slideshowFloderFile = $file;
			imageURLArray = $imageURLArray;
			imgIndex = 0;
			imgTotals = imageURLArray.length;
			state = true;
			////////////////
			saveWritedImage(imageURLArray[imgIndex]);
		}
		public function saveWritedImage(url:String):void
		{
			if(state)
			{
				imgLoader = new Loader();
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadCompleteHandler);
				imgLoader.load(new URLRequest(url));
			}
		}
		public function saveGo2AlbumThumImg(file:File):void
		{
			saveWriteBytes(file, go2albumThumBytes);
		}
		public function saveAlbumConfigFile(file:File):void
		{
			var albumConfigXml:XML = <Config>
									 	<MainFileType type="js" />
									 </Config>;
			saveWritedUtfBytes(file, albumConfigXml, "xml");
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		private function imageLoadCompleteHandler(e:Event):void
		{
			var indexStr:String = StringUtils.GetLeadingZeroString((imgIndex + 1), 4);
			////////////////
			var target:DisplayObject = e.target.content;
			var photoWidth:Number = AppMain.global_photo_width;
			var photoHeight:Number = AppMain.global_photo_height;
			var thumWidth:Number = AppMain.global_thum_width;
			var thumHeight:Number = AppMain.global_thum_height;
			var quality:Number = AppMain.global_jpeg_quality;
			
			var photoFillStyle:String = AppMain.global_photo_fill_style;
			var photoFillColor:uint = AppMain.global_photo_fill_color;
			var photoFillTransparent:Boolean = false;
			
			var thumFillStyle:String = AppMain.global_thum_fill_style;
			var thumFillColor:uint = AppMain.global_thum_fill_color;
			var thumFillTransparent:Boolean = false;
			///////////////////////
			var photoBitmapData:BitmapData = getDisplayObjectSameRatioBitmapData(target, photoWidth, photoHeight, photoFillStyle, photoFillColor, photoFillTransparent);
			jpgEncoderOptions.quality = quality;
			var photoBytes:ByteArray = photoBitmapData.encode(photoBitmapData.rect, jpgEncoderOptions);
			
			var photoImgFile:File = slideshowFloderFile.resolvePath("slides/" + "p_" + indexStr + ".jpg");
			saveWriteBytes(photoImgFile, photoBytes);
			if(thumWidth>0 && thumHeight>0)
			{
				var thumBitmapData:BitmapData = getDisplayObjectSameRatioBitmapData(target, thumWidth, thumHeight, thumFillStyle, thumFillColor, thumFillTransparent);
				var thumBytes:ByteArray = thumBitmapData.encode(thumBitmapData.rect, jpgEncoderOptions);
				
				var thumImgFile:File = slideshowFloderFile.resolvePath("thumbs/" + "t_" + indexStr + ".jpg");
				saveWriteBytes(thumImgFile, thumBytes);
			}
			//get go2album thumbnail ByteArray////
			if(imgIndex == 0)
			{
				var go2albumThumBmpData:BitmapData = getDisplayObjectSameRatioBitmapData(target, 120, 90, "fill", 0x000000, false);
				jpgEncoderOptions.quality = 100;
				go2albumThumBytes = go2albumThumBmpData.encode(go2albumThumBmpData.rect, jpgEncoderOptions);
			}
			//////////////////////////////////////
			imgIndex++;
			CommandDispatcher.getInstance().dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.FILE_CREATE_PROGRESS, imgIndex, imgTotals));
			if(imgIndex < imgTotals)
			{
				saveWritedImage(imageURLArray[imgIndex]);
			}else{
				CommandDispatcher.getInstance().dispatchEvent(new FileCreateProgressPopupComEvent(FileCreateProgressPopupComEvent.FILE_CREATE_COMPLETE));
				//remove imgLoader//////////////
				imgLoader.unload();
				imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoadCompleteHandler);
				imgLoader = null;
			}
		}
		private function saveWriteBytes(file:File, data:ByteArray):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.position = 0;
			fileStream.writeBytes(data);
			fileStream.close();
		}
		
		//static function///////////////////
		public static function getDirectoryInfo($directory:File, $includeDirectory:Boolean = false, $extensions:Vector.<String> = null):Object
		{
			if($extensions == null)
			{
				$extensions = new <String>["jpg, jpeg"];
			}
			var fileInfo:Object = new Object();
			var fileURLVector:Vector.<String> = new Vector.<String>();
			var fileNameVector:Vector.<String> = new Vector.<String>();
			fileInfo.url = fileURLVector;
			fileInfo.name = fileNameVector;
			var fileList:Array = $directory.getDirectoryListing();
			var fileLen:uint = fileList.length;
			for (var i:uint = 0; i < fileLen; i++)
			{
				var fileHide:Boolean = fileList[i].isHidden;
				var filePackage:Boolean = fileList[i].isPackage;
				if(!fileHide && !filePackage)
				{
					var isDirectory:Boolean = fileList[i].isDirectory;
					var fileExtension:String = fileList[i].extension;
					if(fileExtension != null)
					{
						fileExtension = fileExtension.toLowerCase();
					}
					var includeExtension:Boolean = false;
					var extenLen:uint = $extensions.length;
					for(var j:uint = 0; j < extenLen; j++)
					{
						if(fileExtension == $extensions[j])
						{
							includeExtension = true;
							break;
						}
					}
					if((isDirectory && $includeDirectory) || includeExtension)
					{
						fileURLVector.push(fileList[i].url);
						fileNameVector.push(fileList[i].name);
					}
				}
			}
			return fileInfo;
		}
		public static function getShortFileName(fullName:String):String
		{
			var shortName:String;
			var dotIndex:int = fullName.lastIndexOf(".");
			if(dotIndex > 0)
			{
				shortName = fullName.substring(0, fullName.lastIndexOf("."));
			}else{
				shortName = fullName;
			}
			return shortName;
		}
		///////////////////////////////////
	}
}