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
package com.relivethefuture.go
{
	import org.goasap.errors.EasingFormatError;
	import org.goasap.items.LinearGo;

	public class LiveGo extends LinearGo
	{
		public function LiveGo()
		{
			super();
			
			_repeater = new LiveRepeater();
			_pulse = 15;	

		}
	
		/**
		 * Same as the easing accessor from LinearGo except that it can be 
		 * changed regardless of state. (LinearGo checks that _state is STOPPED)
		 */
		override public function set easing(type:Function):void
		{
			try 
			{
				if (type(1,1,1,1) is Number) 
				{
					_easing = type;
					return;
				}
			} 
			catch (e:Error) {}
			throw new EasingFormatError();
		}

		/**
		 * Same as the duration accessor from LinearGo except that it can be 
		 * changed regardless of state. (LinearGo checks that _state is STOPPED)
		 */
		override public function set duration(seconds:Number):void 
		{
			if (seconds >= 0) 
			{
				_duration = seconds;
			}
		}
		
		/**
		 * This implementation of correctValue is more strict than the GoItem version.
		 * 
		 * In this version the value is constrained to always lie between 0 and 1.
		 * Values are wrapped around in the parameter space, i.e. -0.2 becomes 0.8
		 * 
		 * This also means that useRounding is not really useful as it would either produce 0 or 1
		 * so its ignored.
		 */
		override public function correctValue(value:Number):Number 
		{
			if (isNaN(value))
			{
				return 0;
			}
			
			// Wrap values.
			if(value < 0 || value > 1)
			{
				value -= Math.floor(value);
			}
			
			return value;
		}
	}
}