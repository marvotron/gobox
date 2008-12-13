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
package com.relivethefuture.components
{
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.control.NodeField;
	import com.relivethefuture.control.OrbitingNode;
	import com.relivethefuture.events.ControlBoxEvent;
	import com.relivethefuture.visual.ConnectableNodeSprite;
	import com.relivethefuture.visual.INodeSpriteFactory;
	import com.relivethefuture.visual.NodeDisplay;
	import com.relivethefuture.visual.NodeSprite;
	import com.relivethefuture.visual.OrbitFieldDisplay;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.binding.utils.BindingUtils;
	
	public class OrbitBox extends BasicNodeBox implements INodeSpriteFactory
	{
		public function OrbitBox(boundingRect:Rectangle = null)
		{
			super(boundingRect);
			
			trace("NEW ORBIT BOX : " + model + " : " + display);
		}
		
		override protected function createModel():NodeContainer
		{
			var field:NodeField = new NodeField(boundingRect);
			trace("CREATE MODEL " + field);
			transport.setItem(field);
			return field;
		}
		
		override protected function createDisplay(parent:DisplayObjectContainer):NodeDisplay
		{
			var fieldDisplay:OrbitFieldDisplay = new OrbitFieldDisplay();
			fieldDisplay.setNodeFactory(this);
			parent.addChild(fieldDisplay);
			return fieldDisplay;
		}
		
		override protected function createInspector():DisplayObject
		{
			return new Sprite();
		}
				
		override protected function boxClicked(event:ControlBoxEvent):void
		{
			var node:OrbitingNode = new OrbitingNode();
			node.moveTo(event.point.x,event.point.y);
			node.mass = (Math.random() * 20) + 2;
			
			var distance:Number = model.connectNodeToNearest(node)
			if(distance != -1)
			{
				var theta:Number = node.angleBetween(node.getParent());
				node.setTheta(theta);
				node.radius = distance;
			}
			
			model.addNode(node);
		}
		
		public function createNodeSprite():NodeSprite
		{
			var ons:ConnectableNodeSprite = new ConnectableNodeSprite(true,true);
			ons.setBounds(boundingRect);
			return ons;
		}
	}
}