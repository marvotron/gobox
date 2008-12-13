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
package com.relivethefuture.system
{
	import com.relivethefuture.events.StartDragEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class DragAndDropManager
	{
		public function DragAndDropManager()
		{
			targets = new Dictionary();
		}
	
		private static var _instance:DragAndDropManager;
		
		private var initiator:IDragInitiator;
		private var data:*;
		private var proxy:Sprite;
		
		private var canDrop:Boolean;
		private var targets:Dictionary;
		private var currentTarget:IDropTarget;
		
		public static function getInstance():DragAndDropManager
		{
			if(_instance == null)
			{
				_instance = new DragAndDropManager();
			}
			return _instance;
		}
		
		public function registerDropTarget(target:IDropTarget):void
		{
			trace("Register drop target : " + target);
			if(!targets[target.displayObject])
			{
				targets[target.displayObject] = target;
			}
		}
		
		public function startDrag(event:StartDragEvent):void
		{
			initiator = event.source;
			data = event.data;
			proxy = event.proxy;
			
			initiator.displayContainer.addEventListener(MouseEvent.MOUSE_MOVE,dragging);
			initiator.displayContainer.addEventListener(MouseEvent.MOUSE_UP,dragEnd);
			initiator.displayContainer.addChild(proxy);
			proxy.x = initiator.displayContainer.mouseX - proxy.width;
			proxy.y = initiator.displayContainer.mouseY - proxy.height;
			proxy.visible = false;
			proxy.startDrag(false);
		}
		
		private function dragging(event:MouseEvent):void
		{
			for each(var target:IDropTarget in targets)
			{
				if(target.displayObject.hitTestPoint(event.stageX,event.stageY))
				{
					if(target == initiator)
					{
						proxy.visible = false;
						return;
					}
					else if(target.canAcceptDrop(data,initiator))
					{
						proxy.visible = true;
						proxy.alpha = 1.0;
						canDrop = true;
						currentTarget = target;
						return;
					}
				}
			}
			
			proxy.alpha = 0.4;
			proxy.visible = true;
			canDrop = false;
			currentTarget = null;
		}
				
		private function dragEnd(event:MouseEvent):void
		{
			if(canDrop)
			{
				currentTarget.acceptDrop(data);
			}
			
			proxy.stopDrag();
			
			initiator.displayContainer.removeChild(proxy);
			initiator.displayContainer.removeEventListener(MouseEvent.MOUSE_MOVE,dragging);
			initiator.displayContainer.removeEventListener(MouseEvent.MOUSE_UP,dragEnd);

			initiator = null;
			currentTarget = null;
			canDrop = false;
		}
	}
}