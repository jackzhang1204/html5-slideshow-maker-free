package com.iyoya.components.container.photo.setting.transition.popup
{
	import com.iyoya.events.CommandDispatcher;
	import com.iyoya.events.ConfigFileEvent;
	import com.iyoya.events.components.container.photo.setting.transition.popup.DefineRandomSetPopupComEvent;
	import com.iyoya.utils.language.LanguageManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.DataGrid;
	import spark.components.Label;
	import spark.components.TitleWindow;

	public class DefineRandomSetPopupAS extends TitleWindow
	{
		public var okButton:Button;
		public var cancelButton:Button;
		public var selectAll:CheckBox;
		public var dataGrid:DataGrid;
		public var vGroupLabel:Label;
		
		public var transitionVector:Vector.<String> = new Vector.<String>();
		[Bindable]
		public var dgArrayCollection:ArrayCollection;
		
		public function DefineRandomSetPopupAS()
		{
			super();
			///////////////
			if(AppMain.global_transition_array != "")
			{
				var transArray:Array = AppMain.global_transition_array.split(",");
				transitionVector = Vector.<String>(transArray);
			}
			/////////////////
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(CloseEvent.CLOSE, cancelButtonClickHandler);
		}
		private function creationCompleteHandler(e:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			/////////////////
			this.x = Math.round((this.parent.width - this.width)/2);
			this.y = Math.round((this.parent.height - this.height)/2);
			updateItemRenderer();
			////////////////
			okButton.addEventListener(MouseEvent.CLICK, okButtonClickHandler);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
			selectAll.addEventListener(MouseEvent.CLICK, selectAllClickHandler);
			initLanguage();
		}
		private function initLanguage():void
		{
			LanguageManager.getInstance().binding(this, "title", "20010");
			LanguageManager.getInstance().binding(vGroupLabel, "text", "20011");
			LanguageManager.getInstance().binding(selectAll, "label", "20012");
			LanguageManager.getInstance().binding(okButton, "label", "10001");
			LanguageManager.getInstance().binding(cancelButton, "label", "10002");
		}
		private function updateItemRenderer():void
		{
			var transLen:int = transitionVector.length;
			if(transLen > 0)
			{
				for(var i:int = 0; i < transLen; i++)
				{
					var index:int = int(transitionVector[i]) - 1;
					dataGrid.dataProvider.getItemAt(index).select = true;
				}
				transLen == dgArrayCollection.length ? selectAll.selected = true : null;
				///////////////////
				CommandDispatcher.getInstance().dispatchEvent(new DefineRandomSetPopupComEvent(DefineRandomSetPopupComEvent.UPDATE_ITEM_RENDERER));
			}
		}
		private function okButtonClickHandler(e:MouseEvent):void
		{
			AppMain.global_transition_array = transitionVector.join();
			CommandDispatcher.getInstance().dispatchEvent(new ConfigFileEvent(ConfigFileEvent.SAVE_CONFIG_FILE));
			//trace(Main.global_transition_array);
			PopUpManager.removePopUp(this);
			removeAllEventListener();
		}
		private function cancelButtonClickHandler(e:Event):void
		{
			PopUpManager.removePopUp(this);
			removeAllEventListener();
		}
		private function selectAllClickHandler(e:MouseEvent):void
		{
			var aryCollLen:int = dgArrayCollection.length;
			transitionVector = new Vector.<String>();
			if(CheckBox(e.target).selected)
			{
				for(var i:int = 0; i < aryCollLen; i++)
				{
					transitionVector.push(i + 1);
					dataGrid.dataProvider.getItemAt(i).select = true;
				}
				////////////////////////////
				CommandDispatcher.getInstance().dispatchEvent(new DefineRandomSetPopupComEvent(DefineRandomSetPopupComEvent.SELECT_ALL_TRANSITION));
			}else{
				for(var j:int = 0; j < aryCollLen; j++)
				{
					dataGrid.dataProvider.getItemAt(j).select = false;
				}
				////////////////////////////
				CommandDispatcher.getInstance().dispatchEvent(new DefineRandomSetPopupComEvent(DefineRandomSetPopupComEvent.SELECT_OUT_ALL_TRANSITION));
			}
		}
		private function removeAllEventListener():void
		{
			removeEventListener(CloseEvent.CLOSE, cancelButtonClickHandler);
			okButton.removeEventListener(MouseEvent.CLICK, okButtonClickHandler);
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
			selectAll.removeEventListener(MouseEvent.CLICK, selectAllClickHandler);
			okButton = null;
			cancelButton = null;
			selectAll = null;
			dataGrid = null;
		}
	}
}