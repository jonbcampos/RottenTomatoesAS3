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
	[RemoteClass(alias="com.rottentomatoes.vos.ReviewVO")]
	public class ReviewVO
	{
		public function ReviewVO()
		{
		}
		
		public var critic:String;
		public var date:Date;
		public var reviewLink:String;
		public var publication:String;
		public var quote:String;
		
		private var _originalScore:String;
		public function get originalScore():String
		{
			return _originalScore;
		}
		
		public function set originalScore(value:String):void
		{
			_originalScore = value;
			
			if(originalScore)
			{
				if(originalScore.indexOf("/")>-1)
				{
					//math
					var numbers:Array = originalScore.split("/");
					if(numbers.length==2)
					{
						if(isNaN(numbers[0]) == false && isNaN(numbers[1]) == false)
						{
							var perc:Number = Number(numbers[0])/Number(numbers[1]);
							if(perc>0.59)
							{
								icon = "http://images.rottentomatoescdn.com/images/trademark/fresh_45.png";
								alternativeIcon = "http://images.rottentomatoescdn.com/images/trademark/popcorn.png";
							} else {
								icon = alternativeIcon = "http://images.rottentomatoescdn.com/images/trademark/rotten_45.png";
							}
						}
					}
				} else {
					var value:String = originalScore.replace("+","");
					value = value.replace("-","");
					value = value.toLowerCase();
					switch(value)
					{
						case "a":
						case "b":
							icon = "http://images.rottentomatoescdn.com/images/trademark/fresh_45.png";
							alternativeIcon = "http://images.rottentomatoescdn.com/images/trademark/popcorn.png";
							break;
						case "c":
						case "d":
						case "f":
							icon = alternativeIcon = "http://images.rottentomatoescdn.com/images/trademark/rotten_45.png";
							break;
					}
				}
			}
		}
		
		public var icon:String;
		public var alternativeIcon:String;
	}
}