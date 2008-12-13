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
	import com.relivethefuture.events.PhysicalNodeEvent;
	import com.relivethefuture.utils.Polar;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PhysicalNode extends Node
	{
		private var da:Number = 0.8;
		private var dv:Number = 0.8;

		protected var frictionCoeff:Number = 1;
		
		protected var _mass:Number;
		protected var _velocity:Point;
		protected var _acceleration:Point;
		protected var _maxAcceleration:Number = 2.0;
		protected var _maxVelocity:Number = 5.0;
		protected var _bounds:Rectangle;
		protected var _randomForceStrength:Number = 4;
		
		public function PhysicalNode(bounds:Rectangle, mass:Number = 5.0)
		{
			super();
			if(bounds == null)
			{
				bounds = new Rectangle(0,0,200,200);
			}
			
			_bounds = bounds;
			
			_velocity = new Point(0,0);
			_acceleration = new Point(0,0);
			
			da = 0.95;

			_mass = mass;
		}

		public function set maxVelocity(mv:Number):void
		{
			_maxVelocity = mv;
		}
		
		public function set maxAcceleration(ma:Number):void
		{
			_maxAcceleration = ma;
		}
		
		public function set friction(f:Number):void
		{
			frictionCoeff = f;
			updateDerivatives();
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function set mass(m:Number):void 
		{
			if (m <= 0)
			{
				m = 5;
			}
			
			_mass = m;
			
			dispatchEvent(new PhysicalNodeEvent(PhysicalNodeEvent.MASS_CHANGED,this));
			updateDerivatives();
		}
		
		public function get acceleration():Point
		{
			return _acceleration;
		}
		
		public function get velocity():Point
		{
			return _velocity;
		}
		
		public function set bounds(b:Rectangle):void
		{
			_bounds = b;
		}
		
		public function get bounds():Rectangle
		{
			return _bounds;
		}
		
		public function update():void
		{
			if (Math.random() < 0.1) 
			{
				// move at random (determinism)
				applyRandomForce();
			}
			
			updateForces();
			checkBounds();
		}
		
		public function applyForce(f:Point):void
		{
			_acceleration = _acceleration.add(f);
		}
		
		public function set randomForceStrength(f:Number):void
		{
			_randomForceStrength = f;
		}
				
		public function applyRandomForce(randomAngle:Number = Math.PI):void
		{
			var polar:Polar = new Polar();
			polar.fromCartesian(_acceleration);
			polar.theta += (Math.random() - Math.random()) * randomAngle;
			polar.length += _randomForceStrength * Math.random();
			
			_acceleration = Point.polar(polar.length,polar.theta);
			//polar.toCartesian(_acceleration);
		}
		
		private function updateForces(forceModifier:Number = 1):void
		{
			// acceleration / velocity reduction
			var na:Number = _acceleration.length * da  * forceModifier;
			
			if(na > _maxAcceleration)
			{
				_acceleration.normalize(_maxAcceleration);	
			}
			else
			{
				_acceleration.normalize(na);
			}
			
			
			var nv:Number = _velocity.length * dv * forceModifier;
			if(nv > _maxVelocity)
			{
				_velocity.normalize(_maxVelocity);
			}
			else
			{
				_velocity.normalize(nv);
			}
			
			_velocity = _velocity.add(_acceleration);
			
			// velocity
			moveTo(_x + _velocity.x, _y + _velocity.y); 
		}

		
		private function checkBounds():void
		{
			if( (x < 10 && _acceleration.x < 0) || (x > _bounds.width - 10 && _acceleration.x > 0) )
			{
				_acceleration.x *= -1;
			}
		  	
			if( (y < 10 && _acceleration.y < 0) || (y > _bounds.height -10 && _acceleration.y > 0) )
			{
				_acceleration.y *= -1;
			}
		}

		protected function updateDerivatives():void
		{
			var ndv:Number = 1 / (frictionCoeff * _mass);
			var nda:Number = 16 / (frictionCoeff * _mass);
			dv = Math.min(ndv,0.95);
			da = Math.min(nda,0.95);
		}

	}
}