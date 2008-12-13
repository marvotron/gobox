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
	import mx.effects.easing.*;

	public class EasingPack
	{
		protected var easings:Array;
		protected var currentEasing:Object;
		
		protected var _easingIndex:int = 0;
		protected var _easingMax:int; 

		public function EasingPack()
		{
			easings = [{name:"Linear",fn:Linear.easeNone},
						{name:"Back In",fn:Back.easeIn},
						{name:"Back Out",fn:Back.easeOut},
						{name:"Back InOut",fn:Back.easeInOut},
						{name:"Elastic In",fn:Elastic.easeIn},
						{name:"Elastic Out",fn:Elastic.easeOut},
						{name:"Elastic InOut",fn:Elastic.easeInOut},
						{name:"Circular In",fn:Circular.easeIn},
						{name:"Circular Out",fn:Circular.easeOut},
						{name:"Circular InOut",fn:Circular.easeInOut},
						{name:"Bounce In",fn:Bounce.easeIn},
						{name:"Bounce Out",fn:Bounce.easeOut},
						{name:"Bounce InOut",fn:Bounce.easeInOut},
						{name:"Exponential In",fn:Exponential.easeIn},
						{name:"Exponential Out",fn:Exponential.easeOut},
						{name:"Exponential InOut",fn:Exponential.easeInOut},
						{name:"Quadratic In",fn:Quadratic.easeIn},
						{name:"Quadratic Out",fn:Quadratic.easeOut},
						{name:"Quadratic InOut",fn:Quadratic.easeInOut},
						{name:"Quartic In",fn:Quartic.easeIn},
						{name:"Quartic Out",fn:Quartic.easeOut},
						{name:"Quartic InOut",fn:Quartic.easeInOut},
						{name:"Quintic In",fn:Quintic.easeIn},
						{name:"Quintic Out",fn:Quintic.easeOut},
						{name:"Quintic InOut",fn:Quintic.easeInOut},
						{name:"Sine In",fn:Sine.easeIn},
						{name:"Sine Out",fn:Sine.easeOut},
						{name:"Sine InOut",fn:Sine.easeInOut},
						];
			
			_easingMax = easings.length - 1;			
			_easingIndex = 0;
			update();
		}

		public function hasNext():Boolean
		{
			return _easingIndex < _easingMax;
		}
		
		public function hasPrevious():Boolean
		{
			return _easingIndex > 0;
		}
		
		public function next():void
		{
			_easingIndex++;
			update();
		}
		
		public function previous():void
		{
			_easingIndex--;
			update();
		}
		
		private function update():void
		{
			if(_easingIndex < 0)
			{
				_easingIndex = 0;
			}
			else if(_easingIndex > _easingMax)
			{
				_easingIndex = _easingMax;
			}
			
			currentEasing = easings[_easingIndex];
		}
		
		public function get easing():Object
		{
			return currentEasing;
		}

	}
}