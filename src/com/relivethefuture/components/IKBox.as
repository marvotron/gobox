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
	import com.bit101.components.HUISlider;
	import com.bit101.components.PushButton;
	import com.relivethefuture.control.IKField;
	import com.relivethefuture.control.IKNode;
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.events.ControlBoxEvent;
	import com.relivethefuture.visual.BasicFieldDisplay;
	import com.relivethefuture.visual.ConnectableNodeSprite;
	import com.relivethefuture.visual.INodeSpriteFactory;
	import com.relivethefuture.visual.NodeDisplay;
	import com.relivethefuture.visual.NodeSprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class IKBox extends BasicNodeBox implements INodeSpriteFactory
	{
		private var field:IKField;
		
		private var frictionSlider:HUISlider;
		
		private var transSlider:HUISlider;
		private var transButton:PushButton;
		
		private var feedbackSlider:HUISlider;
		private var feedbackButton:PushButton;
		
		private var velocitySlider:HUISlider;
		private var accSlider:HUISlider;
		private var randomForceSlider:HUISlider;
		
		public function IKBox(boundingRect:Rectangle = null)
		{
			super(boundingRect);
		}

		override protected function createModel():NodeContainer
		{
			field = new IKField(boundingRect);
			transport.setItem(field);
			return field;
		}
				
		override protected function createDisplay(parent:DisplayObjectContainer):NodeDisplay
		{
			var fieldDisplay:BasicFieldDisplay = new BasicFieldDisplay();
			fieldDisplay.setNodeFactory(this);
			parent.addChild(fieldDisplay);
			return fieldDisplay;
		}
		
		override protected function createInspector():DisplayObject
		{
			var inspector:Sprite = new Sprite();
			
			frictionSlider = new HUISlider(inspector,0,10,"Friction",frictionChanged);
			frictionSlider.setSliderParams(0.3,2,1);

			transSlider = new HUISlider(inspector,0,35,"Transmission",transmissionChanged);
			transSlider.setSliderParams(0,200,1);
			transButton = new PushButton(inspector,180,35,">>>",transmissionChanged);
			transButton.setSize(20,20);
			transButton.toggle = true;

			feedbackSlider = new HUISlider(inspector,0,60,"Feedback",feedbackChanged);
			feedbackSlider.setSliderParams(0,50,1);
			feedbackButton = new PushButton(inspector,180,60,">>>",feedbackChanged);
			feedbackButton.setSize(20,20);
			feedbackButton.toggle = true;
			
			velocitySlider = new HUISlider(inspector,0,85,"Max Velocity",mvChanged);
			velocitySlider.setSliderParams(1,20,10);
			accSlider = new HUISlider(inspector,0,110,"Max Acceleration",maChanged);
			accSlider.setSliderParams(1,20,5);
			randomForceSlider = new HUISlider(inspector,0,135,"Impulse Strength",forceChanged);
			randomForceSlider.setSliderParams(1,20,5);
			
			return inspector;
		}
		
		private function transmissionChanged(event:Event):void
		{
			field.setTransmission(transSlider.value * (transButton.selected ? -0.01 : 0.01));
		}

		private function feedbackChanged(event:Event):void
		{
			field.setFeedback(feedbackSlider.value * (feedbackButton.selected ? -0.001 : 0.001));
		}
		
		private function frictionChanged(event:Event):void
		{
			field.setFriction(frictionSlider.value * frictionSlider.value);
		}

		private function mvChanged(event:Event):void
		{
			field.setMaxVelocity(velocitySlider.value);
		}

		private function maChanged(event:Event):void
		{
			field.setMaxAcceleration(accSlider.value);
		}

		override protected function boxClicked(event:ControlBoxEvent):void
		{
			createNode(event.point.x,event.point.y, (Math.random() * 20) + 2);
		}
		
		private function forceChanged(event:Event):void
		{
			var nodes:Array = model.getNodes();
			
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:IKNode = nodes[i];
				node.randomForceStrength = randomForceSlider.value;
			}
		}
		
		public function addRandomNode():void
		{
			createNode(Math.random() * boundingRect.width,Math.random() * boundingRect.height, (Math.random() * 20) + 2); 
		}
		
		public function createNode(x:Number,y:Number,mass:Number):void
		{
			var ikNode:IKNode = new IKNode(boundingRect,mass);
			ikNode.moveTo(x,y);
			var distance:Number = model.connectNodeToNearest(ikNode,20);
			trace("Nearest : " + distance);
			if(distance != -1)
			{
				ikNode.setLength(Math.sqrt(distance));
			}
			model.addNode(ikNode);
		}
		
		public function createNodeSprite():NodeSprite
		{
			return new ConnectableNodeSprite(true,true);
		}		
	}
}