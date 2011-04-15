/*
* Copyright (c) 2011 RottenTomatoes_API Contributors.
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of 
* this software and associated documentation files (the "Software"), to deal in 
* the Software without restriction, including without limitation the rights to 
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
* of the Software, and to permit persons to whom the Software is furnished to do 
* so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all 
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE. 
* */
package com.rottentomatoes.utils
{
	/**
	 * "Creatively" borrowed from Iotashan OAuth.
	 * 
	 * @author jonbcampos
	 * 
	 * @see http://code.google.com/p/oauth-as3/source/browse/trunk/src/org/iotashan/utils/URLEncoding.as
	 */	
	public class URLEncoding
	{
		public function URLEncoding()
		{
		}
		
		/**
		 * Does proper UTF-8 encoding
		 */
		public static function utf8Encode(string:String):String {
			string = string.replace(/\r\n/g, '\n');
			string = string.replace(/\r/g, '\n');
			
			var utfString:String = '';
			
			for (var i:int = 0 ; i < string.length ; i++)
			{
				var chr:Number = string.charCodeAt(i);
				if (chr < 128)
				{
					utfString += String.fromCharCode(chr);
				}
				else if ((chr > 127) && (chr < 2048))
				{
					utfString += String.fromCharCode((chr >> 6) | 192);
					utfString += String.fromCharCode((chr & 63) | 128);
				}
				else
				{
					utfString += String.fromCharCode((chr >> 12) | 224);
					utfString += String.fromCharCode(((chr >> 6) & 63) | 128);
					utfString += String.fromCharCode((chr & 63) | 128);
				}
			}
			
			return utfString;
		}
		
		/**
		 * Does the URL encoding
		 */
		public static function urlEncode(string:String):String {
			var urlString:String = '';
			
			for (var i:int = 0 ; i < string.length ; i++)
			{
				var chr:Number = string.charCodeAt(i);
				
				if ((chr >= 48 && chr <= 57) || // 09
					(chr >= 65 && chr <= 90) || // AZ
					(chr >= 97 && chr <= 122) || // az
					chr == 45 || // -
					chr == 95 || // _
					chr == 46 || // .
					chr == 126) // ~
				{
					urlString += String.fromCharCode(chr);
				}
				else
				{
					urlString += '%' + chr.toString(16).toUpperCase();
				}
			}
			
			return urlString;
		}
		
		/**
		 * Properly URL encodes a string, taking into account UTF-8
		 */
		public static function encode(string:String):String {
			return urlEncode(utf8Encode(string));
		}
		
		/**
		 * Decodes a string from a URL compliant format.
		 * 
		 * @param encodedString String to be decoded
		 */
		public static function decode(encodedString:String):* {
			var output:String = encodedString;
			var myregexp:RegExp = /(%[^%]{2})/;
			
			var binVal:Number;
			var thisString:String;
			
			var match:Object;
			
			// change "+" to spaces
			var plusPattern:RegExp = /\+/gm;
			output = output.replace(plusPattern," ");
			
			// convert all other characters
			while ((match = myregexp.exec(output)) != null && match.length > 1 && match[1] != '') {
				binVal = parseInt(match[1].substr(1),16);
				thisString = String.fromCharCode(binVal);
				output = output.replace(match[1], thisString);
			}
			
			return output;
		}
	}
}