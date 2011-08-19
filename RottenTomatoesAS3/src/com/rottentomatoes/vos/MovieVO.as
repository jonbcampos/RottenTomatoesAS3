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
package com.rottentomatoes.vos
{
	[RemoteClass(alias="com.rottentomatoes.vos.MovieVO")]
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
		
		//posters
		/**
		 * 180x267. 
		 */		
		public var detailedPoster:String;
		/**
		 * 1200x1778. 
		 */		
		public var originalPoster:String;
		/**
		 * 120x178. 
		 */		
		public var profilePoster:String;
		/**
		 * 61x91. 
		 */		
		public var thumbnailPoster:String;
		
		public var dvdReleaseDate:Date;
		public var theaterReleaseDate:Date;
		
		public var runtime:int;
		
		public var synopsis:String;
		public var mpaaRating:String;
		public var title:String;
		public var year:int;
		public var studio:String;
		
		//audience
		public var audienceRating:String;
		public var audienceScore:int;
		public var audienceIcon:String;
		public var audienceAlternativeIcon:String;
		
		//critics
		public var criticsRating:String;
		public var criticsScore:int;
		public var criticsConsensus:String;
		public var criticsIcon:String;
		public var criticsAlternativeIcon:String;
		
		//alternate ids
		public var imdbId:String;
		
		//certified fresh
		public var certifiedFresh:Boolean;
		/**
		 * 45x45.
		 */		
		public var certifiedFreshTinyIcon:String = "http://images.rottentomatoescdn.com/images/trademark/certified/CertifiedFresh_logo_45.png";
		/**
		 * 60x60.
		 */		
		public var certifiedFreshSmallIcon:String = "http://images.rottentomatoescdn.com/images/trademark/certified/CertifiedFresh_logo_60.png";
		/**
		 * 120x120.
		 */		
		public var certifiedFreshMediumIcon:String = "http://images.rottentomatoescdn.com/images/trademark/certified/CertifiedFresh_logo_120.png";
		/**
		 * 240x240.
		 */		
		public var certifiedFreshLargeIcon:String = "http://images.rottentomatoescdn.com/images/trademark/certified/CertifiedFresh_logo_240.png";
		/**
		 * 300x300.
		 */		
		public var certifiedFreshHugeIcon:String = "http://images.rottentomatoescdn.com/images/trademark/certified/CertifiedFresh_logo_300.png";
	}
}