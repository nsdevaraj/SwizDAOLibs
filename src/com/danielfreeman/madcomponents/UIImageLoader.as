﻿/** * <p>Original Author: Daniel Freeman</p> * * <p>Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions:</p> * * <p>The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software.</p> * * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE.</p> * * <p>Licensed under The MIT License</p> * <p>Redistributions of files must retain the above copyright notice.</p> */package com.danielfreeman.madcomponents{	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.*;	import flash.net.URLRequest;	import flash.utils.Dictionary;
/** * The image was loaded sucessfully */	[Event( name="imageLoaded", type="flash.events.Event" )]	/** * There was an error loading the image */	[Event( name="error", type="flash.events.ErrorEvent" )]/** *  Image placeholder for image set via URL * <pre> * &lt;imageLoader *    id = "IDENTIFIER" *    alignH = "left|right|centre|fill" *    alignV = "top|bottom|centre|fill" *    visible = "true|false" *    width = "NUMBER" *    height = "NUMBER" *    base = "URL" *    clickable = "true|false" *    cache = "true|false" *    scale = "true|false" * /&gt; * </pre> */	public class UIImageLoader extends UIImage {				public static const LOADED:String = "imageLoaded";				protected static var imageCache:Dictionary = new Dictionary();				protected var _base:String = "";		protected var _error:*;		protected var _cache:Boolean = false;						public static function clearCache(url:String = ""):void {			if (url=="") {				imageCache = new Dictionary();			}			else {				delete imageCache[url];			}		}				public function UIImageLoader(screen:Sprite, xml:XML, attributes:Attributes) {			if (xml.@base.length()>0)				_base = xml.@base[0];			_cache = xml.@cache == "true";			super(screen, xml, attributes);		}/** *  Set URL of image */		override public function set value(value:String):void {			if (_cache) {				var cacheValue:BitmapData = imageCache[value];				if (cacheValue!=null) {					image = cacheValue;					dispatchEvent(new Event(LOADED, true, true));				}				else {					loadURLImage(value);				}			}			else {				loadURLImage(value);			}		}		/** *  Load image from URL */		protected function loadURLImage(url:String):void {			var loader:Loader = new Loader();			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, isLoaded);			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorFn);			loader.addEventListener(IOErrorEvent.IO_ERROR, errorFn);			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorFn);			var request:URLRequest = new URLRequest(_base+url);			try {				loader.load(request);			}			catch (error:Error) {				_error = error;				dispatchEvent(new Event(ErrorEvent.ERROR));			}		}/** *  Error handler */		protected function errorFn(event:*):void {			_error = event;			dispatchEvent(new Event(ErrorEvent.ERROR));		}		/** *  Error object */		public function get error():* {			return _error;		}/** *  Image loaded handler */		protected function isLoaded(event:Event):void {			var loader:Loader = event.target.loader;			image = Bitmap(loader.content);			if (_cache) {				var loaderInfo:LoaderInfo = LoaderInfo(event.target);				var bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, true);				bitmapData.draw(_image);				imageCache[loader.contentLoaderInfo.url] = bitmapData;			}			dispatchEvent(new Event(LOADED, true, true));		}	}}