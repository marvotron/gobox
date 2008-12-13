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
	import flash.geom.Rectangle;

	/**
	 * Field of IKNodes.
	 * 
	 */
	public class IKField extends NodeField
	{
		public function IKField(bounds:Rectangle = null)
		{
			super(bounds);
		}
		
		/**
		 * Updates the transmission setting for all nodes in the field.
		 * 
		 * <p>Transmission is how much velocity a node passes on down the chain</p>
		 * 
		 * @param	transmission	how much velocity to transmit (typically between 0 and 1)
		 */
		public function setTransmission(t:Number):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:IKNode = nodes[i];
				node.transmission = t;
			}
		}

		/**
		 * Updates the feedback setting for all nodes in the field.
		 * 
		 * <p>Feedback is how much velocity a node passes up the chain</p>
		 * 
		 * @param	feedback	how much velocity to feedback (typically between 0 and 1)
		 */
		public function setFeedback(f:Number):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:IKNode = nodes[i];
				node.feedback = f;
			}
		}
	
	}
}