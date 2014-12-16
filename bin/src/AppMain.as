package
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.ConfigFileEvent;
	import com.iyoya.utils.file.FileManager;
	import com.iyoya.utils.system.SystemManager;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.events.FlexEvent;
	import spark.components.WindowedApplication;
	//////////////////////////////////////////////////////////////////////////
	// @author John Zhang							 					   	//
	// ///////////////////////////////////////////////////////////////////////
	// version history:														//
	// ///////////////////////////////////////////////////////////////////////
	// date 2012.7.10														//
	// version 1.0.0														//
	// 1.first version publish												//
	//////////////////////////////////////////////////////////////////////////
	// date 2012.7.20														//
	// version 1.1.0														//
	// 1.add some function that file explorer, transition effect and        //
	// photo properties settring                                            //
	//////////////////////////////////////////////////////////////////////////
	// date 2012.8.27														//
	// version 1.2.0														//
	// 1.add upload function namely upload the publish album to go2album    //
	//////////////////////////////////////////////////////////////////////////
	// date 2012.10.31														//
	// version 1.3.0														//
	// 1.add three interface template										//
	// 2.fixed 101 error when all the browser preview publish template      //
	//////////////////////////////////////////////////////////////////////////
	// date 2012.12.10														//
	// version 1.4.0														//
	// 1.add three interface template										//
	// 2.change website link to http://www.html5-slideshow-maker.com        //
	//////////////////////////////////////////////////////////////////////////
	// date 2013.1.16														//
	// version 1.5.0														//
	// 1.add eight interface template										//
	//////////////////////////////////////////////////////////////////////////
	// date 2013.2.21														//
	// version 1.7.0 for windows											//
	// 1.add four interface template										//
	//////////////////////////////////////////////////////////////////////////
	// date 2013.3.14														//
	// version 1.6.0 for mac												//
	// 1.add function for html5 feature checking when play template         //
	// 2.add four interface template										//
	//////////////////////////////////////////////////////////////////////////
	// date 2013.3.22														//
	// version 1.8.0 for windows											//
	// 1.add function for html5 feature checking when play template         //
	// 2.add drag drop function for photo add								//
	// 3.add filePreview drag drop function						            //
	// 4.add delete keydown Listener for remove photo						//
	// 5.set transition valid value                                         //
	//////////////////////////////////////////////////////////////////////////
	// date 2013.4.2														//
	// version 1.7.0 for mac											    //
	// 1.add drag drop function for photo add								//
	// 2.add filePreview drag drop function						            //
	// 3.add delete keydown Listener for remove photo						//
	// 4.set transition valid value                                         //
	//////////////////////////////////////////////////////////////////////////
	// date 2013.5.10														//
	// version 1.8.0 for mac  											    //
	// 1.support multi language                                             //
	//////////////////////////////////////////////////////////////////////////
	// date 2013.5.10														//
	// version 1.9.0 for windows  											//
	// 1.support multi language                                             //
	//////////////////////////////////////////////////////////////////////////
	public class AppMain
	{
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public static var NAME:String = 'HTML5 Slideshow Maker Free';									                     	//
		public static var ID:String = 'com.iyoya.html5-slideshow-maker-free';                                           		//
		public static var AUTHOR:String = 'Copyright (c) 2011-2013 iYoya, Inc.';					                     		//
		public static var VERSION:String = 'Free Version 2.0.0';									                         	//
		public static var DATE:String = 'June 10th, 2013';											                     	    //
		public static var WEBSITE:String = 'https://github.com/jackzhang1204';	                     			                //
		//public static var UPGRADELINK:String = 'https://github.com/jackzhang1204/html5-slideshow-maker-free';           		//
		public static var UPGRADELINK:String = 'https://github.com/jackzhang1204/html5-slideshow-maker-free';                   //
		public static var isFree:Boolean = true;                                                                              	//
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public static var global_movie_width:Number;
		public static var global_movie_height:Number;
		public static var global_top_padding:Number;
		public static var global_bottom_padding:Number;
		public static var global_left_padding:Number;
		public static var global_right_padding:Number;
		public static var global_photo_width:Number;
		public static var global_photo_height:Number;
		public static var global_thum_width:Number;
		public static var global_thum_height:Number;
		//Preference-Options-Image Options///////////
		public static var global_photo_fill_style:String = "fit";
		public static var global_photo_fill_color:uint = 0x000000;
		public static var global_thum_fill_style:String = "fill";
		public static var global_thum_fill_color:uint = 0x000000;
		public static var global_jpeg_quality:uint = 80;
		/////////////////////////////////////////////
		public static var global_system_os:String = Capabilities.os.substr(0, 3);
		public static var global_user_directory:File;
		public static var global_app_directory:File;
		public static var global_app_storage_directory:File;
		public static var global_documents_directory:File;
		public static var global_output_directory:File;
		public static var global_pictures_directory:File;
		public static var global_temp_directory:File;
		//output-output_directory///////////////////
		public static var global_output_directory_path:String;
		//transition 2013.3.22 set valid value/////////
		public static var global_transition_array:String = "1,2,3,4,5,6,7,8,9,10,11,12,13,21,22,23,24,27,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,67";
		//////////////////////////////////////////////
		public static var global_template_first_select:Boolean = true;
		public static var global_app_assets_folder:String = "assets/";
		[Bindable]
		public static var global_total_images:uint = 0;
		[Bindable]
		public static var global_slideshow_name:String = "myalbum";
		public static var global_go2album_url:String = "http://www.go2album.com/";
		public static var global_go2album_register_url:String = "http://www.go2album.com/member/reg.php";
		/////////////////////////////////////////////
		private static var systemManager:SystemManager = new SystemManager();
		private var configFile:File;
		/////////////////////////////////
		public static var global_current_language:String = "";
		private var windowedApp:WindowedApplication
		
		public function AppMain($windowedApp:WindowedApplication)
		{
			windowedApp = $windowedApp;
			windowedApp.addEventListener(FlexEvent.CREATION_COMPLETE, windowedAppCreationCompleteHandler);
			/////////////////////////////////
			initDirectory();
			initConfigFile();
			////////////////////////////
			CommandDispatcher.getInstance().addEventListener(ConfigFileEvent.SAVE_CONFIG_FILE, saveConfigFile);
		}
		private function windowedAppCreationCompleteHandler(e:FlexEvent):void
		{
			windowedApp.removeEventListener(FlexEvent.CREATION_COMPLETE, windowedAppCreationCompleteHandler);
			//////////////////////////////////////
			if(global_current_language == "")
			{
				global_current_language = LanguageManager.getInstance().getCurrentSystemLanguage();
				saveConfigFile();
			}
			LanguageManager.getInstance().changeLanguage(global_current_language);
		}
		private function initDirectory():void
		{
			global_app_directory = File.applicationDirectory;
			global_user_directory = File.userDirectory;
			if(global_system_os == "Mac")
			{
				//mac global_app_storage_directory////////
				var storageLocalPath:String = "Library/Application Support/" + NAME;
				global_app_storage_directory = global_user_directory.resolvePath(storageLocalPath);
				if(global_app_storage_directory.exists == false)
				{
					global_app_storage_directory.createDirectory();
				}
				//mac global_pictures_directory////////
				//global_pictures_directory = global_user_directory.resolvePath("Pictures");
				
				//2012.11.21 fix display name of output folder that apple requirements//////
				var userDirectoryPath:String = global_user_directory.nativePath;
				var userDirectoryArray:Array = userDirectoryPath.split("/");
				var shortUserDirectoryPath:String = "/" + userDirectoryArray[1]+ "/" + userDirectoryArray[2];
				global_pictures_directory = new File(shortUserDirectoryPath + "/Pictures");
				////////////////////////////////////////////////////////////////////////////
				
				//mac global_documents_directory////////
				//global_documents_directory = global_pictures_directory.resolvePath(NAME);
				global_documents_directory = global_pictures_directory.resolvePath(ID);
				if(global_documents_directory.exists == false)
				{
					global_documents_directory.createDirectory();
				}
				//mac global_output_directory////////////
				global_output_directory = global_documents_directory.resolvePath("output");
				//mac global_temp_directory////////////
				global_temp_directory = global_documents_directory.resolvePath("temp");
			}else{
				//win global_app_storage_directory////////
				global_app_storage_directory = File.applicationStorageDirectory;
				//win global_documents_directory////////
				global_documents_directory = File.documentsDirectory;
				//win global_pictures_directory////////
				global_pictures_directory = global_documents_directory.resolvePath("My Pictures");  //is xp system
				if(!global_pictures_directory.exists || global_pictures_directory.isSymbolicLink)
				{
					global_pictures_directory = global_user_directory.resolvePath("Pictures");      //is win7 system
					if(!global_pictures_directory.exists)
					{
						global_pictures_directory = global_documents_directory;						 //is other win system
					}
				}
				//win global_output_directory////////////
				var outputFolderPath:String = "iYoya/" + NAME + "/output";
				global_output_directory = global_documents_directory.resolvePath(outputFolderPath);
				//win global_temp_directory////////////
				var tempFolderPath:String = "iYoya/" + NAME + "/temp";
				global_temp_directory = global_documents_directory.resolvePath(tempFolderPath);
				
				//change upgrade link////////////////////////////////
				UPGRADELINK = "https://github.com/jackzhang1204/html5-slideshow-maker-free";
			}
			if(global_output_directory.exists == false)
			{
				global_output_directory.createDirectory();
			}
			global_output_directory_path = global_output_directory.nativePath;
			
		}
		private function initConfigFile():void
		{
			configFile = global_app_storage_directory.resolvePath("config.xml");
			if(configFile.exists == false)
			{
				saveConfigFile();
			}else{
				loadConfigFile();
			}
		}
		private function saveConfigFile(e:ConfigFileEvent = null):void
		{
			var configFileXml:XML =
				<config>
					<preference>
						<options>
							<image_options photoFillStyle={global_photo_fill_style} 
											 photoFillColor={global_photo_fill_color}
											 thumFillStyle={global_thum_fill_style}
											 thumFillColor={global_thum_fill_color}
										     jpegQuality={global_jpeg_quality}/>
						</options>
						<languages language={global_current_language}/>
					</preference>
					<output>
						<output_directory url={global_output_directory_path}/>
					</output>
					<transition>
						<define_transition transitionArray={global_transition_array}/>
					</transition>
				</config>;
			var fileManager:FileManager = new FileManager();
			fileManager.saveWritedUtfBytes(configFile, configFileXml, "xml");
		}
		private function loadConfigFile():void
		{
			var configFilePath:String = configFile.url;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, configFileLoadCompleteHandler);
			loader.load(new URLRequest(configFilePath));
		}
		private function configFileLoadCompleteHandler(e:Event):void
		{
			var configXml:XML = XML(e.target.data);
			//image_options////////////
			var imgOptions:XMLList = configXml.preference.options.image_options;
			//trace(imgOptions.toXMLString());
			global_photo_fill_style = imgOptions.@photoFillStyle;
			global_photo_fill_color = imgOptions.@photoFillColor;
			global_thum_fill_style = imgOptions.@thumFillStyle;
			global_thum_fill_color = imgOptions.@thumFillColor;
			global_jpeg_quality = imgOptions.@jpegQuality;
			//language////////////
			var languages:XMLList = configXml.preference.languages;
			global_current_language = languages.@language;
			
			//output_directory, exclude Mac that app store have sandbox problem///
			if(global_system_os != "Mac")
			{
				var outputDirectory:XMLList = configXml.output.output_directory;
				global_output_directory_path = outputDirectory.@url;
				try{
					global_output_directory = new File(global_output_directory_path);
					if(global_output_directory.exists == false)
					{
						global_output_directory.createDirectory();
					}
				}catch(e:Error){
					//trace("fiel path error");
				}
			}
			//define_transition////////
			var defineTransition:XMLList = configXml.transition.define_transition;
			global_transition_array = defineTransition.@transitionArray;
			///////////////////////////
			
		}
		//public method////////////////////////////////////////
		public static function startGC():void
		{
			systemManager.startWaitingGC();
		}
		///////////////////////////////////////////////////////
	}
}