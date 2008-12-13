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
	import flash.geom.Rectangle;
	
	public class OrbitingNode extends ConnectableNode
	{
		// Angular velocity
		private var av:Number;
		
		// Current rotation angle		
		private var theta:Number;
		
		// Orbital radius
		private var _radius:Number;
		
		public function OrbitingNode(bounds:Rectangle = null,mass:Number = 5)
		{
			super(bounds,mass);
			av = (Math.random() - 0.5) * 0.3;
			theta = 0;
		}

		public function setTheta(t:Number):void
		{
			theta = t;
		}
		
		public function setAngularVelocity(v:Number):void
		{
			av = v;
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(r:Number):void
		{
			_radius = r;
		}
		
		override public function update():void
		{
			// orbit the parent node
			if(parent != null)
			{
				theta += av;// * _root.modv;
				var newX:Number = parent.x + (_radius * Math.cos(theta));
				var newY:Number = parent.y + (_radius * Math.sin(theta));
				moveTo(newX,newY);
			}
		}
	}
}