package com.anvsoft.utils.file
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import com.anvsoft.utils.file.FileManager;
	
	public class GetSelectedFile extends File
	{
		private var fileFilter:FileFilter;
		
		/////////
		public static const FILE_SELECT_COMPLETE:String = "fileSelectComplete";
		
		public var fileURL:String;
		public var fileName:String;
		public var fileURLVector:Vector.<String> = new Vector.<String>();
		public var fileNameVector:Vector.<String> = new Vector.<String>();
		public var selectFolderName:String;
		
		public function GetSelectedFile(fileType:String, browseType:String, path:String = null)
		{
			super(path);
			/////////////////////////////
			switch(fileType)
			{
				case "Images":
					fileFilter = new FileFilter("Images", "*.jpeg;*.jpg;*.gif;*.png", "JPEG;jp2_;GIFF;JPG;GIF;PNG");
					break;
				case "Flash":
					fileFilter = new FileFilter("Flash", "*.swf", "SWF");
					break;
			}
			switch(browseType)
			{
				case "ForOpen":
					this.browseForOpen("Open", [fileFilter]);
					this.addEventListener(Event.SELECT, fileSelectedCompleteHandler);
					break;
				case "ForMultiple":
					this.browseForOpenMultiple("Open", [fileFilter]);
					this.addEventListener(FileListEvent.SELECT_MULTIPLE, fileMultipleSelectedCompleteHandler);
					break;
				
			}
			
		}
		private function fileSelectedCompleteHandler(e:Event):void
		{
			fileURL = this.url;
			fileName = this.name;
			
			selectFolderName = e.target.parent.name;
			////////////////
			this.dispatchEvent(new Event(GetSelectedFile.FILE_SELECT_COMPLETE));
		}
		private function fileMultipleSelectedCompleteHandler(e:FileListEvent):void
		{
			for (var i:uint = 0; i < e.files.length; i++)
			{
				//2012.8.20 fix macType error in mac sandbox//
				var fileExtension:String = e.files[i].extension;
				if(fileExtension != null)
				{
					fileExtension = fileExtension.toLowerCase();
				}
				if(fileExtension == "jpeg" || fileExtension == "jpg" || fileExtension == "gif" || fileExtension == "png")
				{
					fileURLVector.push(e.files[i].url);
					fileNameVector.push(e.files[i].name);
				}
				////////////////
				
				//fileURLVector[i] = e.files[i].url;
				//fileNameVector[i] = e.files[i].name;
			}
			selectFolderName = e.files[0].parent.name;
			
			this.dispatchEvent(new Event(GetSelectedFile.FILE_SELECT_COMPLETE));
		}
		
	}
}