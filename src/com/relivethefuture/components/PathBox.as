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
	import com.relivethefuture.control.Node;
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.control.Path;
	import com.relivethefuture.events.ControlBoxEvent;
	import com.relivethefuture.events.StartDragEvent;
	import com.relivethefuture.go.GoPath;
	import com.relivethefuture.system.IDragInitiator;
	import com.relivethefuture.visual.NodeDisplay;
	import com.relivethefuture.visual.PathDisplay;
	import com.relivethefuture.visual.PathIcon;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import org.goasap.events.GoEvent;
	
	public class PathBox extends BasicNodeBox
	{
		private var pathDisplay:PathDisplay;
		private var goPath:GoPath;
		
		public function PathBox(boundingRect:Rectangle)
		{
			super(boundingRect);
		}
		
		// DRAG AND DROP HANDLING
		override public function canAcceptDrop(data:*,source:IDragInitiator):Boolean
		{
			return data is Path && source != this;
		}
		
		override public function acceptDrop(data:*):void
		{
			if(data is Path)
			{
				var p:Path = data as Path;
				goPath.setPath(p);
				pathDisplay.setModel(p);
			}
		}
		
		// NODE BOX IMPLEMENTATIONS
		override protected function createModel():NodeContainer
		{
			goPath = new GoPath();
			goPath.addEventListener(GoEvent.UPDATE,update);
			transport.setItem(goPath);
			return goPath.getPath();
		}

		public function getGoPath():GoPath
		{
			return goPath;
		}
		
		override public function getModel():NodeContainer
		{
			return goPath.getPath();
		}
				
		override protected function createDisplay(parent:DisplayObjectContainer):NodeDisplay
		{
			var pathDisplay:PathDisplay = new PathDisplay();
			parent.addChild(pathDisplay);
			pathDisplay.setModel(goPath.getPath());
			pathDisplay.setPositionNode(goPath.getPositionNode());
			return pathDisplay;
		}
		
		override protected function createInspector():DisplayObject
		{
			var inspector:PathInspector = new PathInspector();
			inspector.setPath(goPath);
			return inspector;
		}

		override protected function boxClicked(event:ControlBoxEvent):void
		{
			goPath.getPath().connectNodeToNearest(new Node(event.point.x,event.point.y));
		}
		
		override protected function createStartDragEvent():StartDragEvent
		{
			var dragProxy:PathIcon = new PathIcon();
			dragProxy.path = goPath.getPath();
			return new StartDragEvent(this,goPath.getPath().clone(),dragProxy);
		}
				
		private function update(event:GoEvent):void
		{
			//dispatchEvent(new BoxUpdateEvent(positionNode,pos));
		}
	}
}