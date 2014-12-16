package com.iyoya.events.components.container.theme.basic.properties
{
	import flash.events.Event;
	
	public class PropertiesPanelComEvent extends Event
	{
		public static const UPDATE_PROPERTIES_PANEL:String = "updatePropertiesPanel";
		public static const GET_PROPERTIES_PANEL_DATA:String = "getPropertiesPanelData";
		public static const PROPERTIES_DATA_UPDATE:String = "propertiesDataUpdate";
		
		public var propertiesObj:Object;
		public function PropertiesPanelComEvent(type:String, propertiesObj:Object = null, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.propertiesObj = propertiesObj;
		}
		public override function clone():Event
		{
			return new PropertiesPanelComEvent(type, propertiesObj, bubbles, cancelable);
		}
		
	}
	
}