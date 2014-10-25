package com.anvsoft.utils.file
{
	import com.anvsoft.data.SharedObjectData;
	import com.anvsoft.events.CommandDispatcher;
	import com.anvsoft.events.components.container.publish.UploadAlbumEvent;
	import com.anvsoft.utils.string.StringUtils;
	////////////
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import mx.utils.Base64Encoder;
	public class FileUpload
	{
		private var uploadFile:File;
		private var uploadData:Object;
		///////////////////
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		private var currentAlbumSID:String;
		private var uploadSizeLimit:Number = 20 * 1024 * 1024;
		private var servicesUploadURL:String = "http://www.go2album.com/services/uploadAIR.php";
		//private var servicesUploadURL:String = "http://www.go2album-dev.com/services/uploadAIR.php";
		public function FileUpload($uploadFile:File, $uploadData:Object)
		{
			uploadFile = $uploadFile;
			uploadData = $uploadData;
		}
		public function upload():void
		{
			//check upload file size///////
			var uploadFileSize:Number = uploadFile.size;
			if(uploadFileSize > uploadSizeLimit)
			{
				var limitMBSize:Number = uploadSizeLimit / (1024 * 1024);
				var responseString:String = "Upload file size " + uploadFileSize + " bytes exceed " + limitMBSize + " MB, Please decrease the size and submit it later!";
				fileSizeLimit(responseString);
			}else{
				currentAlbumSID = getCurrentSID();
				setURLRequest("upload");
				uploadFile.addEventListener(Event.OPEN, uploadFileOpenHandler);
				uploadFile.addEventListener(ProgressEvent.PROGRESS, uploadFileProgressHandler);
				uploadFile.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, uploadFileHttpResponseStatusHandler);
				uploadFile.addEventListener(Event.COMPLETE, uploadFileCompleteHandler);
				////////////////
				uploadFile.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadFileCompleteDataHandler);
				uploadFile.addEventListener(IOErrorEvent.IO_ERROR, uploadFileErrorHandler);
				uploadFile.addEventListener(HTTPStatusEvent.HTTP_STATUS, uploadFileHttpStatusHandler);
				uploadFile.upload(urlRequest, "filename[]");
				////////////////
				CommandDispatcher.getInstance().addEventListener(UploadAlbumEvent.UPLOAD_CANCELED, uploadCanceledHandler);
			}
		}
		private function loadFinished():void
		{
			setURLRequest("finished");
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.load(urlRequest);
		}
		private function loadCanceled():void
		{
			setURLRequest("canceled");
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.load(urlRequest);
		}
		private function setURLRequest($action:String = "upload"):void
		{
			var username:String = SharedObjectData.getSigninInfo().username;
			var password:String = SharedObjectData.getSigninInfo().password;
			////////////////////////
			urlRequest = new URLRequest(servicesUploadURL);
			urlRequest.method = URLRequestMethod.POST;
			//Base64Encoder////////////////
			var base64enc:Base64Encoder = new Base64Encoder;
			base64enc.encode(username + ":" + password);
			var encodedCredentials:String = base64enc.toString();
			var authHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + encodedCredentials);
			urlRequest.requestHeaders.push(authHeader);
			//URLVariables/////////////////
			var variables:URLVariables = new URLVariables();
			variables.action = $action;
			variables.sid = currentAlbumSID;
			///////////
			variables.title = uploadData.uploadTitle;
			variables.description = uploadData.uploadDescription;
			variables.tag = uploadData.uploadTags;
			variables.privacy = uploadData.uploadPrivacy;
			urlRequest.data = variables;
		}
		private function getCurrentSID():String
		{
			var now:Date = new Date();
			var seconds:Number = now.getSeconds();
			var minutes:Number = now.getMinutes();
			var hours:Number = now.getHours();
			var date:Number = now.getDate();
			var month:Number = now.getMonth() + 1;
			var year:Number = now.getUTCFullYear();
			var secondsStr:String = StringUtils.GetLeadingZeroString(seconds, 2);
			var minutesStr:String = StringUtils.GetLeadingZeroString(minutes, 2);
			var hoursStr:String = StringUtils.GetLeadingZeroString(hours, 2);
			var dateStr:String = StringUtils.GetLeadingZeroString(date, 2);
			var monthStr:String = StringUtils.GetLeadingZeroString(month, 2);
			var yearStr:String = StringUtils.GetLeadingZeroString(year, 4);
			///////////////////
			var sid:String = yearStr + monthStr + dateStr + hoursStr + minutesStr + secondsStr;
			return sid;
		}
		private function uploadFileOpenHandler(e:Event):void
		{
			uploadFile.removeEventListener(Event.OPEN, uploadFileOpenHandler);
			//////////////////////////
			//trace("Upload Open:");
			var uploadFileInfo:String = "Uploading file: " + uploadFile.nativePath;
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.UPLOAD_OPEN, null, 0, 1, uploadFileInfo));
		}
		private function uploadFileProgressHandler(e:ProgressEvent):void
		{
			//trace("Upload Progress Handler:");
			/////////////
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.UPLOAD_PROGRESS, null, e.bytesLoaded, e.bytesTotal));
		}
		private function uploadFileHttpResponseStatusHandler(e:HTTPStatusEvent):void
		{
			uploadFile.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, uploadFileHttpResponseStatusHandler);
			///////////////////////
			//trace("Http Response Staus:" + e.status);
			if(e.status != 200)
			{
				uploadFile.cancel();
			}
		}
		private function uploadFileCompleteHandler(e:Event):void
		{
			uploadFile.removeEventListener(ProgressEvent.PROGRESS, uploadFileProgressHandler);
			uploadFile.removeEventListener(Event.COMPLETE, uploadFileCompleteHandler);
			///////////////////
			//trace("Upload Complete Handler");
		}
		private function uploadFileCompleteDataHandler(e:DataEvent):void
		{
			uploadFile.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadFileCompleteDataHandler);
			///////////////////////
			var responseString:String = e.data as String;
			//trace("***********\n" + "Upload Completed Data Handler:\n" + responseString + "***********");
			var responseArray:Array = responseString.split("\n");
			var responseCode:String = responseArray[0];
			/****PHP services response code define****
			define('ERROR_OK', 200);
			define('ERROR_EXCEED_LIMIT', 701);
			define('ERROR_UPLOAD_FAILED', 702);
			define('ERROR_INVALID_FILE_TYPE', 703);
			define('ERROR_AUTH_FAILED', 704);
			******************************************/
			switch(responseCode)
			{
				case "200":
					uploadSuccess();
					break;
				case "701":
					fileSizeLimit(responseString);
					break;
				case "702":
					uploadFailed(responseString);
					break;
				case "703":
					uploadFailed(responseString);
					break;
				case "704":
					authenticateFailed(responseString);
					break;
				default:
					
			}
		}
		private function uploadFileErrorHandler(e:IOErrorEvent):void
		{
			uploadFile.removeEventListener(IOErrorEvent.IO_ERROR, uploadFileErrorHandler);
			//////////////////
			//trace("Upload Error");
			var responseString:String = "Server connection error.";
			uploadFailed(responseString);
		}
		private function uploadFileHttpStatusHandler(e:HTTPStatusEvent):void
		{
			uploadFile.removeEventListener(HTTPStatusEvent.HTTP_STATUS, uploadFileHttpStatusHandler);
			///////////////////
			//trace("Http Staus:" + e.status);
		}
		private function urlLoaderCompleteHandler(e:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			//////////////////
			var responseString:String = e.target.data as String;
			//trace("***********\n" + "URLLoader Complete Handler:\n" + responseString + "***********");
			var responseArray:Array = responseString.split("\n");
			var responseCode:String = responseArray[0];
			/****PHP services response code define****
			 define('ERROR_FINISHED_OK', 601);
			 define('ERROR_UPLOAD_CANCELED', 602);
			 ******************************************/
			switch(responseCode)
			{
				case "601":
					uploadFinished(responseArray[1]);
					break;
				case "602":
					uploadCanceled();
					break;
				default:
				
			}
		}
		private function uploadCanceledHandler(e:UploadAlbumEvent):void
		{
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_CANCELED, uploadCanceledHandler);
			uploadFile.removeEventListener(ProgressEvent.PROGRESS, uploadFileProgressHandler);
			uploadFile.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, uploadFileHttpResponseStatusHandler);
			uploadFile.removeEventListener(Event.COMPLETE, uploadFileCompleteHandler);
			uploadFile.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadFileCompleteDataHandler);
			uploadFile.removeEventListener(IOErrorEvent.IO_ERROR, uploadFileErrorHandler);
			uploadFile.removeEventListener(HTTPStatusEvent.HTTP_STATUS, uploadFileHttpStatusHandler);
			////////////////////////////////////////
			uploadFile.cancel();
			loadCanceled();
		}
		///////////////////////////
		private function uploadSuccess():void
		{
			CommandDispatcher.getInstance().removeEventListener(UploadAlbumEvent.UPLOAD_CANCELED, uploadCanceledHandler);
			/////////////////
			loadFinished();
		}
		private function authenticateFailed(responseInfo:String):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.AUTHENTICATE_FAILED, null, 0, 1, responseInfo));
		}
		private function uploadFinished(responseInfo:String):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.UPLOAD_FINISHED, null, 0, 1, responseInfo));
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.SAVE_UPLOAD_LOG, null, 0, 1, responseInfo));
		}
		private function uploadCanceled():void
		{
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.UPLOAD_CANCELED_COMPLETE));
		}
		private function uploadFailed(responseInfo:String):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.UPLOAD_FAILED, null, 0, 1, responseInfo));
		}
		private function fileSizeLimit(responseInfo:String):void
		{
			CommandDispatcher.getInstance().dispatchEvent(new UploadAlbumEvent(UploadAlbumEvent.FILE_SIZE_LIMIT, null, 0, 1, responseInfo));
		}
		////////////////////////////////////////////////////////////////
	}
}