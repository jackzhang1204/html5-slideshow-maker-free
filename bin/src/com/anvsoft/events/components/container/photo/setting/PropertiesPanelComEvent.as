package com.anvsoft.events.components.container.photo.setting
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class PropertiesPanelComEvent extends Event
	{
		public static const SET_IMAGE_PROPERTIES:String = "setImageProperties";
		
		public var imgTitle:String;
		public var imgDescription:String;
		public var imgURL:String;
		public var applyType:String;
		public function PropertiesPanelComEvent(type:String, imgTitle:String = "", imgDescription:String = "", imgURL:String = "", applyType:String = "applyToSelected", bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.imgTitle = imgTitle;
			this.imgDescription = imgDescription;
			this.imgURL = imgURL;
			this.applyType = applyType;
		}
		public override function clone():Event
		{
			return new PropertiesPanelComEvent(type, imgTitle, imgDescription, imgURL, applyType, bubbles, cancelable);
		}
	}
}