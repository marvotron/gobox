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
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.control.NodeField;
	import com.relivethefuture.events.ChangeEvent;
	import com.relivethefuture.events.DeleteNodeEvent;
	import com.relivethefuture.events.NodeEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.goasap.events.GoEvent;

	public class BasicFieldDisplay extends NodeDisplay
	{
		private var connectionsDisplay:Sprite;
		
		public function BasicFieldDisplay()
		{
			super();
			
			connectionsDisplay = new Sprite();
			addChild(connectionsDisplay);
		}

		override protected function bindModel(model:NodeContainer):void
		{
			super.bindModel(model);
			model.addEventListener(GoEvent.UPDATE,draw);
		}
		
		override protected function unbindModel(model:NodeContainer):void
		{
			super.unbindModel(model);
			model.removeEventListener(GoEvent.UPDATE,draw);
		}
		
		override protected function draw(obj:* = null):void
		{
			connectionsDisplay.graphics.clear();
			var nodes:Array = model.getNodes();
			for(var j:int = 0;j<nodes.length;j++)
			{
				drawConnectionLines(nodes[j] as ConnectableNode,connectionsDisplay.graphics);
			}
		}
		
		protected function drawConnectionLines(src:ConnectableNode,gr:Graphics):void
		{
			var connections:Array = src.getConnections();
			
			// loop through connections and draw lines
			for (var n:int = 0;n<connections.length;n++) 
			{
				var dest:ConnectableNode = connections[n];
				
				var dx:Number = dest.x - src.x;
				var dy:Number = dest.y - src.y;
				
				gr.moveTo(src.x,src.y);		
				// draw 1/4 black to indicate pull direction
				gr.lineStyle(0,0x000000,0.3);
				gr.lineTo(src.x + (dx * 0.25),src.y + (dy * 0.25));
				
				// draw 3/4 red
				gr.lineStyle(0,0xFF0000,0.3);
				gr.lineTo(dest.x,dest.y);
			}
		}		
	}
}