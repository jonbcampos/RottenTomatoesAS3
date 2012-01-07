/**
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
package com.rottentomatoes.events
{
	import flash.events.Event;
	
	/**
	 * Result Event from any of the Rotten Tomatoes Services.
	 * @author jonbcampos
	 * 
	 */
	public class RottenTomatoesResultEvent extends Event
	{
		public static const RESULT:String = "result";
		
		public static const MOVIE_SEARCH_RESULT:String = "movieSearchResult";
		
		public static const OPENING_MOVIES_RESULT:String = "openingMoviesResult";
		public static const UPCOMING_MOVIES_RESULT:String = "upcomingMoviesResult";
		public static const IN_THEATERS_RESULT:String = "inTheatersResult";
		public static const BOX_OFFICE_RESULT:String = "boxOfficeResult";
		
		public static const UPCOMING_DVDS_RESULT:String = "upcomingDvdsResult";
		public static const NEW_RELEASE_DVDS_MOVIES_RESULT:String = "newReleaseDvdsResult";
		public static const CURRENT_RELEASE_DVDS_MOVIES_RESULT:String = "currentReleaseDvdsResult";
		public static const TOP_RENTALS_RESULT:String = "topRentalsResult";
		
		public static const MOVIE_INFO_RESULT:String = "movieInfoResult";
		public static const MOVIE_CAST_RESULT:String = "movieCastResult";
		public static const MOVIE_REVIEWS_RESULT:String = "movieReviewsResult";
		public static const MOVIE_SIMILARS_RESULT:String = "movieSimilarsResult";
		public static const MOVIE_CLIPS_RESULT:String = "movieClipsResult";
		
		private var _result:Object;
		/**
		 * Returned object in valid value objects and models. 
		 * @return 
		 * 
		 */		
		public function get result():Object { return _result; }
		
		private var _url:String;
		/**
		 * URL for this result.
		 * @return 
		 * 
		 */		
		public function get url():String { return _url; }
		
		private var _total:int;
		public function get total():int { return _total; }
		
		private var _serviceType:String;
		public function get serviceType():String { return _serviceType; }
		
		public function RottenTomatoesResultEvent(type:String, result:Object = null, url:String = null, total:int=0, serviceType:String=null)
		{
			super(type);
			_result = result;
			_url = url;
			_total = total;
			_serviceType = serviceType;
		}
		
		override public function clone():Event
		{
			return new RottenTomatoesResultEvent(type, result, url, total, serviceType);
		}
	}
}