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
package com.rottentomatoes.utils
{
	import com.rottentomatoes.vos.CastVO;
	import com.rottentomatoes.vos.ClipVO;
	import com.rottentomatoes.vos.DirectorVO;
	import com.rottentomatoes.vos.MovieVO;
	import com.rottentomatoes.vos.ReviewVO;
	
	/**
	 * Converts untyped objects into typed result objects. 
	 * @author jonbcampos
	 * 
	 */	
	public class ConvertUtil
	{
		public static function convertObjectToReviews(value:Object):ReviewVO
		{
			var review:ReviewVO = new ReviewVO();
			review.critic = value.critic;
			if(value.date)
				review.date = new Date((value.date as String).replace(/\-/gi,"/"));
			if(value.links)
				review.reviewLink = value.links.review;
			review.publication = value.publication;
			review.quote = value.quote;
			review.originalScore = value.original_score;
			return review;
		}
		
		public static function convertObjectToMovie(value:Object):MovieVO
		{
			var movie:MovieVO = new MovieVO();
			movie.abridgedCast = convertArrayToCast(value.abridged_cast as Array);
			movie.abridgedDirectors = convertArrayToAbridgedDirectors(value.abridged_directors as Array);
			movie.genres = value.genres as Array;
			movie.id = value.id;
			if(value.links)
			{
				movie.alternateLink = value.links.alternate;
				movie.castLink = value.links.cast;
				movie.reviewsLink = value.links.reviews;
				movie.selfLink = value.links.self;
				movie.clipsLink = value.links.clips;
				movie.similarLink = value.links.similar;
			}
			if(value.posters)
			{
				movie.detailedPoster = value.posters.detailed;
				movie.originalPoster = value.posters.original;
				movie.profilePoster = value.posters.profile;
				movie.thumbnailPoster = value.posters.thumbnail;
			}
			if(value.ratings)
			{
				movie.audienceScore = value.ratings.audience_score;
				movie.criticsScore = value.ratings.critics_score;
				movie.audienceRating = value.ratings.audience_rating;
				movie.criticsRating = value.ratings.critics_rating;
			}
			if(value.release_dates.dvd)
				movie.dvdReleaseDate = new Date((value.release_dates.dvd as String).replace(/\-/gi,"/"));
			if(value.release_dates.theater)
				movie.theaterReleaseDate = new Date((value.release_dates.theater as String).replace(/\-/gi,"/"));
			movie.runtime = value.runtime;
			movie.synopsis = value.synopsis;
			movie.mpaaRating = value.mpaa_rating;
			movie.title = value.title;
			movie.year = value.year;
			movie.studio = value.studio;
			movie.criticsConsensus = value.critics_consensus;
			if(value.alternate_ids)
			{
				movie.imdbId = value.alternate_ids.imdb;
			}
			return movie;
		}
		
		public static function convertArrayToCast(value:Array):Array
		{
			if(!value)
				return null;
			var i:int = -1;
			var n:int = value.length;
			var results:Array = [];
			while(++i<n)
			{
				var cast:CastVO = new CastVO();
				cast.name = value[i].name;
				cast.id = value[i].id;
				var characters:Array = value[i].characters as Array;
				if(characters)
				{
					var j:int = -1;
					var m:int = characters.length;
					cast.characters = [];
					while(++j<m)
						cast.characters.push( value[i].characters[j] );
				}
				
				results.push( cast );
			}
			return results;
		}
		
		private static function convertArrayToAbridgedDirectors(value:Array):Array
		{
			if(!value)
				return null;
			var i:int = -1;
			var n:int = value.length;
			var results:Array = [];
			while(++i<n)
			{
				var director:DirectorVO = new DirectorVO();
				director.name = value[i].name;
				results.push( director );
			}
			return results;
		}
		
		public static function convertArrayToClips(value:Array):Array
		{
			if(!value)
				return null;
			var i:int = -1;
			var n:int = value.length;
			var results:Array = [];
			while(++i<n)
				results.push( convertObjectToClip(value[i]) );
			return results;
		}
		
		private static function convertObjectToClip(value:Object):ClipVO
		{
			var clip:ClipVO = new ClipVO();
			clip.duration = int(value.duration);
			if(value.links)
			{
				clip.alternativeLink = value.links.alternate;
			}
			clip.thumbnail = value.thumbnail;
			clip.title = value.title;
			return clip;
		}
	}
}