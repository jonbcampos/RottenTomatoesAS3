package com.rottentomatoes.utils
{
	import com.rottentomatoes.vos.CastVO;
	import com.rottentomatoes.vos.DirectorVO;
	import com.rottentomatoes.vos.MovieVO;
	import com.rottentomatoes.vos.ReviewVO;

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
			movie.alternateLink = value.links.alternate;
			movie.castLink = value.links.cast;
			movie.reviewsLink = value.links.reviews;
			movie.selfLink = value.links.self;
			movie.detailedPoster = value.posters.detailed;
			movie.originalPoster = value.posters.original;
			movie.profilePoster = value.posters.profile;
			movie.thumbnailPoster = value.posters.thumbnail;
			movie.audienceScore = value.ratings.audience_score;
			movie.criticsScore = value.ratings.critics_score;
			if(value.release_dates.dvd)
				movie.dvdReleaseDate = new Date((value.release_dates.dvd as String).replace(/\-/gi,"/"));
			if(value.release_dates.theater)
				movie.theaterReleaseDate = new Date((value.release_dates.theater as String).replace(/\-/gi,"/"));
			movie.runtime = value.runtime;
			movie.synopsis = value.synopsis;
			movie.title = value.title;
			movie.year = value.year;
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
	}
}