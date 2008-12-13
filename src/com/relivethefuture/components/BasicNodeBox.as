package com.relivethefuture.components
{
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.events.ControlBoxEvent;
	import com.relivethefuture.events.StartDragEvent;
	import com.relivethefuture.system.DragAndDropManager;
	import com.relivethefuture.system.IDragInitiator;
	import com.relivethefuture.system.IDropTarget;
	import com.relivethefuture.visual.NodeDisplay;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.goasap.interfaces.IPlayable;

	public class BasicNodeBox extends Sprite implements NodeBox, IDragInitiator, IDropTarget
	{
		protected var controlBox:ControlBox;
		protected var transport:GoTransport;
		protected var buttonBar:BoxButtonBar;
		
		private var nodeManager:DisplayObject;
		private var inspector:DisplayObject;
		
		protected var boundingRect:Rectangle;
		
		protected var display:NodeDisplay;
		protected var model:NodeContainer;
		
		private var container:Sprite;
		private var overlay:Sprite;
		
		public function BasicNodeBox(br:Rectangle,useDragAndDrop:Boolean = false)
		{
			container = new Sprite();
			addChild(container);
	
			trace("NEW BasicNodeBox : " + br.x + "," + br.y + " : " + br.width + ", " + br.height);
			
			if(br == null)
			{
				boundingRect = new Rectangle(0,0,400,400);
			}
			else
			{
				boundingRect = br;
			}

			controlBox = new ControlBox(boundingRect);
			container.addChild(controlBox);
			controlBox.addEventListener(ControlBoxEvent.CLICK,boxClicked);

			transport = new GoTransport();
			container.addChild(transport);

			buttonBar = new BoxButtonBar(this);
			container.addChild(buttonBar);
			
			transport.x = boundingRect.width - 39;
			transport.y = boundingRect.height + 2;

			buttonBar.x = 0;
			buttonBar.y = boundingRect.height + 2;
			
			model = createModel();
			display = createDisplay(controlBox);
			
			if(model != null && display != null)
			{
				display.setModel(model);
			}
			
			inspector = createInspector();
			if(useDragAndDrop)
			{
				setupDragAndDrop();
			}
			
			overlay = new Sprite();
			addChild(overlay);
		}
		
		public function getBoundingRect():Rectangle
		{
			return boundingRect;
		}
		
		public function getDisplay():NodeDisplay
		{
			return display;
		}
		
		protected function createModel():NodeContainer
		{
			return null;
		}
		
		public function getModel():NodeContainer
		{
			return model;
		}
		
		protected function createDisplay(parent:DisplayObjectContainer):NodeDisplay
		{
			return new NodeDisplay();
		}
		
		protected function createInspector():DisplayObject
		{
			return null;
		}
		
		public function underInspection(i:Boolean):void
		{
			trace("Under Inspection : " + i);
			
			overlay.graphics.clear();
			if(i)
			{
				overlay.graphics.lineStyle(0,0xFF0000,1);
				overlay.graphics.drawRect(boundingRect.x,boundingRect.y,boundingRect.width,boundingRect.height);
			}
		}
		
		protected function setupDragAndDrop():void
		{
			controlBox.addEventListener(ControlBoxEvent.PRESS,startDragAndDrop);
			DragAndDropManager.getInstance().registerDropTarget(this);
		}
		
		protected function boxClicked(event:ControlBoxEvent):void
		{
			
		}
		
		public function start():void
		{
			if(model is IPlayable)
			{
				(model as IPlayable).start();
			}
		}
		
		public function stop():void
		{
			if(model is IPlayable)
			{
				(model as IPlayable).stop();
			}
		}
		
		public function getInspector():DisplayObject
		{
			return inspector;
		}
		
		public function setNodeManager(manager:DisplayObject):void
		{
			nodeManager = manager;
		}
		
		public function getNodeManager():DisplayObject
		{
			return nodeManager;
		}

		// DRAG AND DROP HANDLING
		public function get displayContainer():DisplayObjectContainer
		{
			return stage;
		}
		
		public function get displayObject():DisplayObject
		{
			return controlBox;
		}
		
		public function canAcceptDrop(data:*,source:IDragInitiator):Boolean
		{
			return false
		}
		
		public function acceptDrop(data:*):void
		{
		}
		
		private function startDragAndDrop(event:ControlBoxEvent):void
		{
			var sde:StartDragEvent = createStartDragEvent();
			DragAndDropManager.getInstance().startDrag(sde);
		}
		
		protected function createStartDragEvent():StartDragEvent
		{
			return null;
		}
	}
}