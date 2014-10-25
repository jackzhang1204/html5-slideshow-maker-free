package com.anvsoft.components.container.photo.setting
{
	import com.anvsoft.components.container.photo.setting.transition.EffectContainerCom;
	import com.anvsoft.components.container.photo.setting.transition.popup.DefineRandomSetPopupCom;
	import com.anvsoft.events.CommandDispatcher;
	import com.anvsoft.events.components.container.photo.preview.PreviewPanelComEvent;
	import com.anvsoft.events.components.container.photo.setting.TransitionPanelComEvent;
	import com.anvsoft.utils.language.LanguageManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.SWFLoader;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.TileGroup;

	public class TransitionPanelAS extends Group
	{
		public var effectsTileGroup:TileGroup;
		public var transDuration:TextInput;
		public var photoShowDuration:TextInput;
		public var applyToSelected:Button;
		public var applyToAll:Button;
		public var defineRandomSet:Button;
		public var transitionLoader:SWFLoader;
		
		public var previewLabel:Label;
		public var transEffectsLabel:Label;
		public var transDurationLabel:Label;
		public var photoShowDurLabel:Label;
		
		private var transitionMc:MovieClip;
		private var effectsFolderPath:String = AppMain.global_app_assets_folder + "transition/effects/";
		private var transitionXMLName:String = "transition.xml";
		private var preSelectedItem:EffectContainerCom;
		private var urlLoader:URLLoader;
		private var transArrayCollection:ArrayCollection  = new ArrayCollection();
		
		public function TransitionPanelAS()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			///////////////////////
			transitionMc = transitionLoader.content as MovieClip;
			loadTransitionConfigFile();
			effectsTileGroup.addEventListener(MouseEvent.CLICK, effectsTileGroupClickHandler);
			applyToSelected.addEventListener(MouseEvent.CLICK, applyToSelectedClickHandler);
			applyToAll.addEventListener(MouseEvent.CLICK, applyToAllClickHandler);
			defineRandomSet.addEventListener(MouseEvent.CLICK, defineRandomSetClickHandler);
			CommandDispatcher.getInstance().addEventListener(PreviewPanelComEvent.THUM_CONTAINER_SELECTED, thumContainerSelected);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(previewLabel, "text", "20003", "string", ":");
			LanguageManager.getInstance().binding(transEffectsLabel, "text", "20004", "string", ":");
			LanguageManager.getInstance().binding(transDurationLabel, "text", "20005");
			LanguageManager.getInstance().binding(applyToSelected, "label", "20006");
			LanguageManager.getInstance().binding(photoShowDurLabel, "text", "20007");
			LanguageManager.getInstance().binding(applyToAll, "label", "20008");
			LanguageManager.getInstance().binding(defineRandomSet, "label", "20009");
		}
		private function loadTransitionConfigFile():void
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			urlLoader.load(new URLRequest(effectsFolderPath + transitionXMLName));
		}
		private function xmlLoadCompleteHandler(e:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			////////////
			
			var transitionXml:XML = XML(e.target.data);
			//transition_data////////////
			var transitionData:XMLList = transitionXml.transition_data;
			var listLen:uint = transitionData.length();
			for(var i:uint = 0; i < listLen; i++)
			{
				var effectImgURL:String = effectsFolderPath + transitionData[i].@thumbnail_image;
				//var effectTitle:String = transitionData[i].@description;
				var effectIndex:uint = uint(transitionData[i].@id);
				//var effectEnabled:String = transitionData[i].@enabled;
				/////////////
				var effectContainerCom:EffectContainerCom = new EffectContainerCom();
				effectContainerCom.url = effectImgURL;
				//effectContainerCom.title = effectTitle;
				
				var key:String = (70000 + i).toFixed();
				LanguageManager.getInstance().binding(effectContainerCom, "title", key);
				
				effectContainerCom.index = effectIndex;
				/*if(effectEnabled == "true")
				{
					effectContainerCom.enabled = true;
				}else{
					effectContainerCom.enabled = false;
				}*/
				effectsTileGroup.addElement(effectContainerCom);
				effectContainerCom.doubleClickEnabled = true;
				effectContainerCom.addEventListener(MouseEvent.CLICK, effectContainerClickHandler);
				effectContainerCom.addEventListener(MouseEvent.DOUBLE_CLICK, effectContainerComDoubleClick);
				//add ArrayCollection item/////////
				if(i > 0)
				{
					var itemObj:Object = new Object();
					itemObj.id = transitionData[i].@id;
					//itemObj.name = transitionData[i].@description;
					transArrayCollection.addItem(itemObj);
				}
				///////////////////////////////////
			}	
		}
		private function effectsTileGroupClickHandler(e:Event):void
		{
			if(e.target == e.currentTarget)
			{
				if(preSelectedItem != null)
				{
					preSelectedItem.removeSelect();
					preSelectedItem = null;
				}
			}
		}
		private function effectContainerClickHandler(e:MouseEvent):void
		{
			var currentEffectContainer:EffectContainerCom = e.currentTarget as EffectContainerCom;
			selectEffectContainer(currentEffectContainer);
			/////////////
			setTransitionEffect(currentEffectContainer.index);
		}
		private function selectEffectContainer($currentEffectContainer:EffectContainerCom):void
		{
			if(preSelectedItem)
			{
				preSelectedItem.removeSelect();
			}
			$currentEffectContainer.onSelect();
			preSelectedItem = $currentEffectContainer;
		}
		private function effectContainerComDoubleClick(e:MouseEvent):void
		{
			applyTransitionEffect("applyToSelected");
		}
		private function applyToSelectedClickHandler(e:MouseEvent):void
		{
			applyTransitionEffect("applyToSelected");
		}
		private function applyToAllClickHandler(e:MouseEvent):void
		{
			applyTransitionEffect("applyToAll");
		}
		private function applyTransitionEffect($applyType:String = "applyToSelected"):void
		{
			var transitionId:String;
			var transitionImgURL:String;
			if(preSelectedItem)
			{
				transitionId = (preSelectedItem.index).toString();
				transitionImgURL = preSelectedItem.url;
			}else{
				transitionId = null;
				transitionImgURL = null;
			}
			var transitionTimes:String = transDuration.text;
			var photoShowTimes:String = photoShowDuration.text;
			var applyType:String = $applyType;
			CommandDispatcher.getInstance().dispatchEvent(new TransitionPanelComEvent(TransitionPanelComEvent.SET_TRANSITION_EFFECT, transitionId, transitionImgURL, transitionTimes, photoShowTimes, applyType));
		}
		private function defineRandomSetClickHandler(e:MouseEvent):void
		{
			var defineRandomSetPopupCom:DefineRandomSetPopupCom = DefineRandomSetPopupCom(PopUpManager.createPopUp(this, DefineRandomSetPopupCom , true));
			defineRandomSetPopupCom.dgArrayCollection = transArrayCollection;
		}
		private function thumContainerSelected(e:PreviewPanelComEvent):void
		{
			transDuration.text = e.transitionTimes;
			photoShowDuration.text = e.photoShowTimes;
			var index:int = int(e.transitionId);
			var currentEffectContainer:EffectContainerCom = effectsTileGroup.getElementAt(index) as EffectContainerCom;
			selectEffectContainer(currentEffectContainer);
			effectsTileGroup.verticalScrollPosition = currentEffectContainer.y - effectsTileGroup.paddingTop;
			/////////////
			setTransitionEffect(currentEffectContainer.index);
		}
		private function setTransitionEffect(transId:int):void
		{
			transitionMc.settingTransitionId(transId);
		}
	}
}