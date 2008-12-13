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
	import com.relivethefuture.events.ControlBoxEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ControlBox extends Sprite
	{
		protected var boundingRect:Rectangle;
		private var background:Sprite;

		public function ControlBox(br:Rectangle = null)
		{
			super();
			if(br == null)
			{
				boundingRect = new Rectangle(0,0,100,100);
			}
			else
			{
				boundingRect = br;
			}
			drawBackground();
		}
		
		public function getBoundingRect():Rectangle
		{
			return boundingRect;
		}
		
		private function drawBackground():void
		{
			background = new Sprite();
			background.graphics.lineStyle(0.5,0x000000);
			background.graphics.beginFill(0xd0d0d0,0.5);
			background.graphics.drawRect(boundingRect.x,boundingRect.y,boundingRect.width,boundingRect.height);
			background.addEventListener(MouseEvent.CLICK,backgroundClicked);
			background.addEventListener(MouseEvent.MOUSE_DOWN,backgroundPressed);
			addChild(background);
		}
	
		protected function backgroundPressed(event:MouseEvent):void
		{
			dispatchEvent(new ControlBoxEvent(ControlBoxEvent.PRESS,new Point(event.localX,event.localY), this));
		}
		
		protected function backgroundClicked(event:MouseEvent):void
		{
			dispatchEvent(new ControlBoxEvent(ControlBoxEvent.CLICK,new Point(background.mouseX,background.mouseY), this));
		}
	}
}