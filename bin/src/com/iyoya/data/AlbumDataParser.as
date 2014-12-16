package com.iyoya.data
{
	public class AlbumDataParser
	{
		private var slideItemDataVector:Vector.<Object> = new Vector.<Object>();
		private var $slideItemDataVector:Vector.<Object> = new Vector.<Object>();
		
		public function AlbumDataParser()
		{
			
		}
		private function addLogoItem():Object
		{
			var slideObj:Object = new Object();
			slideObj.jpegURL = "assets/logo.jpg";
			slideObj.d_URL = "assets/logo.jpg";
			slideObj.v_URL = "";
			slideObj.transition = "29";
			slideObj.panzoom = "0";
			slideObj.URLTarget = "0";
			slideObj.phototime = "10";
			slideObj.transitiontime = "2";
			slideObj.url = AppMain.WEBSITE;
			slideObj.title = "Powered by HTML5 Slideshow Maker Free Version";
			slideObj.width = "0";
			slideObj.height = "0";
			slideObj.description = "";
			
			return slideObj;
		}
		public function addSlideItem():Object
		{
			var slideObj:Object = new Object();
			slideObj.jpegURL = "";
			slideObj.d_URL = "";
			slideObj.v_URL = "";
			slideObj.transition = "0";
			slideObj.panzoom = "0";
			slideObj.URLTarget = "0";
			slideObj.phototime = "2";
			slideObj.transitiontime = "2";
			slideObj.url = AppMain.WEBSITE;
			slideObj.title = "";
			slideObj.width = "0";
			slideObj.height = "0";
			slideObj.description = "";
			slideItemDataVector.push(slideObj);
			
			AppMain.global_total_images = slideItemDataVector.length;
			return slideObj;
		}
		public function removeSlideItemAt(index:uint):void
		{
			if(index >= 0 && index < slideItemDataVector.length)
			{
				slideItemDataVector.splice(index, 1);
			}
			
			AppMain.global_total_images = slideItemDataVector.length;
		}
		public function removeAllSlideItemAt():void
		{
			slideItemDataVector = new Vector.<Object>();
			
			AppMain.global_total_images = slideItemDataVector.length;
		}
		public function setTransitionEffectAt(index:uint, transId:String, transDuration:String, photoShowDuration:String):void
		{
			if(transId != null)
			{
				slideItemDataVector[index].transition = transId;
			}
			slideItemDataVector[index].transitiontime = transDuration;
			slideItemDataVector[index].phototime = photoShowDuration;
		}
		public function setTransitionEffectAll(transId:String, transDuration:String, photoShowDuration:String):void
		{
			var len:uint = slideItemDataVector.length;
			for(var i:uint = 0 ; i< len; i++)
			{
				if(transId != null)
				{
					slideItemDataVector[i].transition = transId;
				}
				slideItemDataVector[i].transitiontime = transDuration;
				slideItemDataVector[i].phototime = photoShowDuration;
			}
		}
		public function setPropertiesAt(index:uint, imgTitle:String, imgDescription:String, imgURL:String):void
		{
			slideItemDataVector[index].title = imgTitle;
			slideItemDataVector[index].description = imgDescription;
			slideItemDataVector[index].url = imgURL;
		}
		public function setPropertiesAll(imgTitle:String, imgDescription:String, imgURL:String):void
		{
			var len:uint = slideItemDataVector.length;
			for(var i:uint = 0 ; i< len; i++)
			{
				slideItemDataVector[i].title = imgTitle;
				slideItemDataVector[i].description = imgDescription;
				slideItemDataVector[i].url = imgURL;
			}
		}
		public function getTitle(index:int):String
		{
			return slideItemDataVector[index].title;
		}
		public function getDescription(index:int):String
		{
			return slideItemDataVector[index].description;
		}
		public function getURL(index:int):String
		{
			return slideItemDataVector[index].url;
		}
		public function getSlidesAlbumXml():XML
		{
			//check version category/////
			if(AppMain.isFree)
			{
				$slideItemDataVector = slideItemDataVector.concat();
				$slideItemDataVector.push(addLogoItem());
			}else{
				$slideItemDataVector = slideItemDataVector;
			}
			/////////////////////////////
			var album_xml_name:String = "album";
			var album:XML = new XML(<{album_xml_name}/>);
			var albumLen:uint = $slideItemDataVector.length;
			var slide_xml_name:String = "slide";
			for (var i:uint=0; i < albumLen; i++)
			{
				var slide:XML = new XML(<{slide_xml_name}/>);
				var slideObj:Object = $slideItemDataVector[i];
				for (var item:String in slideObj)
				{
					if(item == "description")
					{
						continue;
					}
					var itemValue:String = slideObj[item];
					//change jpegURL,d_URL,v_URL value//
					if(itemValue != "" && (item == "jpegURL" || item == "d_URL" || item == "v_URL"))
					{
						var index:uint = i + 1;
						var indexStr:String = "0000" + index.toString(10);
						indexStr = indexStr.substring(indexStr.length - 4);
						switch (item)
						{
							case "jpegURL":
								itemValue = "thumbs/t_" + indexStr + ".jpg";
								break;
							case "d_URL":
								itemValue = "slides/p_" + indexStr + ".jpg";
								break;
							case "v_URL":
								itemValue = "videos/v_" + indexStr + ".mp4";
								break;
							
							default:
						}
					}
					//setting width and height value//
					switch (item)
					{
						case "width":
							itemValue = AppMain.global_photo_width.toString();
							break;
						case "height":
							itemValue = AppMain.global_photo_height.toString();
							break;
						
						default:
					}
					slide.@[item] = itemValue;
				}
				//description/////////
				var cdataInfo:String = $slideItemDataVector[i].description;
				if(cdataInfo != "")
				{
					var cdataXml:XML = new XML("<![CDATA[" + cdataInfo + "]]>");
					slide.appendChild(cdataXml);
				}
				///////////////////
				album.appendChild(slide);
			}
			return album;
		}
		public function getImageURLArray():Array
		{
			var imageURLArray:Array = new Array();
			var len:uint = $slideItemDataVector.length;
			for (var i:uint=0; i < len; i++)
			{
				imageURLArray.push($slideItemDataVector[i].d_URL);
			}
			return imageURLArray;
		}
	}
}