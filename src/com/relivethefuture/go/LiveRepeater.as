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
	import org.goasap.PlayStates;
	import org.goasap.managers.LinearGoRepeater;
	import org.goasap.managers.Repeater;

	public class LiveRepeater extends LinearGoRepeater
	{
		/** @private */
		protected var _nolock : Boolean = true;

		public function LiveRepeater(cycles:uint=Repeater.INFINITE, reverseOnCycle:Boolean=false, easingOnCycle:Function=null, extraEasingParams:Array=null)
		{
			super(cycles, reverseOnCycle, easingOnCycle, extraEasingParams);
		}
		
		/**
		 * True if cycles is not infinite and currentCycle has reached or passed cycles.
		 * 
		 * This is different from the Repeater implementation in that it checks if the currentCycle
		 * is greater than cycles. This is to allow the cycles property to be updated whilst running,
		 * rather than having to call stop.
		 */
		override public function get done():Boolean {
			return (_currentCycle >= _cycles && _cycles!=INFINITE);
		}
		
		/**
		 * Allow client code to prevent repeater from being locked so repeater
		 * parameters can be altered while tween is running, e.g. reverseOnCycle.
		 */
		public function get noLock():Boolean {
			return _nolock;
		}
		
		public function set noLock(noLock:Boolean):void {
			_nolock = noLock;
		}
		
		/**
		 * Same as Repeater except we check for the _nolock setting.
		 */
		override protected function unlocked() : Boolean {
			return (!_item || _nolock || (_item && _item.state == PlayStates.STOPPED));
		}
	}
}