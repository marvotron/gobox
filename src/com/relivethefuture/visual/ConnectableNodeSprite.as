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
package com.relivethefuture.visual
{
	import com.relivethefuture.control.ConnectableNode;
	import com.relivethefuture.control.Node;
	import com.relivethefuture.events.ConnectableNodeEvent;
	import com.relivethefuture.events.PhysicalNodeEvent;
	
	/**
	 * View for an <code>IKNode</code>
	 */
	public class ConnectableNodeSprite extends NodeSprite
	{
		private var connectableNode:ConnectableNode;
		
		private var headColour:uint = 0xFF9944;
		
		public function ConnectableNodeSprite(draggable:Boolean=false, removable:Boolean=false)
		{
			super(draggable, removable);
		}
		
		override public function setNode(node:Node):void
		{
			super.setNode(node);
			if(node is ConnectableNode)
			{
				connectableNode = node as ConnectableNode;
				connectableNode.addEventListener(PhysicalNodeEvent.MASS_CHANGED,draw);
				connectableNode.addEventListener(ConnectableNodeEvent.HEIRARCHY_CHANGED,heirarchyChanged);
				bounds = connectableNode.bounds;
				draw();
			}
		}
		
		private function heirarchyChanged(event:ConnectableNodeEvent):void
		{
			draggable = connectableNode.isHead();
			draw(); 
		}
		
		override public function draw():void
		{
			radius = connectableNode.mass * 0.2;
			
			if(connectableNode.isHead())
			{
				normalColour = headColour;
			}
			else
			{
				normalColour = 0x9a9a9a;
			}
			super.draw();
		}
	}
}