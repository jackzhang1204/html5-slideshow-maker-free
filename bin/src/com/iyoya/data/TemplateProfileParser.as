package com.iyoya.data
{
	import com.iyoya.utils.color.ColorConverter;
	
	public class TemplateProfileParser
	{
		private var xmlData:XML;
		private var profile_xml_name:String;

		public var profile_display_name:String;
		public var profile_preview:String;
		public var profile_folder:String;
		public var profile_swf_file:String;
		public var profile_swf_path_base:String;
		public var profile_htt_path_base:String;
		public var profile_htt_file:String;
		public var profile_aux_htt_file:String;
		public var profile_aux_html_file:String;
		public var profile_output_res_folder:String;
		//public var profile_xml_config_file:String;
		//////////////
		public var preloader_name:String;
		public var html_title:String;
		
		public function TemplateProfileParser($xmlData:XML)
		{
			xmlData = $xmlData;
			//template_parameters_profile////////
			profile_display_name = xmlData.@display_name;
			profile_preview = xmlData.@preview;
			profile_folder = xmlData.@folder;
			profile_xml_name = xmlData.@xml_name;
			profile_swf_file = xmlData.@swf_file;
			profile_swf_path_base = xmlData.@swf_path_base;
			//profile_xml_config_file = xmlData.@xml_config_file;
			
			//fixed_parameters///////////////////
			var fixedParameters:XMLList = xmlData.fixed_parameters;
			profile_htt_path_base = fixedParameters.@htt_path_base;
			profile_htt_file = fixedParameters.@htt_file;
			profile_aux_htt_file = fixedParameters.@aux_htt_file;
			profile_aux_html_file = fixedParameters.@aux_html_file;
			profile_output_res_folder = fixedParameters.@output_res_folder;
			/////////////////////////////////////
			//getSlidesPreferencesXml();
			
		}
		
		public function getBasicProperties():Object
		{
			var basicProperties:Object = new Object();
			var basic_property_xml:XML =  xmlData.group[0].category[0];
			//////////////////
			basicProperties.html_title = String(basic_property_xml.item.(@xml_name == "html_title").@value);
			basicProperties.movieWidth = uint(basic_property_xml.item.item[0].(@xml_name == "movieWidth").@value);
			basicProperties.movieHeight = uint(basic_property_xml.item.item[1].(@xml_name == "movieHeight").@value);
			basicProperties.frameRate = uint(basic_property_xml.item.(@xml_name == "frameRate").@value);
			basicProperties.backgroundColor = uint(ColorConverter.BGRToRGB(basic_property_xml.item.(@xml_name == "backgroundColor").@value));
			basicProperties.startAutoPlay = String(basic_property_xml.item.(@xml_name == "startAutoPlay").@value);
			if(basicProperties.startAutoPlay == "true")
			{
				basicProperties.startAutoPlay = true;
			}else{
				basicProperties.startAutoPlay = false;
			}
			basicProperties.clickToAutoPlay = String(basic_property_xml.item.(@xml_name == "clickToAutoPlay").@value);
			if(basicProperties.clickToAutoPlay == "true")
			{
				basicProperties.clickToAutoPlay = true;
			}else{
				basicProperties.clickToAutoPlay = false;
			}
			basicProperties.randomPlayingPhotos = String(basic_property_xml.item.(@xml_name == "randomPlayingPhotos").@value);
			if(basicProperties.randomPlayingPhotos == "true")
			{
				basicProperties.randomPlayingPhotos = true;
			}else{
				basicProperties.randomPlayingPhotos = false;
			}
			basicProperties.continuum = String(basic_property_xml.item.(@xml_name == "continuum").@value);
			if(basicProperties.continuum == "true")
			{
				basicProperties.continuum = true;
			}else{
				basicProperties.continuum = false;
			}
			basicProperties.enableURL = String(basic_property_xml.item.(@xml_name == "enableURL").@value);
			if(basicProperties.enableURL == "true")
			{
				basicProperties.enableURL = true;
			}else{
				basicProperties.enableURL = false;
			}
			
			return basicProperties;
		}
		
		public function getSlidesPreferencesXml(basicProperties:Object = null):XML
		{
			//reset global_thum_width and global_thum_height//
			AppMain.global_thum_width = 0;
			AppMain.global_thum_height = 0;
			var movieWidthState:Boolean = true;
			var movieHeightState:Boolean = true;
			//////////////////////////////////////////////////
			var preferences:XML = new XML(<{profile_xml_name}/>);
			var groupList:XMLList = xmlData.group;
			var groupLen:uint = groupList.length();
			
			for (var i:uint=0; i < groupLen; i++)
			{
				var group_xml_name:String = groupList[i].@xml_name;
				var group:XML = new XML(<{group_xml_name}/>);
				preferences.appendChild(group);
				var categoryList:XMLList = groupList[i].category;
				var categoryLen:uint = categoryList.length();
				
				for (var j:uint=0; j < categoryLen; j++)
				{
					var categoryData:XML = categoryList[j];
					var category_xml_name:String = categoryData.@xml_name;
					var category:XML = new XML(<{category_xml_name}/>);
					
					var categoryObj:Object = new Object();
					categoryObj = xmlToObject(categoryData, "id", categoryObj);
					var objArray:Array = new Array();
					objArray = objectToArray(categoryObj, ["xml_name", "value", "item_category"], objArray);
					var objArrayLen:uint = objArray.length;
					for(var k:uint = 0; k < objArrayLen; k++)
					{
						var attributeName:String = objArray[k].xml_name;
						var attributeValue:String = objArray[k].value;
						var itemCategory:String = objArray[k].item_category;
						/*********************************
						* check item category
						* 40: ColorSelector_LONG
						*********************************/
						if(itemCategory == "40")
						{
							attributeValue = ColorConverter.BGRToRGB(attributeValue);
						}
						
						//Get Load Style Name//
						if(itemCategory == "50")
						{
							preloader_name = attributeValue;
							attributeValue = "res/" + attributeValue;
						}
						//setting define random transition/////////
						if(attributeName == "transitionArray")
						{
							attributeValue = AppMain.global_transition_array;
						}
						/******************************
						 * update basic properties
						*******************************/
						if(i == 0 && j == 0 && basicProperties[attributeName] != null)
						{
							attributeValue = basicProperties[attributeName];
							//Get html_title//
							if(attributeName == "html_title")
							{
								html_title = attributeValue;
							}
						}
						//////////////////////////////////
						category.@[attributeName] = attributeValue;
						//setting static global variable//
						
						switch (itemCategory)
						{
							//item_category=9000=movieWidth////
							case "9000":
								if(movieWidthState || movieHeightState)
								{
									AppMain.global_movie_width = Number(attributeValue);
									movieWidthState = false;
								}
								
								break;
							
							//item_category=9001=movieHeight////
							case "9001":
								if(movieWidthState || movieHeightState)
								{
									AppMain.global_movie_height = Number(attributeValue);
									movieHeightState = false;
								}
								
								break;
							
							//item_category=9014=topPadding////
							case "9014":
								AppMain.global_top_padding = Number(attributeValue);
								break;
							
							//item_category=9016=bottomPadding////
							case "9016":
								AppMain.global_bottom_padding = Number(attributeValue);
								break;
							
							//item_category=9015=leftPadding////
							case "9015":
								AppMain.global_left_padding = Number(attributeValue);
								break;
							
							//item_category=9017=rightPadding////
							case "9017":
								AppMain.global_right_padding = Number(attributeValue);
								break;
							
							//item_category=9006=thumWidth////
							case "9006":
								AppMain.global_thum_width = Number(attributeValue);
								break;
							
							//item_category=9007=thumHeight////
							case "9007":
								AppMain.global_thum_height = Number(attributeValue);
								break;
							
							default:
								
						}
						
						AppMain.global_photo_width = AppMain.global_movie_width - AppMain.global_left_padding - AppMain.global_right_padding;
						AppMain.global_photo_height = AppMain.global_movie_height - AppMain.global_top_padding - AppMain.global_bottom_padding;
						/////////////////////////////////////
					}
					//check for the logo add//////////////
					if(!AppMain.isFree && j == 0)
					{
						category.@anvsoftMenu = "false";
					}
					//////////////////////////////////////
					group.appendChild(category);
				}
			}
			
			//trace(preferences);
			
			return preferences;
		}
		
		private function xmlToObject(xml:XML, id:String, obj:Object):Object
		{
			var childrenList:XMLList = xml.children();
			var propertyName:String;
			var propertyValue:*;
			for each (var children:* in childrenList)
			{
				var index:String = children.attribute(id);
				obj[index] = new Object();
				if (children.attributes().length() > 0)
				{
					for (var i:int = 0; i < children.attributes().length(); i++)
					{
						propertyName = children.attributes()[i].name();
						propertyValue = children.attributes()[i];
						obj[index][propertyName] = propertyValue;
					}
				}
				if (children.hasComplexContent())
				{
					xmlToObject(children, id, obj[index]);
				}
			}
			return obj;
		}
		private function objectToArray(obj:Object, infoArray:Array, ary:Array):Array
		{
			var xml_name:String = infoArray[0];
			var value:String = infoArray[1];
			var item_category:String = infoArray[2];
			for each (var item:* in obj)
			{
				var tempObj:Object = new Object();
				tempObj.xml_name = item[xml_name];
				tempObj.value = item[value];
				tempObj.item_category = item[item_category];
				if(tempObj.xml_name != undefined && tempObj.value != undefined)
				{
					//ary.push(tempObj);
					
					if (item[0] is Object && item[0].hasOwnProperty(xml_name))
					{
						objectToArray(item, infoArray, ary);
					}else{
						ary.push(tempObj);
					}
					
				}
				
				/*if (item[0] is Object && item[0].hasOwnProperty(xml_name))
				{
					//ary.pop();
					objectToArray(item, infoArray, ary);
				}*/
				
			}
			return ary;
		}
		
	}
}