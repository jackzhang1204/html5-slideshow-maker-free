package com.anvsoft.events.components.container.photo.setting
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Zhang
	 */
	public class TransitionPanelComEvent extends Event
	{
		public static const SET_TRANSITION_EFFECT:String = "setTransitionEffect";
		
		public var transitionId:String;
		public var transitionImgURL:String;
		public var transitionTimes:String;
		public var photoShowTimes:String;
		public var applyType:String;
		
		public function TransitionPanelComEvent(type:String, transitionId:String = "0", transitionImgURL:String = "", transitionTimes:String = "2", photoShowTimes:String = "2", applyType:String = "applyToSelected", bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			this.transitionId = transitionId;
			this.transitionImgURL = transitionImgURL;
			this.transitionTimes = transitionTimes;
			this.photoShowTimes = photoShowTimes;
			this.applyType = applyType;
		}
		public override function clone():Event
		{
			return new TransitionPanelComEvent(type, transitionId, transitionImgURL, transitionTimes, photoShowTimes, applyType, bubbles, cancelable);
		}
	}
}