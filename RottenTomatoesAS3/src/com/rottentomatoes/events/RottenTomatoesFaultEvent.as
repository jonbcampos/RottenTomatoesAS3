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
	import com.rottentomatoes.vos.ServiceFault;
	
	import flash.events.Event;
	
	/**
	 * Fault Event from any of the Rotten Tomatoes Services.
	 * @author jonbcampos
	 * 
	 */
	public class RottenTomatoesFaultEvent extends Event
	{
		/**
		 * Fault Event. 
		 */		
		public static const FAULT:String = "fault";
		
		private var _fault:ServiceFault;
		/**
		 * Fault Object. 
		 * @return 
		 * 
		 */		
		public function get fault():ServiceFault{ return _fault; }
		
		private var _serviceType:String;
		/**
		 * Service Type that caused the fault. 
		 * @return 
		 * 
		 */		
		public function get serviceType():String { return _serviceType; }
		
		/**
		 * Fault Result Event from Netflix API. 
		 * @param type
		 * @param fault
		 * 
		 */		
		public function RottenTomatoesFaultEvent(type:String, fault:ServiceFault = null, serviceType:String = null)
		{
			super(type);
			_fault = fault;
			_serviceType = serviceType;
		}
		
		override public function clone():Event
		{
			return new RottenTomatoesFaultEvent(type, fault, serviceType);
		}
		
	}
}