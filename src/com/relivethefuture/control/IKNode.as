/**
 * Copyright (c) 2008 Martin Wood-Mitrovski
 * 
 * Adapted from code by J Tarbell : www.levitated.net
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
	import com.relivethefuture.utils.Polar;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * This is an adaptation of the Levitated.net iterative IK experiment
	 * 
	 * The main feature is constraint of distance between 2 nodes in a node chain.
	 * 
	 */
	public class IKNode extends ConnectableNode
	{
		// How much random force to apply if we are not the 'head' of a chain
		private var tailRandomStrength:Number = 0.6;
		
		private var transmissionCoeff:Number = 0.01;
		private var naturalLength:Number;
		private var _feedback:Number = 0.01;
		
		public function IKNode(bounds:Rectangle, mass:Number = 5.0)
		{
			super(bounds,mass);
			
			// length of connection (allow variable lengths between nodes)
			naturalLength = (_mass * 2) + (Math.random() * 45);
			
			// list of all connections
			connections = new Array();
			
			updateDerivatives();
		}
		
		public function set transmission(t:Number):void
		{
			transmissionCoeff = t;
		}
		
		public function set feedback(f:Number):void
		{
			_feedback = f;
		}
	
		public function setLength(l:Number):void
		{
			trace("Set Length : " + l);
			naturalLength = l;
		}

		override public function update():void
		{
			if (Math.random() < 0.1)
			{
				// move at random (determinism)
				applyRandomForce();
			}
			
			super.update();
			
			if(isHead())
			{
				constrainConnections();
			}
		}

		public function constrainConnections():void
		{
			// loop through connections and pull each into position
			var angleDiv:Number = Math.PI / (connections.length + 1);
			for (var n:int = 0;n<connections.length;n++) 
			{
				// distance
				var nodeA:IKNode = connections[n];
				var dx:Number = nodeA.x - x;
				var dy:Number = nodeA.y - y;
				var p:Polar = new Polar();
				p.fromCartesian(new Point(dx,dy));
				p.length = naturalLength;
				
				var ba:Number = angleDiv * n;
				var ba2:Number = ba - angleDiv;
				if(p.theta < ba)
				{
					p.theta += 0.01;
				}
				else if(p.theta > ba2)
				{
					p.theta -= 0.01;
				}
				
				var p2:Point = Point.polar(p.length,p.theta);//p.toCartesian();
				// inverse kinetic conservation
				nodeA.x = x + p2.x;
				nodeA.y = y + p2.y;
				
				// Pass some acceleration on to the connected node
				var a2:Point = _acceleration.clone();
				a2.normalize(_acceleration.length * mass * transmissionCoeff);
				nodeA.applyForce(a2);

				// Apply some acceleration feedback from the connected node
				var a:Point = nodeA.acceleration.clone();
				a.normalize(_acceleration.length * mass * _feedback);
				applyForce(a);
				
				// recurse
				nodeA.constrainConnections();
			}
		}
		
	}
}