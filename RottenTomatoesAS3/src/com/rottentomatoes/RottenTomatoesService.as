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
package com.rottentomatoes
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import com.rottentomatoes.events.RottenTomatoesFaultEvent;
	import com.rottentomatoes.events.RottenTomatoesResultEvent;
	import com.rottentomatoes.utils.ConvertUtil;
	import com.rottentomatoes.utils.URLEncoding;
	import com.rottentomatoes.vos.ServiceFault;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * General result. If you are listening to this result event
	 * type rather than the specific result event type you will
	 * still receive the result data, you just won't know which
	 * speific service function that the handler comes from.
	 * 
	 * Depending on your application this may not matter. 
	 */	
	[Event(name="result", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	
	[Event(name="movieSearchResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	
	[Event(name="openingMoviesResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="upcomingMoviesResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="inTheatersResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="boxOfficeResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	
	[Event(name="upcomingDvdsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="newReleaseDvdsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="currentReleaseDvdsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="topRentalsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	
	[Event(name="movieInfoResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="movieCastResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="movieReviewsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="movieSimilarsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	[Event(name="movieClipsResult", type="com.rottentomatoes.events.RottenTomatoesResultEvent")]
	
	[Event(name="activate", type="flash.events.Event")]
	[Event(name="deactivate", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="open", type="flash.events.Event")]
	/**
	 * Not really meant to be listened to, created for
	 * binding mainly. 
	 */	
	[Event(name="lastResultChanged", type="flash.events.Event")]
	
	[Event(name="httpResponseStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	[Event(name="fault", type="com.rottentomatoes.events.RottenTomatoesFaultEvent")]
	
	[Event(name="progress", type="flash.events.ProgressEvent")]

	/**
	 * 
	 * @author jonbcampos
	 * 
	 */	
	public class RottenTomatoesService extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		//  Constructor
		//
		//---------------------------------------------------------------------
		public function RottenTomatoesService(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//---------------------------------------------------------------------
		//
		//  Static Consts
		//
		//---------------------------------------------------------------------
		private static const ROTTEN_TOMATOES_BASE_URL:String = "http://api.rottentomatoes.com/api/public/v1.0";
		
		private static const MOVIE_SEARCH_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/movies.json?q={search-term}&page_limit={results-per-page}&page={page-number}";
		
		private static const OPENING_MOVIES_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/opening.json?limit={num_results}&country={country-code}";
		private static const UPCOMING_MOVIES_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/upcoming.json?page_limit={results_per_page}&page={page_number}&country={country-code}";
		private static const IN_THEATERS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/in_theaters.json?page_limit={results_per_page}&page={page_number}&country={country-code}";
		private static const BOX_OFFICE_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/box_office.json?limit={num-results}&country={country-code}";
		
		private static const UPCOMING_DVDS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/upcoming.json?page_limit={results-per-page}&page={page-number}&country={country-code}";
		private static const NEW_RELEASE_DVDS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/new_releases.json?page_limit={results-per-page}&page={page-number}&country={country-code}";
		private static const CURRENT_RELEASE_DVDS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/current_releases.json?page_limit={results-per-page}&page={page-number}&country={country-code}";
		private static const TOP_RENTALS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/top_rentals.json?limit={num-results}&country={country-code}";
		
		private static const MOVIE_INFO_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/movies/{movie-id}.json";
		private static const MOVIE_CAST_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/movies/{movie-id}/cast.json";
		private static const MOVIE_CLIPS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/movies/{movie-id}/clips.json";
		private static const MOVIE_SIMILARS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/movies/{movie-id}/similar.json";
		private static const MOVIE_REVIEWS_TEMPLATE:String = ROTTEN_TOMATOES_BASE_URL+"/movies/{movie-id}/reviews.json?review_type={top_critic|all|dvd}&page_limit={results-per-page}&page={page-number}&country={country-code}";
		
		//---------------------------------------------------------------------
		//
		//  Private Properties
		//
		//---------------------------------------------------------------------
		private var _urlLoaders:Vector.<RottenTomatoesLoader>;
		private var _inUseLoaders:Object;
		//---------------------------------------------------------------------
		//
		//  Public Properties
		//
		//---------------------------------------------------------------------
		public var apikey:String;
		
		private var _lastResult:Object;
		[Bindable(event="lastResultChanged")]
		public function get lastResult():Object { return _lastResult; }
		
		//---------------------------------------------------------------------
		//
		//  Public Methods
		//
		//---------------------------------------------------------------------
		/**
		 * The movies search endpoint for plain text queries. Let's you search for movies!
		 *  
		 * @param term The plain text search query to search for a movie.
		 * @param pageLimit The amount of movie search results to show per page.
		 * @param page The selected page of movie search results.
		 * 
		 */		
		public function getMoviesByTerm(term:String, pageLimit:int=30, page:int=1):void
		{
			//no api check
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//term check
			if(!term)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("Service Fault", "Term Missing","You need to specify a term to search with this call.",0)));
				return;
			} else {
				term = StringUtil.trim(term);
			}
			//call service
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/movies.json?apikey="+apikey+"&q="+URLEncoding.encode(term)+"&page_limit="+pageLimit+"&page="+page;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = MOVIE_SEARCH_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.MOVIE_SEARCH_RESULT;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * Retrieves current opening movies.
		 * 
		 * @param pageLimit Limits the number of opening movies returned.
		 * @param country Provides localized data for the selected country (ISO 3166-1 alpha-2) if available. Otherwise, returns US data.
		 * 
		 * @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
		 */		
		public function getOpeningMovies(pageLimit:int=16, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//service call
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/opening.json?apikey="+apikey+"&limit="+pageLimit+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = OPENING_MOVIES_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.OPENING_MOVIES_RESULT;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * Retrieves upcoming movies. Results are paginated if they go past the specified page limit.
		 *  
		 * @param pageLimit The amount of upcoming movies to show per page.
		 * @param page The selected page of upcoming movies.
		 * @param country Provides localized data for the selected country (ISO 3166-1 alpha-2) if available. Otherwise, returns US data.
		 * 
		 * @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
		 */		
		public function getUpcomingMovies(pageLimit:int=16, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//call service
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/upcoming.json?apikey="+apikey+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = UPCOMING_MOVIES_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.UPCOMING_MOVIES_RESULT;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * Retrieves movies currently in theaters.
		 *  
		 * @param pageLimit The amount of movies in theaters to show per page.
		 * @param page The selected page of in theaters movies.
		 * @param country Provides localized data for the selected country (ISO 3166-1 alpha-2) if available. Otherwise, returns US data.
		 * 
		 * @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
		 */		
		public function getInTheaterMovies(pageLimit:int=16, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//call service
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/in_theaters.json?apikey="+apikey+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = IN_THEATERS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.IN_THEATERS_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getBoxOfficeMovies(pageLimit:int=16, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//call service
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/movies/box_office.json?apikey="+apikey+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = BOX_OFFICE_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.BOX_OFFICE_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getTopRentals(pageLimit:int=16, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//service call
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/top_rentals.json?apikey="+apikey+"&page_limit="+pageLimit+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = TOP_RENTALS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.TOP_RENTALS_RESULT;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * Retrieves new release dvds. Results are paginated if they go past the specified page limit.
		 *  
		 * @param pageLimit The amount of new release dvds to show per page.
		 * @param page The selected page of upcoming movies.
		 * @param country Provides localized data for the selected country (ISO 3166-1 alpha-2) if available. Otherwise, returns US data.
		 * 
		 * @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
		 */		
		public function getNewReleaseDvd(pageLimit:int=16, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//service call
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/new_releases.json?apikey="+apikey+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = NEW_RELEASE_DVDS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.NEW_RELEASE_DVDS_MOVIES_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getCurrentReleaseDvd(pageLimit:int=16, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//service call
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/current_releases.json?apikey="+apikey+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = CURRENT_RELEASE_DVDS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.CURRENT_RELEASE_DVDS_MOVIES_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getUpcomingDvd(pageLimit:int=16, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			//page less than 1 check
			if(page<1) page = 1;
			//pageLimit minimum check
			if(pageLimit<1) pageLimit = 1;
			//country check
			if(!country) country = "us";
			//service call
			var url:String = ROTTEN_TOMATOES_BASE_URL+"/lists/dvds/upcoming.json?apikey="+apikey+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = UPCOMING_DVDS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.UPCOMING_DVDS_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getMovieByUrl(url:String):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			var url:String = url+"?apikey="+apikey;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = MOVIE_INFO_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.MOVIE_INFO_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getMovieById(id:String):void
		{
			getMovieByUrl(ROTTEN_TOMATOES_BASE_URL+"/movies/"+id+".json");
		}
		
		public function getMovieCastByUrl(url:String):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			var url:String = url+"?apikey="+apikey;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = MOVIE_CAST_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.MOVIE_CAST_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getMovieCastById(id:String):void
		{
			getMovieCastByUrl(ROTTEN_TOMATOES_BASE_URL+"/movies/"+id+"/cast.json");
		}
		
		public function getMovieClipsByUrl(url:String):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			var url:String = url+"?apikey="+apikey;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = MOVIE_CLIPS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.MOVIE_CLIPS_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getMovieClipsById(id:String):void
		{
			getMovieClipsByUrl(ROTTEN_TOMATOES_BASE_URL+"/movies/"+id+"/clips.json");
		}
		
		public function getMovieSimilarsByUrl(url:String):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			var url:String = url+"?apikey="+apikey;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = MOVIE_SIMILARS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.MOVIE_SIMILARS_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getMovieSimilarsById(id:String):void
		{
			getMovieSimilarsByUrl(ROTTEN_TOMATOES_BASE_URL+"/movies/"+id+"/similar.json");
		}
		
		public function getMovieReviewByUrl(url:String, reviewType:String="top_critic", pageLimit:int=20, page:int=1, country:String="us"):void
		{
			if(!apikey)
			{
				if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
					dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("API Fault", "API Key Missing","You need to set the api key prior to making this call.",0)));
				return;
			}
			var type:String;
			switch(reviewType)
			{
				case "all":
					type = "all";
					break;
				case "dvd":
					type = "dvd";
					break;
				default:
					type = "top_critic";
					break;
			}
			var url:String = url+"?apikey="+apikey+"&review_type="+type+"&page_limit="+pageLimit+"&page="+page+"&country="+country;
			var loader:RottenTomatoesLoader = _getUrlLoader(url);
			loader.type = MOVIE_REVIEWS_TEMPLATE;
			loader.returnType = RottenTomatoesResultEvent.MOVIE_REVIEWS_RESULT;
			loader.load(new URLRequest(url));
		}
		
		public function getMovieReviewById(id:String, reviewType:String="top_critic", pageLimit:int=20, page:int=1, country:String="us"):void
		{
			getMovieReviewByUrl(ROTTEN_TOMATOES_BASE_URL+"/movies/"+id+"/reviews.json", reviewType, pageLimit, page, country);
		}
		//---------------------------------------------------------------------
		//
		//  Handler Methods
		//
		//---------------------------------------------------------------------
		private function _onLoader_ActivateHandler(event:Event):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_DeactivateHandler(event:Event):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_OpenHandler(event:Event):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_ProgressHandler(event:ProgressEvent):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_StatusHandler(event:HTTPStatusEvent):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
			var loader:RottenTomatoesLoader = event.target as RottenTomatoesLoader;
			loader.httpStatus = event.status;
		}
		
		private function _onLoader_IOErrorHandler(event:IOErrorEvent):void
		{
			var loader:RottenTomatoesLoader = event.target as RottenTomatoesLoader;
			_releaseUrlLoader(loader.url);
			
			if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
				dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault(event.errorID.toFixed(0),event.type, event.text, loader.httpStatus)));
		}
		
		private function _onLoader_CompleteHandler(event:Event):void
		{
			var loader:RottenTomatoesLoader = event.target as RottenTomatoesLoader;
			if(loader.data.toString().indexOf("Unrecognized domain")>-1)
			{
				dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("Unknown",loader.data.toString(), "Service Request Error", loader.httpStatus)));
				return;
			}
			//var data:Object = JSON.parse(loader.data);
			var data:Object = JSON.decode(loader.data);
			_releaseUrlLoader(loader.url);
			//check error
			if(data.error)
			{
				dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("Unknown",data.error, "Service Request Error", loader.httpStatus)));
				return;
			}
			//no error
			var type:String = loader.returnType;
			var i:int = -1;
			var n:int = -1;
			var titles:Array;
			var results:Object;
			var total:int = 0;
			var link:String;
			switch(data.link_template)
			{
				case MOVIE_SEARCH_TEMPLATE:
				case IN_THEATERS_TEMPLATE:
				case OPENING_MOVIES_TEMPLATE:
				case UPCOMING_MOVIES_TEMPLATE:
				case BOX_OFFICE_TEMPLATE:
				case NEW_RELEASE_DVDS_TEMPLATE:
				case TOP_RENTALS_TEMPLATE:
				case CURRENT_RELEASE_DVDS_TEMPLATE:
				case UPCOMING_DVDS_TEMPLATE:
					i = -1;
					titles = data.movies as Array;
					n = titles.length;
					results = [];
					total = data.total;
					link = data.links.self;
					while(++i<n)
						results.push( ConvertUtil.convertObjectToMovie(data.movies[i]) );
					break;
				case MOVIE_REVIEWS_TEMPLATE:
					i = -1;
					titles = data.reviews as Array;
					n = titles.length;
					results = [];
					total = data.total;
					link = data.links.self;
					while(++i<n)
						results.push( ConvertUtil.convertObjectToReviews(data.reviews[i]) );
					break;
				default:
					switch(loader.type)
					{
						case MOVIE_INFO_TEMPLATE:
							total = 1;
							link = loader.url;
							results = ConvertUtil.convertObjectToMovie(data);
							results.selfLink = link;
							break;
						case MOVIE_CAST_TEMPLATE:
							link = loader.url;
							results = ConvertUtil.convertArrayToCast(data.cast as Array);
							break;
						case MOVIE_SIMILARS_TEMPLATE:
							link = loader.url;
							i = -1;
							titles = data.movies as Array;
							n = titles.length;
							results = [];
							total = n;
							while(++i<n)
								results.push( ConvertUtil.convertObjectToMovie(data.movies[i]) );
							break;
						case MOVIE_CLIPS_TEMPLATE:
							link = loader.url;
							results = ConvertUtil.convertArrayToClips(data.clips as Array);
							break;
						default:
							//unknown response, throw error
							dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault("Unknown","Unknown Error", "Unknown Response", loader.httpStatus)));
							return;
							break;
					}
					break;
			}
			//for peeps using binding,
			//I included this to bind to
			//'lastResult' like an httpservice
			if(_lastResult != results)
			{
				_lastResult = results;
				dispatchEvent(new Event("lastResultChanged"));
			}
			//dispatch result
			//only dispatch if we
			//are listening for it
			if(hasEventListener(type))
				dispatchEvent(new RottenTomatoesResultEvent(type, results, link, total));
			//dispatch the generic "result"
			//event if someone doesn't care
			//for the exact service type
			if(hasEventListener(RottenTomatoesResultEvent.RESULT))
				dispatchEvent(new RottenTomatoesResultEvent(RottenTomatoesResultEvent.RESULT, results, link, total));
		}
		
		private function _onLoader_SecurityHandler(event:SecurityErrorEvent):void
		{
			var loader:RottenTomatoesLoader = event.target as RottenTomatoesLoader;
			_releaseUrlLoader(loader.url);
			
			if(hasEventListener(RottenTomatoesFaultEvent.FAULT))
				dispatchEvent(new RottenTomatoesFaultEvent(RottenTomatoesFaultEvent.FAULT, new ServiceFault(event.errorID.toFixed(0),event.type, event.text, loader.httpStatus)));
		}
		
		//---------------------------------------------------------------------
		//
		//  Private Methods
		//
		//---------------------------------------------------------------------
		private function _getUrlLoader(url:String):RottenTomatoesLoader
		{
			if(!_urlLoaders)
				_urlLoaders = new Vector.<RottenTomatoesLoader>();
			if(!_inUseLoaders)
				_inUseLoaders = {};
			
			var loader:RottenTomatoesLoader;
			if(_urlLoaders.length==0)
			{
				loader = new RottenTomatoesLoader();
				loader.addEventListener(Event.ACTIVATE, _onLoader_ActivateHandler);
				loader.addEventListener(Event.COMPLETE, _onLoader_CompleteHandler);
				loader.addEventListener(Event.DEACTIVATE, _onLoader_DeactivateHandler);
				loader.addEventListener(Event.OPEN, _onLoader_OpenHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onLoader_StatusHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoader_IOErrorHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, _onLoader_ProgressHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoader_SecurityHandler);
				
				loader.dataFormat = URLLoaderDataFormat.TEXT;
			} else {
				loader = _urlLoaders.pop();
			}
			
			loader.url = url;
			_inUseLoaders[url] = loader;
			
			return loader;
		}
		
		private function _releaseUrlLoader(url:String):void
		{
			_urlLoaders.push( _inUseLoaders[url] );
			delete _inUseLoaders[url];
		}
	}
	
}

//---------------------------------------------------------------------
//
//  RottenTomatoesLoader
//
//---------------------------------------------------------------------

import flash.net.URLLoader;

/**
 * 
 * @author jonbcampos
 * 
 */
class RottenTomatoesLoader extends URLLoader
{
	public function RottenTomatoesLoader()
	{
		
	}
	
	public var url:String;
	public var type:String;
	public var httpStatus:int;
	public var returnType:String;
}
