package com.iyoya.data
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.components.container.photo.preview.PreviewPanelComEvent;
	import com.iyoya.events.components.container.theme.basic.preset.preview.PreviewThemeComEvent;
	import com.iyoya.events.components.container.theme.basic.properties.PropertiesPanelComEvent;
	
	public class SlidesDataParser
	{
		private var templateProfileParser:TemplateProfileParser;
		private var basicPropertiesObj:Object;
		private var albumDataParser:AlbumDataParser;
		/////////////
		private var _imageURLArray:Array;
		private var _sourceJsFilePath:String;
		private var _sourceFolderPath:String;
		private var _httPathBase:String;
		private var _indexHttFile:String;
		private var _auxHttFile:String;
		private var _auxHtmlFile:String;
		private var _outputResFolderPath:String;
		//private var _outputXmlFileName:String;
		//////
		private var _preloaderPathBase:String;
		//////////////////
		private var _preloaderName:String;
		private var _htmlTitle:String;
		
		public function SlidesDataParser()
		{
			CommandDispatcher.getInstance().addEventListener(PreviewThemeComEvent.TEMPLATE_PROFILE_UPDATE, templateProfileParserUpdateHandler);
			CommandDispatcher.getInstance().addEventListener(PropertiesPanelComEvent.PROPERTIES_DATA_UPDATE, propertiesDataUpdateHandler);
			CommandDispatcher.getInstance().addEventListener(PreviewPanelComEvent.ALBUM_DATA_PARSER_UPDATE, albumDataParserUpdateHandler);
		}
		private function templateProfileParserUpdateHandler(e:PreviewThemeComEvent):void
		{
			templateProfileParser = e.profileObj;
		}
		private function propertiesDataUpdateHandler(e:PropertiesPanelComEvent):void
		{
			basicPropertiesObj = e.propertiesObj;
		}
		private function albumDataParserUpdateHandler(e:PreviewPanelComEvent):void
		{
			albumDataParser = e.albumDataObj;
		}
		public function getXmlData():XML
		{
			var slides_xml_name:String = "flash_parameters";
			var slidesXml:XML = new XML(<{slides_xml_name}/>);
			slidesXml.@copyright = "anvsoftHSMTheme";
			
			//trace(templateProfileParser);
			if(templateProfileParser)
			{
				var slidesPreferencesXml:XML = templateProfileParser.getSlidesPreferencesXml(basicPropertiesObj);
				var slidesAlbumXml:XML = albumDataParser.getSlidesAlbumXml();
				if(slidesAlbumXml.hasComplexContent())
				{
					slidesXml.appendChild(slidesPreferencesXml);
					slidesXml.appendChild(slidesAlbumXml);
				}else{
					slidesXml = null;
					//trace("Please add photo");
				}
			}else{
				slidesXml = null;
				//trace("Please select template");
			}
			return slidesXml;
		}
		
		////////////////////////////////////////
		public function get imageURLArray():Array
		{
			_imageURLArray = albumDataParser.getImageURLArray();
			return _imageURLArray;
		}
		public function get sourceFolderPath():String
		{
			_sourceFolderPath = templateProfileParser.profile_swf_path_base;
			_sourceFolderPath = _sourceFolderPath.split("\\").join("/");
			return _sourceFolderPath;
		}
		public function get sourceJsFilePath():String
		{
			_sourceJsFilePath = templateProfileParser.profile_swf_file;
			return _sourceJsFilePath;
		}
		public function get httPathBase():String
		{
			
			_httPathBase = templateProfileParser.profile_htt_path_base;
			_httPathBase = _httPathBase.split("\\").join("/");
			return _httPathBase;
		}
		public function get indexHttFile():String
		{
			_indexHttFile = templateProfileParser.profile_htt_file;
			return _indexHttFile;
		}
		public function get auxHttFile():String
		{
			_auxHttFile = templateProfileParser.profile_aux_htt_file;
			return _auxHttFile;
		}
		public function get auxHtmlFile():String
		{
			_auxHtmlFile = templateProfileParser.profile_aux_html_file;
			return _auxHtmlFile;
		}
		public function get outputResFolderPath():String
		{
			_outputResFolderPath = templateProfileParser.profile_output_res_folder + "/";
			return _outputResFolderPath;
		}
		
		
		/*public function get outputXmlFileName():String
		{
			_outputXmlFileName = templateProfileParser.profile_xml_config_file;
			return _outputXmlFileName;
		}*/
		/////
		public function get preloaderPathBase():String
		{
			_preloaderPathBase = "template/component/preloader/html5/";
			return _preloaderPathBase;
		}
		
		////////////
		public function get preloaderName():String
		{
			_preloaderName = templateProfileParser.preloader_name;
			return _preloaderName;
		}
		public function get htmlTitle():String
		{
			_htmlTitle = templateProfileParser.html_title;
			return _htmlTitle;
		}
		//////////////
		
		
	}
}