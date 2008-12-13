/**
 * Copyright (c) 2008 Martin Wood-Mitrovski
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.relivethefuture.utils
{
	import flash.geom.Point;
	
	public class Polar
	{
		private var _length:Number;
		private var _theta:Number;
		
		public function Polar(l:Number = 1,t:Number = 0)
		{
			_length = l;
			_theta = t;
		}

		public function get length():Number
		{
			return _length;
		}
		
		public function set length(l:Number):void
		{
			_length = l;
		}
		
		public function get theta():Number
		{
			return _theta;
		}
		
		public function set theta(t:Number):void
		{
			_theta = t;
		}
		
		public function fromCartesian(p:Point):void
		{
			_theta = Math.atan2(p.y,p.x);
			_length = Math.sqrt((p.x*p.x) + (p.y*p.y));
		}
		
		public function toCartesian2(p:Point = null):Point
		{
			var x:Number = _length * Math.cos(_theta);
			var y:Number = _length * Math.sin(_theta);
			if(p != null)
			{
				p.x = x;
				p.y = y;
				return p;
			}
			else
			{
				return new Point(x,y);
			}				
		}
	}
}