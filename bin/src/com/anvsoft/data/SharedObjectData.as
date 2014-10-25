package com.anvsoft.data
{
	import flash.net.SharedObject;
	
	public class SharedObjectData
	{
		private static var signinSOName:String = "go2album_login_info";
		
		public static function getSigninInfo():Object
		{
			var signinSO:SharedObject = SharedObject.getLocal(signinSOName, "/");
			var signinData:Object = signinSO.data;
			if(signinData.username == null || signinData.password == null)
			{
				signinData.username = "";
				signinData.password = "";
			}
			return signinData;
		}
		public static function saveSigninInfo($username:String, $password:String):void
		{
			if($username != "" && $password != "")
			{
				var signinSO:SharedObject = SharedObject.getLocal(signinSOName, "/");
				signinSO.data.username = $username;
				signinSO.data.password = $password;
				signinSO.flush();
			}
		}
	}
}