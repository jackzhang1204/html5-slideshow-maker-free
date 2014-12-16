package com.iyoya.components.container.photo.preview
{
	import com.iyoya.components.AppAlertCom;
	import com.iyoya.components.container.photo.preview.thumbnail.ThumContainerCom;
	import com.iyoya.data.AlbumDataParser;
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.photo.preview.PreviewPanelComEvent;
	import com.iyoya.events.components.container.photo.setting.FileExplorerComEvent;
	import com.iyoya.events.components.container.photo.setting.PropertiesPanelComEvent;
	import com.iyoya.events.components.container.photo.setting.TransitionPanelComEvent;
	import com.iyoya.utils.file.FileManager;
	import com.iyoya.utils.file.GetSelectedFile;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.ui.Mouse;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.TileGroup;
	
	/******************************
	 *	
	 * 
	 *****************************/
	public class PreviewPanelAS extends Group
	{
		public var addPhotoButton:Button;
		public var removePhotoButton:Button;
		public var removeAllPhotoButton:Button;
		public var previewPanelTileGroup:TileGroup;
		
		//////////////////////
		private var selectedFile:GetSelectedFile;
		private var preSelectedItem:ThumContainerCom;
		private var preOpenFileURL:String;
		private var albumDataParser:AlbumDataParser;
		private var samplePicturesPath:String = "assets/Sample Pictures";
		private var currentSelectedItemFromFileExplorer:Object = new Object();
		private var photoTypes:Vector.<String> = new <String>["jpg", "jpeg", "png", "gif"];
		private var dragDropBitmap:Bitmap = new Bitmap;
		private var appTopContainer:DisplayObjectContainer = FlexGlobals.topLevelApplication.parent;
		
		public function PreviewPanelAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			//initialize////////////////////////////
			removePhotoButton.enabled = false;
			albumDataParser = new AlbumDataParser();
			//addEventListener//////////////////////////
			addPhotoButton.addEventListener(MouseEvent.CLICK, addPhotoButtonClickHandler);
			removePhotoButton.addEventListener(MouseEvent.CLICK, removePhotoButtonClickHandler);
			removeAllPhotoButton.addEventListener(MouseEvent.CLICK, removeAllPhotoButtonClickHandler);
			previewPanelTileGroup.addEventListener(MouseEvent.CLICK, previewPanelTileGroupClickHandler);
			//2013.3.18 add drag drop function for photo add/////////
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, nativeDragEnterHandler);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, nativeDragDropHandler);
			//2013.3.19 add delete keydown Listener for remove photo////
			this.addEventListener(KeyboardEvent.KEY_DOWN, deleteKeyDownHandler);
			////////////////////////////////////////////////////////////
			CommandDispatcher.getInstance().addEventListener(PreviewPanelComEvent.GET_ALBUM_DATA_PARSER, getAlbumDataParserHandler);
			CommandDispatcher.getInstance().addEventListener(FileExplorerComEvent.ADD_PHOTO_FROM_FILE_EXPLORER, addPhotoFromFileExplorer);
			CommandDispatcher.getInstance().addEventListener(FileExplorerComEvent.SELECTED_FILE_FROM_FILE_EXPLORER, selectedFileFromFileExplorer);
			CommandDispatcher.getInstance().addEventListener(FileExplorerComEvent.REMOVE_SELECTED_FILE_FROM_FILE_EXPLORER, removeSelectedFileFromFileExplorer);
			CommandDispatcher.getInstance().addEventListener(TransitionPanelComEvent.SET_TRANSITION_EFFECT, setTransitionEffect);
			CommandDispatcher.getInstance().addEventListener(PropertiesPanelComEvent.SET_IMAGE_PROPERTIES, setImageProperties);
			//2013.3.20 add filePreview drag drop function///////////////////////////////
			CommandDispatcher.getInstance().addEventListener(FileExplorerComEvent.FILE_PREVIEW_MOUSE_DOWN, filePreviewMouseDownHandler);
			CommandDispatcher.getInstance().addEventListener(FileExplorerComEvent.FILE_PREVIEW_MOUSE_MOVE, filePreviewMouseMoveHandler);
			CommandDispatcher.getInstance().addEventListener(FileExplorerComEvent.FILE_PREVIEW_MOUSE_UP, filePreviewMouseUpHandler);
			/////////////////////////////////////////////////////////////////////////////
			addDirectoryImages(samplePicturesPath);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(addPhotoButton, "label", "22001");
			LanguageManager.getInstance().binding(removePhotoButton, "label", "22002");
			LanguageManager.getInstance().binding(removeAllPhotoButton, "label", "22003");
		}
		//2013.3.18 add drag drop function for photo add/////////////////
		private function nativeDragEnterHandler(e:NativeDragEvent):void
		{
			NativeDragManager.dropAction = NativeDragActions.COPY;
			NativeDragManager.acceptDragDrop(this);
		}
		private function nativeDragDropHandler(e:NativeDragEvent):void
		{
			var clipboard:Clipboard = e.clipboard;
			if(clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var clipboardFileList:Array = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				var fileLen:uint = clipboardFileList.length;
				var extenLen:uint = photoTypes.length;
				for(var i:uint = 0; i < fileLen; i ++)
				{
					var clipboardFile:File = clipboardFileList[i] as File;
					var fileExtension:String = clipboardFile.extension;
					if(fileExtension != null)
					{
						fileExtension = fileExtension.toLowerCase();
					}
					for(var j:uint = 0; j < extenLen; j++)
					{
						if(fileExtension == photoTypes[j])
						{
							addItem(clipboardFile.url, clipboardFile.name);
							//trace("Drag Drop File: " + clipboardFile.url);
						}
					}
				}
				//start gc///////
				AppMain.startGC();
				/////////////////
			}
		}
		//////////////////////////////////////////////////////////////////////////
		//2013.3.19 add delete keydown Listener for remove photo//////////////////
		private function deleteKeyDownHandler(e:KeyboardEvent):void
		{
			//trace("key code: " + e.keyCode);
			if(e.keyCode == 46)
			{
				removePhotoButtonClickHandler();
			}
		}
		//////////////////////////////////////////////////////////////////////////
		private function getAlbumDataParserHandler(e:PreviewPanelComEvent):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new PreviewPanelComEvent(PreviewPanelComEvent.ALBUM_DATA_PARSER_UPDATE, albumDataParser));
		}
		private function addPhotoButtonClickHandler(e:MouseEvent):void
		{
			if(currentSelectedItemFromFileExplorer.isImage)
			{
				addItem(currentSelectedItemFromFileExplorer.url, currentSelectedItemFromFileExplorer.name);
				//start gc///////
				AppMain.startGC();
				/////////////////
			}else{
				preOpenFileURL = currentSelectedItemFromFileExplorer.url;
				selectedFile = new GetSelectedFile("Images", "ForMultiple", preOpenFileURL);
				selectedFile.addEventListener(GetSelectedFile.FILE_SELECT_COMPLETE, fileMultipleSelectedCompleteHandler);
			}
		}
		private function fileMultipleSelectedCompleteHandler(e:Event):void
		{
			if(AppMain.global_slideshow_name == "myalbum")
			{
				AppMain.global_slideshow_name = selectedFile.selectFolderName;
			}
			/////////////////
			var len:uint = selectedFile.fileURLVector.length;
			for (var i:uint = 0; i < len; i++)
			{
				addItem(selectedFile.fileURLVector[i], selectedFile.fileNameVector[i]);
			}
			//start gc///////
			AppMain.startGC();
			/////////////////
			preOpenFileURL = new File(selectedFile.fileURLVector[0]).parent.url;
			selectedFile.removeEventListener(GetSelectedFile.FILE_SELECT_COMPLETE, fileMultipleSelectedCompleteHandler);
			selectedFile = null;
		}
		private function addPhotoFromFileExplorer(e:FileExplorerComEvent):void
		{
			addItem(e.photoURL, e.photoTitle);
			//start gc///////
			AppMain.startGC();
			/////////////////
		}
		private function selectedFileFromFileExplorer(e:FileExplorerComEvent):void
		{
			currentSelectedItemFromFileExplorer.url = e.photoURL;
			currentSelectedItemFromFileExplorer.name = FileManager.getShortFileName(e.photoTitle);
			///////////////
			var itemFile:File = new File(currentSelectedItemFromFileExplorer.url);
			if(itemFile.isDirectory)
			{
				currentSelectedItemFromFileExplorer.isImage = false;
			}else{
				currentSelectedItemFromFileExplorer.isImage = true;
			}
		}
		private function removeSelectedFileFromFileExplorer(e:FileExplorerComEvent):void
		{
			currentSelectedItemFromFileExplorer = new Object();
			//trace("reset selected item from file explorer.");
		}
		//2013.3.20 add filePreview drag drop function/////////////////////////////////
		private function filePreviewMouseDownHandler(e:FileExplorerComEvent):void
		{
			dragDropBitmap.bitmapData = e.filePreviewBitmapData;
			dragDropBitmap.alpha = 0.5;
		}
		private function filePreviewMouseMoveHandler(e:FileExplorerComEvent):void
		{
			dragDropBitmap.x = stage.mouseX;
			dragDropBitmap.y = stage.mouseY;
			if(dragDropBitmap.parent == null)
			{
				appTopContainer.addChild(dragDropBitmap);
			}
			if(this.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				Mouse.cursor = "hand";
			}else{
				Mouse.cursor = "auto";
			}
			Mouse.show();
		}
		private function filePreviewMouseUpHandler(e:FileExplorerComEvent):void
		{
			if(dragDropBitmap.parent != null)
			{
				Mouse.cursor = "auto";
				appTopContainer.removeChild(dragDropBitmap);
				if(this.hitTestPoint(stage.mouseX, stage.mouseY))
				{
					var directory:Boolean = (new File(e.photoURL)).isDirectory;
					if(!directory)
					{
						addItem(e.photoURL, e.photoTitle);
					}
				}
			}
		}
		//////////////////////////////////////////////////////////////////////////////////
		private function addItem($url:String, $title:String):void
		{
			$title = FileManager.getShortFileName($title);
			var thumContainerCom:ThumContainerCom = new ThumContainerCom();
			thumContainerCom.url = $url;
			thumContainerCom.title = $title;
			previewPanelTileGroup.addElement(thumContainerCom);
			thumContainerCom.addEventListener(MouseEvent.CLICK, thumContainerComClickHandler);
			////////////
			var slideItem:Object = albumDataParser.addSlideItem();
			slideItem.title = $title;
			slideItem.jpegURL = $url;
			slideItem.d_URL = $url;
		}
		private function addDirectoryImages(directoryPath:String):void
		{
			var directoryFile:File = AppMain.global_app_directory.resolvePath(directoryPath);
			if(directoryFile.exists)
			{
				var directoryInfo:Object = FileManager.getDirectoryInfo(directoryFile, false, photoTypes);
				var infoURLVector:Vector.<String> = directoryInfo.url;
				var infoNameVector:Vector.<String> = directoryInfo.name;
				var fileLen:uint = infoURLVector.length;
				for (var i:uint = 0; i < fileLen; i++)
				{
					addItem(infoURLVector[i], infoNameVector[i]);
				}
				//start gc///////
				AppMain.startGC();
				/////////////////
			}
		}
		private function thumContainerComClickHandler(e:MouseEvent):void
		{
			if(preSelectedItem)
			{
				preSelectedItem.removeSelect();
			}
			e.currentTarget.onSelect();
			preSelectedItem = e.currentTarget as ThumContainerCom;
			removePhotoButton.enabled = true;
			///////////
			var currentThumIndex:int = previewPanelTileGroup.getElementIndex(preSelectedItem);
			var currentTransId:String = preSelectedItem.transitionId;
			var currentTransDuration:String = preSelectedItem.transitionDuration;
			var currentPhotoShowDuration:String = preSelectedItem.photoShowDuration;
			CommandDispatcher.getInstance().dispatchEvent(new PreviewPanelComEvent(PreviewPanelComEvent.THUM_CONTAINER_SELECTED, albumDataParser, currentTransId, currentTransDuration, currentPhotoShowDuration, currentThumIndex));
		}
		private function removePhotoButtonClickHandler(e:MouseEvent = null):void
		{
			if(preSelectedItem != null)
			{
				var index:uint = previewPanelTileGroup.getElementIndex(preSelectedItem);
				albumDataParser.removeSlideItemAt(index);
				//////////
				previewPanelTileGroup.removeElement(preSelectedItem);
				preSelectedItem = null;
				removePhotoButton.enabled = false;
				//start gc///////
				AppMain.startGC();
				/////////////////
			}
		}
		private function removeAllPhotoButtonClickHandler(e:MouseEvent):void
		{
			albumDataParser.removeAllSlideItemAt();
			////////////
			while(previewPanelTileGroup.numElements) previewPanelTileGroup.removeElementAt(0);
			preSelectedItem = null;
			removePhotoButton.enabled = false;
			//start gc///////
			AppMain.startGC();
			/////////////////
		}
		private function previewPanelTileGroupClickHandler(e:Event):void
		{
			if(e.target == e.currentTarget)
			{
				removePhotoButton.enabled = false;
				if(preSelectedItem != null)
				{
					preSelectedItem.removeSelect();
					preSelectedItem = null;
					CommandDispatcher.getInstance().dispatchEvent(new PreviewPanelComEvent(PreviewPanelComEvent.THUM_CONTAINER_UNSELECTED));
				}
			}
		}
		private function setTransitionEffect(e:TransitionPanelComEvent):void
		{
			var transId:String = e.transitionId;
			var transImgURL:String = e.transitionImgURL;
			var transDuration:String = e.transitionTimes;
			var photoShowDuration:String = e.photoShowTimes;
			var applyType:String = e.applyType;
			if(applyType == "applyToSelected")
			{
				if(preSelectedItem != null)
				{
					if(transId != null)
					{
						preSelectedItem.transitionId = transId;
						preSelectedItem.transitionImg.source = transImgURL;
					}
					preSelectedItem.transitionDuration = transDuration;
					preSelectedItem.photoShowDuration = photoShowDuration;
					////////////
					var index:uint = previewPanelTileGroup.getElementIndex(preSelectedItem);
					albumDataParser.setTransitionEffectAt(index, transId, transDuration, photoShowDuration);
				}else{
					var selectPhotoAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
					selectPhotoAlert.tipTitle = "HTML5 Slideshow Maker";
					selectPhotoAlert.tipInfo = LanguageManager.getInstance().getString("20014");
				}
			}else{
				var len:uint = previewPanelTileGroup.numElements;
				for(var i:uint = 0; i< len; i++)
				{
					var thumContainerCom:ThumContainerCom = previewPanelTileGroup.getElementAt(i) as ThumContainerCom;
					if(transId != null)
					{
						thumContainerCom.transitionId = transId;
						thumContainerCom.transitionImg.source = transImgURL;
					}
					thumContainerCom.transitionDuration = transDuration;
					thumContainerCom.photoShowDuration = photoShowDuration;
				}
				albumDataParser.setTransitionEffectAll(transId, transDuration, photoShowDuration);
			}
		}
		
		private function setImageProperties(e:PropertiesPanelComEvent):void
		{
			var title:String = e.imgTitle;
			var description:String = e.imgDescription;
			var url:String = e.imgURL;
			var applyType:String = e.applyType;
			if(applyType == "applyToSelected")
			{
				if(preSelectedItem != null)
				{
					var index:uint = previewPanelTileGroup.getElementIndex(preSelectedItem);
					albumDataParser.setPropertiesAt(index, title, description, url);
					
				}else{
					var selectPhotoAlert:AppAlertCom = AppAlertCom(PopUpManager.createPopUp(this, AppAlertCom, true));
					selectPhotoAlert.tipTitle = "HTML5 Slideshow Maker";
					selectPhotoAlert.tipInfo = LanguageManager.getInstance().getString("20015");
				}
			}else{
				albumDataParser.setPropertiesAll(title, description, url);
			}
		}
		
	}
}