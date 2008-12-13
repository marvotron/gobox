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
	import com.relivethefuture.control.Node;
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.control.Path;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class PathDisplay extends NodeDisplay
	{
		private var lineColour:uint = 0x000000;
		private var nodeColour:uint = 0x7a7a7a;
		
		private var positionNodeSprite:NodeSprite;
		
		private var pathContainer:Sprite;
		
		public function PathDisplay()
		{
			positionNodeSprite = new NodeSprite();
			positionNodeSprite.colour = 0xFF7F22;
			positionNodeSprite.alpha = 0.85;
			
			pathContainer = new Sprite();
			addChild(pathContainer);
			addChild(positionNodeSprite);
		}

		public function setPositionNode(pn:Node):void
		{
			positionNodeSprite.setNode(pn);
		}
		
		public function showPosition(p:Point):void
		{
			positionNodeSprite.getNode().moveTo(p.x,p.y);
		}

		override protected function bindModel(model:NodeContainer):void
		{
			super.bindModel(model);
			
			for(var i:uint = 0;i<model.getNodes().length;i++)
			{
				addNode();
			}
			
			draw();
		}
		
		override protected function draw(obj:* = null):void
		{
			var pathNodes:Array = model.getNodes();
			
			graphics.clear();
			graphics.lineStyle(1,lineColour);
						
			for(var i:int = 0;i<pathNodes.length;i++)
			{
				var pathNode:Node = pathNodes[i];
				
				if(i > 0)
				{
					drawLine(pathNodes[i - 1],pathNode);
				}
				nodes[i].setNode(pathNodes[i]);
			}
			
			if(nodes.length > 0)
			{
				nodes[0].colour = 0xaaaaaa;
			}
			
			if(model is Path)
			{
				var p:Path = model as Path;
			
				if(p.isClosed() && pathNodes.length > 2)
				{
					drawLine(pathNodes[pathNodes.length - 1],pathNodes[0]);
				}
			}
		}

		private function drawLine(p1:Node,p2:Node):void
		{
			graphics.moveTo(p1.x,p1.y);
			graphics.lineTo(p2.x,p2.y);
		}
	}
}