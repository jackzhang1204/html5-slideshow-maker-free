package com.iyoya.utils.display 
{
	/**
	 * ...
	 * @author John Zhang
	 */
		import flash.display.BitmapData;
		import flash.display.DisplayObject;
		import flash.geom.Matrix;
		
		public function getDisplayObjectSameRatioBitmapData($target:DisplayObject, $width:Number, $height:Number, $fillStyle:String, $bgColor:uint, $transparent:Boolean):BitmapData
		{
			var sx:Number;
			var sy:Number;
			var dx:Number;
			var dy:Number;
			var newTargetW:Number;
			var newTargetH:Number;
			var finallyWidth:Number;
			var finallyHeight:Number;
			var targetWidth:Number = $target.width;
			var targetHeight:Number = $target.height;
			var unifiedRatio:Number = $width / $height;
			var targetRatio:Number = targetWidth / targetHeight;
			var matrix:Matrix = new Matrix();
			if ($fillStyle == "fit") 
			{
				if (unifiedRatio > targetRatio)
				{
					if ($width > targetWidth) 
					{
						if ($height < targetHeight)
						{
							finallyHeight = $height;
							finallyWidth = targetWidth / targetHeight * finallyHeight;
						}
						else
						{
							finallyWidth = targetWidth ;
							finallyHeight = targetHeight;
						}
					}
					else
					{
						finallyHeight = $height;
						finallyWidth = targetWidth / targetHeight * finallyHeight;
					}
				}
				else
				{
					if ($width > targetWidth) 
					{
						finallyWidth = targetWidth ;
						finallyHeight = targetHeight;
					}
					else
					{
						finallyWidth = $width;
						finallyHeight = targetHeight / targetWidth   * finallyWidth;
					}
				}
				sx = finallyWidth / targetWidth;
				sy = finallyHeight / targetHeight;
				matrix.scale(sx, sy);
			}
			else if($fillStyle == "fill")
			{
				if (unifiedRatio > targetRatio)
				{
					if (($width > targetWidth || $width == targetWidth) && ($height > targetHeight || $height == targetHeight))
					{
						newTargetW = targetWidth;
						newTargetH = targetHeight;
						finallyWidth = targetWidth;
						finallyHeight = targetHeight;
					}
					else
					{
						newTargetW = $width;
						newTargetH = targetHeight / targetWidth * newTargetW;
						finallyWidth = $width;
						finallyHeight = $height;
					}
				}
				else
				{
					if (($width > targetWidth || $width == targetWidth) && ($height > targetHeight || $height == targetHeight))
					{
						newTargetW = targetWidth;
						newTargetH = targetHeight;
						finallyWidth = targetWidth;
						finallyHeight = targetHeight;
					}
					else
					{
						newTargetH = $height;
						newTargetW = targetWidth / targetHeight * newTargetH;
						finallyWidth = $width;
						finallyHeight = $height;
					}
				}
				sx = newTargetW / targetWidth;
				sy = newTargetH / targetHeight;
				dx = -(newTargetW - finallyWidth) / 2;
				dy = -(newTargetH - finallyHeight) / 2;
				matrix.scale(sx, sy);
				matrix.translate(dx, dy);
			}
			var bitMapData:BitmapData = new BitmapData(finallyWidth, finallyHeight, false, 0);
			bitMapData.draw($target, matrix);
			$target = null;
			////////////
			matrix = new Matrix();
			var tx:Number = ($width - bitMapData.width) / 2;
			var ty:Number = ($height - bitMapData.height) / 2;
			matrix.translate(tx, ty);
			var newBitMapData:BitmapData;
			if($transparent)
			{
				newBitMapData = new BitmapData($width, $height, true, 0x00000000);
			}else{
				newBitMapData = new BitmapData($width, $height, false, $bgColor);
			}
			newBitMapData.draw(bitMapData, matrix);
			bitMapData.dispose();
			return newBitMapData;
		}
		
}