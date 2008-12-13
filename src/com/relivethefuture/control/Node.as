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
package com.relivethefuture.control
{
	import com.relivethefuture.events.ChangeEvent;
	
	import flash.events.EventDispatcher;
	
	public class Node extends EventDispatcher
	{
		protected var _x:Number = 0.0;
		protected var _y:Number = 0.0;

		private var changeEvent:ChangeEvent;
		
		public function Node(x:Number = 0.0,y:Number = 0.0)
		{
			_x = x;
			_y = y;
		}
		
		public function distanceTo(n:Node):Number
		{
			var dx:Number = _x - n.x;
			var dy:Number = _y - n.y;
			return Math.sqrt((dx*dx) + (dy*dy));
		}
		
		public function angleBetween(n:Node):Number
		{
			var dx:Number = _x - n.x;
			var dy:Number = _y - n.y;
			return Math.atan2(dy,dx);
		}
		
		public function moveTo(x:Number,y:Number):void
		{
			_x = x;
			_y = y;
			dispatchEvent(new ChangeEvent());
		}
		
		public function set x(x:Number):void
		{
			_x = x;
			dispatchEvent(new ChangeEvent());
		}
		
		public function set y(y:Number):void
		{
			_y = y;
			dispatchEvent(new ChangeEvent());
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function clone():Node
		{
			return new Node(_x,_y);
		}
	}
}