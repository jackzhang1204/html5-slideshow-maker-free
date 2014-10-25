package com.anvsoft.utils.language
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("Language")]
	public class LanguageManager extends EventDispatcher
	{
		private static var instance:LanguageManager = null;
		private static var resourceManager:IResourceManager = null;
		private static var resourceBundleName:String = "Language";
		private static var currentLanguage:String = "en_US";
		private var changeWatcher:ChangeWatcher = null;
		
		public static function getInstance():LanguageManager
		{
			if(instance == null)
			{
				instance = new LanguageManager();
				resourceManager = ResourceManager.getInstance();
				resourceManager.initializeLocaleChain([currentLanguage]);
			}
			return instance;
		}
		public function changeLanguage(languageName:String):void
		{
			//resourceManager.localeChain.localeChain = [languageName];
			resourceManager.localeChain = [languageName];
			currentLanguage = languageName;
			dispatchEvent(new Event("change"));
		}
		
		[Bindable("change")]
		public function getString(resourceName:String):String
		{
			var result:String = resourceManager.getString(resourceBundleName, resourceName, null, currentLanguage);
			return result;
		}
		[Bindable("change")]
		public function getClass(resourceName:String):Class
		{
			var result:Class = resourceManager.getClass(resourceBundleName, resourceName, currentLanguage);
			return result;
		}
		
		public function binding(component:UIComponent, property:String, resourceName:String, type:String = "string", otherStr:String = ""):void
		{
			changeWatcher = BindingUtils.bindProperty(component, property, instance, instance.getChain(resourceName, type, otherStr));
		}
		private function getChain(resourceName:String, type:String, otherStr:String):Object
		{
			var obj:Object = new Object();
			if(type == "string")
			{
				obj.name = "getString";
				obj.getter = function(instance:LanguageManager):String {return instance.getString(resourceName) + otherStr};
			}else if(type == "class"){
				obj.name = "getClass";
				obj.getter = function(instance:LanguageManager):Class {return instance.getClass(resourceName)};
			}
			return obj;
		}
		
		//support languages: da_DK de_DE en_US es_ES fi_FI fr_FR it_IT ja_JP ko_KR nb_NO nl_NL ru_RU sv_SE pt_BR zh_CN zh_TW
		public function getCurrentSystemLanguage():String
		{
			var language:String;
			var systemLang:String = Capabilities.languages[0];
			var langCode:String = systemLang.substr(0, 2);
			switch (langCode){
				case "es":
					language = "es_ES";
					break;
				
				case "it":
					language = "it_IT";
					break;
				
				case "en":
					language = "en_US";
					break;
				
				case "de":
					language = "de_DE";
					break;
				
				case "fr":
					language = "fr_FR";
					break;
				
				case "ja":
					language = "ja_JP";
					break;
				
				case "zh":
					if(systemLang == "zh-CN" || systemLang == "zh-Hans")
					{
						language = "zh_CN";
					}else if(systemLang == "zh-TW" || systemLang == "zh-Hant"){
						language = "zh_TW";
					}else{
						language = "en_US";
					}
					break;
				
				default:
					language = "en_US";
			}
			return language;
		}
		
		
	}
}