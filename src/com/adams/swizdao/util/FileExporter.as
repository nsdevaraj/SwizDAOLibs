package com.adams.swizdao.util {
	import cmodule.as3_jpeg_wrapper.CLibInit;

	import mx.core.UIComponent;

	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class FileExporter {
			
		private static var as3_jpeg_wrapper: Object;
		private static var loader:CLibInit = new CLibInit();
		public static var makeupFile:File; 
		public static function saveImage(targetPanel : UIComponent, cordPanel : UIComponent) : void {
			if(!as3_jpeg_wrapper)as3_jpeg_wrapper = loader.init();
			saveImageData(getUIComponentBitmapData(targetPanel, cordPanel));
		}

		public static function saveImageData(newBitdata : BitmapData) : void {
			var btArray : ByteArray = encodeToJPEG(newBitdata, 100);
			var stream:FileStream = new FileStream();
			makeupFile= File.createTempFile();
            stream.open(makeupFile,FileMode.WRITE);
            stream.writeBytes(btArray);
            stream.close();
		} 

		public static function getUIComponentBitmapData(target : UIComponent, cord : UIComponent) : BitmapData {
			var resultBitmapData : BitmapData = new BitmapData(cord.width, cord.height);
			var m : Matrix = new Matrix();
			resultBitmapData.draw(target, m);
			return resultBitmapData;
		}

		public static function encodeToJPEG(data : BitmapData, quality : Number = 100) : ByteArray {
			if(!as3_jpeg_wrapper)as3_jpeg_wrapper = loader.init();
			var baSource:ByteArray=data.clone().getPixels(new Rectangle(0,0,data.width,data.height));
			return as3_jpeg_wrapper.write_jpeg_file(baSource, data.width,data.height, 3, 2, quality); 
		}
	}
}