package com.iyoya.utils.file
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.*;
	public class FileCompress
	{
		private var destinationFile:File;
		private var outPutFolder:File;
		private var excludeFileArray:Array;
		
		public function FileCompress($destinationFile:File, $outPutFolder:File = null, $excludeFileArray:Array = null)
		{
			destinationFile = $destinationFile;
			outPutFolder = $outPutFolder;
			excludeFileArray = $excludeFileArray;
		}
		public function compress($zipFileName:String = null, $otherFileArray:Array = null):File
		{
			var zipFile:File;
			var zipOut:ZipOutput = new ZipOutput();
			//add zip data//////////////
			var zipName:String;
			if(!destinationFile.isDirectory)
			{
				if($zipFileName == null)
				{
					var fileName:String = destinationFile.name;
					zipName = fileName.substring(0, fileName.lastIndexOf(".")) + ".zip";
				}else{
					zipName = $zipFileName + ".zip";
				}
				zipFile = destinationFile.parent.resolvePath(zipName);
				var relativePath:String = zipFile.parent.getRelativePath(destinationFile);
				addZipData(zipOut, destinationFile, relativePath);
			}else{
				if($zipFileName == null)
				{
					zipName = destinationFile.name + ".zip";
				}else{
					zipName = $zipFileName + ".zip";
				}
				zipFile = destinationFile.resolvePath(zipName);
				addZipDataByFolder(destinationFile, zipFile, zipOut);
				//add other file to zip file////
				if($otherFileArray != null)
				{
					var otherFileLen:uint = $otherFileArray.length;
					for (var i:uint = 0; i < otherFileLen; i++)
					{
						addZipData(zipOut, $otherFileArray[i], $otherFileArray[i].name);
					}
				}
				////////////////////////////////
			}
			//save zip file/////////////
			var zipData:ByteArray = zipOut.byteArray;
			var outputZipFile:File;
			if(outPutFolder == null)
			{
				outputZipFile = zipFile;
			}else{
				outputZipFile = outPutFolder.resolvePath(zipName);
			}
			saveZipFlie(outputZipFile, zipData);
			return outputZipFile;
		}
		private function addZipDataByFolder($destinationFile:File, $zipFile:File, $zipOut:ZipOutput):void
		{
			var fileListArray:Array = $destinationFile.getDirectoryListing();
			var fileLen:uint = fileListArray.length;
			for (var i:uint = 0; i < fileLen; i++)
			{
				var listFile:File = fileListArray[i];
				if(!listFile.isDirectory)
				{
					var relativePath:String = $zipFile.parent.getRelativePath(listFile);
					addZipData($zipOut, listFile, relativePath);
				}else{
					addZipDataByFolder(listFile, $zipFile, $zipOut);
				}
			}
		}
		private function addZipData(zipOut:ZipOutput, file:File , relativePath:String):void
		{
			//exclude file///////////////
			var excludeFilesLen:uint = excludeFileArray.length;
			for(var i:uint = 0; i < excludeFilesLen; i++)
			{
				if(file.name == excludeFileArray[i])
				{
					return;
				}
			}
			//open file/////////////
			var byteArray:ByteArray = new ByteArray();
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			if(fileStream.bytesAvailable > 0)
			{
				fileStream.readBytes(byteArray, 0, 0);
			}else{
				byteArray.writeBoolean(false);
			}
			fileStream.close();
			//add zip file data/////
			var zipEntry:ZipEntry = new ZipEntry(relativePath);
			zipOut.putNextEntry(zipEntry);
			zipOut.write(byteArray);
			zipOut.closeEntry();
			zipOut.finish();
		}
		private function saveZipFlie(file:File, data:ByteArray):void
		{
			//save zip file/////////
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(data, 0, data.length);
			stream.close();
		}
	}
}