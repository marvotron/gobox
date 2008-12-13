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
	import com.relivethefuture.control.Path;
	import com.relivethefuture.events.PathStorageEvent;
	import com.relivethefuture.events.StartDragEvent;
	import com.relivethefuture.system.DragAndDropManager;
	import com.relivethefuture.system.IDragInitiator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class PathIcon extends Sprite implements IDragInitiator
	{
		private var _path:Path;

		private var over:Boolean = false;
		private var ctrl:Boolean = false;
		protected var overColour:uint = 0x7aFF7a;
		protected var normalColour:uint = 0x7a7a7a;
		protected var deleteColour:uint = 0xFF7a7a;

		protected var draggable:Boolean;
		protected var removable:Boolean;
		
		private var id:int;
		
		public function PathIcon(draggable:Boolean = false,removable:Boolean = false)
		{
			super();
			this.draggable = draggable;
			this.removable = removable;
			
			scaleX = 0.2;
			scaleY = 0.2;
			
			if(removable)
			{
				addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}

			if(removable || draggable)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		public function init():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			draw();
		}
		
		public function setId(newID:int):void
		{
			id = newID;
		}
		
		public function get displayContainer():DisplayObjectContainer
		{
			return stage;
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
		
		public function onMouseDown(event:MouseEvent):void
		{
			if(ctrl)
			{
				dispatchEvent(new PathStorageEvent(PathStorageEvent.REMOVE,_path));
			}
			else if(draggable)
			{
				var dragProxy:PathIcon = new PathIcon();
				dragProxy.path = _path;
				DragAndDropManager.getInstance().startDrag(new StartDragEvent(this,_path.clone(),dragProxy));
			}
		}
		
		public function set path(path:Path):void
		{
			_path = path;
			draw();	
		}
		
		public function get path():Path
		{
			return _path;
		}
		
		private function draw():void
		{
			graphics.clear();
			
			var nodes:Array = _path.getNodes();
			
			if(nodes == null || nodes.length == 0)
			{
				trace("No Nodes : " + nodes.length);
				return;
			}
			
			var c:uint = normalColour;
			if(over)
			{
				c = ctrl ? deleteColour : overColour;
			}

			graphics.lineStyle(0.1,0x989898);
			graphics.beginFill(c,0.5);
			graphics.drawRect(-2,-2,102,102);
			graphics.endFill();
			graphics.lineStyle(0.5,0x000000);
			graphics.moveTo(nodes[0].x,nodes[0].y);
			for(var i:int = 1;i<nodes.length;i++)
			{
				graphics.lineTo(nodes[i].x,nodes[i].y);
			}
			
			if(_path.isClosed())
			{
				graphics.lineTo(nodes[0].x,nodes[0].y);
			}
		}
	}
}