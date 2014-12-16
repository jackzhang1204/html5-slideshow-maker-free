package com.iyoya.events.components.container.theme.basic.preset.preview 
{
	import com.iyoya.data.TemplateProfileParser;
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class PreviewThemeComEvent extends Event
	{
		public static const REMOVE_SELECT:String = "removeSelect";
		public static const TEMPLATE_PROFILE_UPDATE:String = "templateProfileUpdate";
		
		public var profileObj:TemplateProfileParser;
		public function PreviewThemeComEvent(type:String, profileObj:TemplateProfileParser = null, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.profileObj = profileObj;
		}
		public override function clone():Event
		{
			return new PreviewThemeComEvent(type, profileObj, bubbles, cancelable);
		}
		
	}

}