package com.iyoya.events.components.container.photo.preview
{
	import com.iyoya.data.AlbumDataParser;
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class PreviewPanelComEvent extends Event
	{
		public static const GET_ALBUM_DATA_PARSER:String = "getAlbumDataParser";
		public static const ALBUM_DATA_PARSER_UPDATE:String ="albumDataParserUpdate";
		public static const THUM_CONTAINER_SELECTED:String ="thumContainerSelected";
		public static const THUM_CONTAINER_UNSELECTED:String ="thumContainerUnselected";
		
		public var albumDataObj:AlbumDataParser;
		public var transitionId:String;
		public var transitionTimes:String;
		public var photoShowTimes:String;
		public var thumIndex:int;
		public function PreviewPanelComEvent(type:String, albumDataObj:AlbumDataParser = null, transitionId:String = "0", transitionTimes:String = "2", photoShowTimes:String = "2", thumIndex:int = 0, bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.albumDataObj = albumDataObj;
			this.transitionId = transitionId;
			this.transitionTimes = transitionTimes;
			this.photoShowTimes = photoShowTimes;
			this.thumIndex = thumIndex;
		}
		public override function clone():Event
		{
			return new PreviewPanelComEvent(type, albumDataObj, transitionId, transitionTimes, photoShowTimes, thumIndex, bubbles, cancelable);
		}
	}
}