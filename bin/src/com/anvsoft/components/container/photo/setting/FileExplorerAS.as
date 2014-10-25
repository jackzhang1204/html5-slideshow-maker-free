package com.anvsoft.components.container.photo.setting
{
	import com.anvsoft.components.container.photo.setting.fileexplorer.FilePreviewCom;
	import com.anvsoft.events.CommandDispatcher;
	import com.anvsoft.events.components.container.photo.setting.FileExplorerComEvent;
	import com.anvsoft.events.components.container.photo.setting.fileexplorer.FilePreviewComEvent;
	import com.anvsoft.utils.file.FileManager;
	import com.anvsoft.utils.display.getDisplayObjectSameRatioBitmapData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import mx.controls.FileSystemTree;
	import mx.events.FileEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.TextInput;
	import spark.components.TileGroup;
	import spark.components.VGroup;
	
	public class FileExplorerAS extends Group
	{
		public var fileSystemTree:FileSystemTree;
		public var fileViewTileGroup:TileGroup;
		public var directoryFilePathTI:TextInput;
		public var changeDirectoryFileBtn:Button;
		public var browsePathHG:HGroup;
		
		private var preSelectedItem:FilePreviewCom;
		private var directoryInfo:Object;
		private var fileInfoURLVector:Vector.<String>;
		private var fileInfoNameVector:Vector.<String>;
		private var fileIndex:uint = 0;
		private var fileTotal:uint = 0;
		private var currentExplorerFolder:File = AppMain.global_pictures_directory;
		private var memoryExplorerFolderPath:String = "";
		private var currentDirectoryFile:File;
		
		public function FileExplorerAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			CommandDispatcher.getInstance().addEventListener(FilePreviewComEvent.FILE_PREVIEW_IMG_LOAD_COMPLETE, filePreviewImgLoadComplete);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			//Check Mac System on sandbox//////////
			if(AppMain.global_system_os == "Mac")
			{
				//filter package directory on mac///////
				fileSystemTree.filterFunction = packageDirectoryFilter;
				//////////////////////
				currentDirectoryFile = currentExplorerFolder;
				settingFileSystemTree(currentDirectoryFile);
				changeDirectoryFileBtn.addEventListener(MouseEvent.CLICK, changeDirectoryFileBtnHandler);
			}else{
				//remove browsePathHG/////////
				var parentVGroup:VGroup = browsePathHG.parent as VGroup;
				parentVGroup.removeElement(browsePathHG);
				browsePathHG = null;
				directoryFilePathTI = null;
				changeDirectoryFileBtn = null;
				//////////////////////////////
				startExplorerFolder(currentExplorerFolder, true);
			}
			fileSystemTree.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			fileViewTileGroup.addEventListener(MouseEvent.CLICK, fileViewTileGroupClickHandler);
		}
		private  function packageDirectoryFilter(file:File):Boolean
		{
			if(file.isPackage)
			{
				return false;
			}else{
				return true;
			}
		}
		private function itemClickHandler(e:ListEvent):void
		{
			var currentSelectPath:String = e.currentTarget.selectedPath;
			currentExplorerFolder = new File(currentSelectPath);
			startExplorerFolder(currentExplorerFolder);
		}
		private function settingFileSystemTree($currentDirectoryFile:File):void
		{
			var firstFolder:File;
			var fileList:Array = $currentDirectoryFile.getDirectoryListing();
			var listLen:uint = fileList.length;
			if(listLen > 0)
			{
				for (var i:uint = 0; i < listLen; i++)
				{
					if(fileList[i].isDirectory)
					{
						firstFolder = fileList[i];
						break;
					}
				}
			}
			if(firstFolder != null)
			{
				fileSystemTree.directory = $currentDirectoryFile;
				startExplorerFolder(firstFolder, true);
			}else{
				//currentExplorerFolder = $currentDirectoryFile;
				fileSystemTree.directory = $currentDirectoryFile;
				fileViewTileGroup.removeAllElements();
			}
			////////////////
			directoryFilePathTI.text = currentDirectoryFile.nativePath;
		}
		private function startExplorerFolder($currentExplorerFolder:File, $openSubFolder:Boolean = false):void
		{
			//Check Mac System on sandbox//////////
			if(currentDirectoryFile != null && $currentExplorerFolder.nativePath == currentDirectoryFile.nativePath)
			{
				currentDirectoryFile.browseForDirectory("Select Directory");
				currentDirectoryFile.addEventListener(Event.SELECT, directorySelectedHandler);
				return;
			}
			///////////////////////////////////////
			var currentExplorerFolderPath:String = $currentExplorerFolder.nativePath;
			if($openSubFolder)
			{
				fileSystemTree.openPaths = [currentExplorerFolderPath];
				fileSystemTree.selectedPath = currentExplorerFolderPath;
				fileSystemTree.validateNow();
				var selectIndex:int = fileSystemTree.findIndex(currentExplorerFolderPath);
				fileSystemTree.scrollToIndex(selectIndex);
			}
			if(currentExplorerFolderPath != memoryExplorerFolderPath)
			{
				updateFileExplorer($currentExplorerFolder);
				memoryExplorerFolderPath = currentExplorerFolderPath;
			}
		}
		private function directorySelectedHandler(e:Event):void
		{
			currentDirectoryFile.removeEventListener(Event.SELECT, directorySelectedHandler);
			///////////////
			currentDirectoryFile = e.target as File;
			settingFileSystemTree(currentDirectoryFile);
		}
		private function changeDirectoryFileBtnHandler(e:MouseEvent):void
		{
			currentDirectoryFile.browseForDirectory("Select Directory");
			currentDirectoryFile.addEventListener(Event.SELECT, directorySelectedHandler);
		}
		private function updateFileExplorer($exploreFile:File):void
		{
			//reset current selected item//////
			CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.REMOVE_SELECTED_FILE_FROM_FILE_EXPLORER, "", ""));
			/////////////////////////////
			fileIndex = 0;
			fileTotal = 0;
			fileViewTileGroup.removeAllElements();
			/////////////
			directoryInfo = FileManager.getDirectoryInfo($exploreFile, true, new <String>["jpg", "jpeg", "png", "gif"]);
			fileInfoURLVector = directoryInfo.url;
			fileInfoNameVector = directoryInfo.name;
			fileTotal = fileInfoURLVector.length;
			////////////////////////
			var parentFile:File = $exploreFile.parent;
			if(parentFile != null)
			{
				parentFile = $exploreFile.resolvePath("..");
				addItem(parentFile.url, "..");
			}else{
				addItem(fileInfoURLVector[fileIndex], fileInfoNameVector[fileIndex]);
				fileIndex++;
			}
		}
		private function filePreviewImgLoadComplete(e:FilePreviewComEvent):void
		{
			if(fileIndex < fileTotal)
			{
				addItem(fileInfoURLVector[fileIndex], fileInfoNameVector[fileIndex]);
				fileIndex++;
			}else{
				//start gc///////
				AppMain.startGC();
				/////////////////
			}
		}
		private function addItem($url:String, $title:String):void
		{
			var directory:Boolean = (new File($url)).isDirectory;
			var filePreviewCom:FilePreviewCom = new FilePreviewCom();
			filePreviewCom.isDirectory = directory;
			filePreviewCom.imgURL = $url;
			filePreviewCom.url = $url;
			filePreviewCom.title = $title;
			fileViewTileGroup.addElement(filePreviewCom);
			filePreviewCom.doubleClickEnabled = true;
			filePreviewCom.addEventListener(MouseEvent.MOUSE_DOWN, filePreviewMouseDownHandler);
			filePreviewCom.addEventListener(MouseEvent.DOUBLE_CLICK, filePreviewDoubClickHandler);
			//2013.3.20 add filePreview drag drop function/////////////
			filePreviewCom.addEventListener(MouseEvent.MOUSE_UP, filePreviewMouseUpHandler);
			filePreviewCom.addEventListener(MouseEvent.RELEASE_OUTSIDE, filePreviewMouseUpHandler);
			//////////////////////////////////////////////////////////
		}
		private function filePreviewMouseDownHandler(e:MouseEvent):void
		{
			var currentSelectedItem:FilePreviewCom = e.currentTarget as FilePreviewCom;
			if(preSelectedItem)
			{
				preSelectedItem.removeSelect();
			}
			currentSelectedItem.onSelect();
			preSelectedItem = currentSelectedItem;
			////////////////////////////
			var photoURL:String = currentSelectedItem.url
			var photoTitle:String = currentSelectedItem.title;
			CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.SELECTED_FILE_FROM_FILE_EXPLORER, photoURL, photoTitle));
			//2013.3.20 add filePreview drag drop function///////////////////////////////
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			var thisBitmapData:BitmapData = getDisplayObjectSameRatioBitmapData(currentSelectedItem, currentSelectedItem.width, currentSelectedItem.height, "fit", 0x00000000, false);
			CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.FILE_PREVIEW_MOUSE_DOWN, "", "", thisBitmapData));
			/////////////////////////////////////////////////////////////////////////
		}
		//2013.3.20 add filePreview drag drop function///////////////////////////////
		private function stageMouseMoveHandler(e:MouseEvent):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.FILE_PREVIEW_MOUSE_MOVE));
		}
		private function filePreviewMouseUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			var photoURL:String = e.currentTarget.url;
			var photoTitle:String = e.currentTarget.title;
			CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.FILE_PREVIEW_MOUSE_UP, photoURL, photoTitle));
		}
		/////////////////////////////////////////////////////////////////////////////
		private function filePreviewDoubClickHandler(e:MouseEvent):void
		{
			var filePreviewCom:FilePreviewCom = e.currentTarget as FilePreviewCom;
			var isDirectory:Boolean = filePreviewCom.isDirectory;
			if(isDirectory)
			{
				currentExplorerFolder = new File(filePreviewCom.url);
				startExplorerFolder(currentExplorerFolder, true);
			}else{
				var photoURL:String = filePreviewCom.url
				var photoTitle:String = filePreviewCom.title;
				CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.ADD_PHOTO_FROM_FILE_EXPLORER, photoURL, photoTitle));
			}
		}
		private function fileViewTileGroupClickHandler(e:MouseEvent):void
		{
			if(preSelectedItem && preSelectedItem.selected && e.currentTarget == e.target)
			{
				preSelectedItem.removeSelect();
				CommandDispatcher.getInstance().dispatchEvent(new FileExplorerComEvent(FileExplorerComEvent.REMOVE_SELECTED_FILE_FROM_FILE_EXPLORER, "", ""));
			}
		}
		
	}
}