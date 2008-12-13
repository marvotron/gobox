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
	import com.relivethefuture.events.ChangeEvent;
	import com.relivethefuture.events.DeleteNodeEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * View for a <code>Node</code> model.
	 * Can be made draggable and/or removable
	 * Removal requires using the CTRL key which will cause a 
	 * <code>DeleteNodeEvent</code> to be dispatched
	 */
	public class NodeSprite extends Sprite
	{
		protected var overColour:uint = 0x7aFF7a;
		protected var normalColour:uint = 0x7a7a7a;
		protected var deleteColour:uint = 0xFF7a7a;
		
		protected var radius:Number = 4;
		
		private var node:Node;
		
		protected var over:Boolean = false;
		
		private var ctrl:Boolean = false;
		
		protected var bounds:Rectangle;
		
		protected var draggable:Boolean;
		protected var removable:Boolean;
		protected var fillAlpha:Number = 0.7;
		
		protected var _selected:Boolean = false;
		protected var selectionFilter:BitmapFilter;
		
		public function NodeSprite(draggable:Boolean = false,removable:Boolean = false)
		{
			this.draggable = draggable;
			this.removable = removable;
			
			if(removable)
			{
				addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}

			if(removable || draggable)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			
			addEventListener(Event.ADDED_TO_STAGE,init);
			
			selectionFilter = new GlowFilter(0x00FF00,0.5,2,2,3);
		}

		/**
		 * Constrain the node within the supplied bounds when dragging
		 * 
		 * @param bounds	Rectangle for constraining drag area
		 */
		public function setBounds(bounds:Rectangle):void
		{
			this.bounds = bounds;
		}
		
		/**
		 * Must be called after this has been added to the display list so that
		 * the stage property is not null.
		 */
		private function init(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			draw();
		}
		
		/**
		 * Be nice and call this when you no longer need it, just to make sure
		 * everything is cleaned up properly.
		 * 
		 * <p>De-registers listeners.</p>
		 */
		public function dispose():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			node.removeEventListener(ChangeEvent.CHANGE,nodeChanged);
			stopDrag();
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.CONTROL)
			{
				ctrl = true;
				draw();
			}	
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.CONTROL)
			{
				ctrl = false;
				draw();
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			over = true;
			draw();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			over = false;
			draw();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(ctrl)
			{
				dispatchEvent(new DeleteNodeEvent(this));
			}
			else 
			{
				if(draggable)
				{
					stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
	
					node.removeEventListener(ChangeEvent.CHANGE,nodeChanged);
					startDrag(false,bounds);
				}
			}
		}
		
		private function onDrop(event:Event):void
		{
			stopDrag();
			if(stage != null)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			}
			else
			{
				trace("onDrop called but stage is null");
			}
			
			if(node != null)
			{
				node.addEventListener(ChangeEvent.CHANGE,nodeChanged);
			}
			else
			{
				trace("onDrop called but node is null");
			}
		}

		private function onMove(event:MouseEvent):void
		{
			node.moveTo(x,y);
		}
		
		/**
		 * Set the <code>Node</code> model.
		 * 
		 * @param node	What else, but the Node.
		 */
		public function setNode(newNode:Node):void
		{
			if(node != null)
			{
				node.removeEventListener(ChangeEvent.CHANGE,nodeChanged);
			}
			
			node = newNode;
			node.addEventListener(ChangeEvent.CHANGE,nodeChanged);
			x = node.x;
			y = node.y;
		}
		
		public function getNode():Node
		{
			return node;
		}
		
		private function nodeChanged(event:Event):void
		{
			x = node.x;
			y = node.y;
		}
		
		public function set selected(s:Boolean):void
		{
			_selected = s;

			draw();			
		}
		/**
		 * Define the 'resting state' colour of this NodeSprite. i.e. when not rolled over.
		 * 
		 * @param	colour	the colour
		 */
		public function set colour(col:uint):void
		{
			normalColour = col;
			draw();
		}
		
		/**
		 * Redraw this NodeSprite, used internally
		 */
		public function draw():void
		{
			graphics.clear();
			var c:uint = normalColour;
			if(over)
			{
				c = ctrl ? deleteColour : overColour;
			}
			
			graphics.beginFill(c,fillAlpha);
			graphics.lineStyle(0,c);
			graphics.drawCircle(0,0,radius);
			graphics.endFill();
			
			if(_selected)
			{
				graphics.lineStyle(0,0xFF0000,0.6);
				graphics.drawRect(-radius - 1,-radius - 1,(radius + 1) * 2,(radius + 1) * 2);
			}
		}
	}
}