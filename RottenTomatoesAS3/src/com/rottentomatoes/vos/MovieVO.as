package com.rottentomatoes.vos
{
	public class MovieVO
	{
		public function MovieVO()
		{
		}
		
		public var abridgedCast:Array;
		public var id:String;
		public var abridgedDirectors:Array;
		public var genres:Array;
		
		public var alternateLink:String;
		public var castLink:String;
		public var reviewsLink:String;
		public var selfLink:String;
		public var clipsLink:String;
		public var similarLink:String;
		
		public var detailedPoster:String;
		public var originalPoster:String;
		public var profilePoster:String;
		public var thumbnailPoster:String;
		
		public var audienceRating:String;
		public var audienceScore:int;
		public var criticsRating:String;
		public var criticsScore:int;
		
		public var dvdReleaseDate:Date;
		public var theaterReleaseDate:Date;
		
		public var runtime:int;
		
		public var synopsis:String;
		public var mpaaRating:String;
		public var title:String;
		public var year:int;
		public var studio:String;
		public var criticsConsensus:String;
		
		//alternate ids
		public var imdbId:String;
	}
}