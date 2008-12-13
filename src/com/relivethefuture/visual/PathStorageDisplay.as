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
	import com.bit101.components.Panel;
	import com.relivethefuture.control.Path;
	import com.relivethefuture.control.PathStorage;
	import com.relivethefuture.events.PathStorageEvent;
	import com.relivethefuture.system.DragAndDropManager;
	import com.relivethefuture.system.IDragInitiator;
	import com.relivethefuture.system.IDropTarget;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class PathStorageDisplay extends Sprite implements IDropTarget
	{
		private var pathStorage:PathStorage;
		private var pathIcons:Array;
		
		private var backPanel:Panel;
	
		private var itemWidth:Number = 24;
		
		private var columns:int = 6;
		
		public function PathStorageDisplay()
		{
			super();
			
			pathIcons = [];
			backPanel = new Panel(this);
			backPanel.setSize((itemWidth * columns) + 5,78);
			DragAndDropManager.getInstance().registerDropTarget(this);	
		}
		
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		public function canAcceptDrop(obj:*,source:IDragInitiator):Boolean
		{
			if((obj is Path) && pathStorage.canAdd())
			{
				for each(var pathIcon:PathIcon in pathIcons)
				{
					if(pathIcon == source) return false;
				}
			}
			return true;
		}

		public function acceptDrop(obj:*):void
		{
			if((obj is Path) && pathStorage.canAdd())
			{
				pathStorage.addPath(obj as Path);
			}
		}
		
		public function setPathStorage(pathStorage:PathStorage):void
		{
			if(this.pathStorage != null)
			{
				removeAllIcons();
			}
			
			this.pathStorage = pathStorage;
			
			var paths:Array = pathStorage.getPaths();
			for(var i:int = 0;i<paths.length;i++)
			{
				var p:Path = paths[i];
				createPathIcon(p);
			}
			
			draw();
			
			pathStorage.addEventListener(PathStorageEvent.ADD,pathAdded);
			pathStorage.addEventListener(PathStorageEvent.REMOVE,pathRemoved);
		}
		
		private function removeAllIcons():void
		{
			for(var i:int = 0;i<pathIcons.length;i++)
			{
				removeChild(pathIcons[i]);
			}
			pathIcons = [];
		}
		
		public function getPathStorage():PathStorage
		{
			return pathStorage;
		}
		
		public function createPathIcon(path:Path):void
		{
			var pathIcon:PathIcon = new PathIcon(true,true);
			pathIcon.path = path;
			pathIcon.addEventListener(PathStorageEvent.REMOVE,removePath);
			addChild(pathIcon);
			pathIcon.init();
			pathIcons.push(pathIcon);
		}
		
		private function pathAdded(event:PathStorageEvent):void
		{
			trace("Path Added : " + event.path.getNodes().length);

			createPathIcon(event.path);			
			draw();
		}
		
		// Called from the path icon
		// TODO : dont use the path storage event
		private function removePath(event:PathStorageEvent):void
		{
			pathStorage.removePath(event.path);
		}
		
		private function pathRemoved(event:PathStorageEvent):void
		{
			trace("Path Removed : " + event.path + " : " + pathIcons.length);
			for(var i:int = 0;i<pathIcons.length;i++)
			{
				if(pathIcons[i].path == event.path)
				{
					removeChild(pathIcons[i]);
					pathIcons.splice(i,1);
					draw();
					return;
				}
			}
		}
		
		private function draw():void
		{
			for(var i:int = 0;i<pathIcons.length;i++)
			{
				var pathIcon:PathIcon = pathIcons[i];
				pathIcon.x = ((i % columns) * itemWidth) + 5;
				pathIcon.y = 5 + (Math.floor(i / columns) * itemWidth);
			}
		}
	}
}