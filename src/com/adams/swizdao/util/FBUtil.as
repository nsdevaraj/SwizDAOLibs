/*
* Copyright 2010 @nsdevaraj
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package com.adams.swizdao.util {
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.Stage;
	import flash.media.CameraUI;
	import flash.media.StageWebView;
	
	public class FBUtil
	{
	    public static  var facebookWebView : StageWebView;
		public static  var mobileCam : CameraUI;
		
		public static function initMobileCam():void{
			mobileCam = new CameraUI();
		}
		
		public static function initfacebookWebView():void{
			facebookWebView = new StageWebView();
		}
		
		public static function faceBookLogin( loginHandler:Function, stg:Stage, permissions:Array, facebookWeb:StageWebView):void{
			FacebookMobile.login(loginHandler, stg, permissions, facebookWeb);
		} 
	}
}