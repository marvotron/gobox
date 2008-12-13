package com.relivethefuture.components
{
	import com.hydrotik.go.HydroTween;
	import com.relivethefuture.control.Node;
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.events.NodeEvent;
	import com.relivethefuture.visual.NodeDisplay;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.effects.easing.Linear;
	import mx.effects.easing.Quintic;

	public class BasicNodeManager extends Sprite
	{
		protected var box:NodeBox;
		
		private var nodeContainer:NodeContainer;
		private var nodeDisplay:NodeDisplay;
		
		private var controls:Dictionary;
		protected var controlFactory:NodeControlFactory;
		
		private var selectedControl:Sprite;
		
		protected var nodeListOffset:Number = 0;
		
		public function BasicNodeManager(nb:NodeBox)
		{
			super();
			
			box = nb;
			
			nodeDisplay = nb.getDisplay();
			nodeDisplay.addEventListener(NodeEvent.SELECT,nodeSelected);
			
			nodeContainer = nb.getModel();
			nodeContainer.addEventListener(NodeEvent.ADD,nodeAdded);
			nodeContainer.addEventListener(NodeEvent.REMOVE,nodeRemoved);
			
			setup();
			createControls();
		}
		
		protected function setup():void
		{
			
		}
		
		public function setNodeControlFactory(f:NodeControlFactory):void
		{
			controlFactory = f;
		}
		
		private function nodeSelected(event:NodeEvent):void
		{
			trace("NODE SELECTED : " + event.node);
			
			var control:Sprite = controls[event.node];
			
			if(control != null)
			{
				setSelected(control);
			}
		}
		
		private function setSelected(c:Sprite):void
		{
			if(selectedControl != null)
			{
				HydroTween.go(selectedControl, {Glow_color:0xFF0000, Glow_blurX:0, Glow_blurY:0, Glow_alpha:0, Glow_strength:0}, 0.2, 0, Linear.easeNone, null, null, null);
			}
			
			selectedControl = c;
			
			HydroTween.go(selectedControl, {Glow_color:0xFF0000, Glow_blurX:2, Glow_blurY:2, Glow_alpha:0.4, Glow_strength:3}, 0.2, 0, Linear.easeNone, null, null, null);
		}
		
		private function nodeAdded(event:NodeEvent):void
		{
			createNodeControl(event.node,numChildren);
			draw();
		}
		
		private function nodeRemoved(event:NodeEvent):void
		{
			removeChild(controls[event.node]);
			controls[event.node] = null;
			delete controls[event.node];
			draw();
		}
		
		protected function createControls():void
		{
			controls = new Dictionary();
			
			var nodes:Array = nodeContainer.getNodes();
			
			for(var i:uint = 0;i<nodes.length;i++)
			{
				var nc:DisplayObject = createNodeControl(nodes[i],i);
			}
			
			draw();
		}
		
		private function createNodeControl(node:Node,index:uint):DisplayObject
		{
			var nc:DisplayObject = controlFactory.createControl(node,index);

			nc.addEventListener(Event.SELECT,nodeControlSelected);
			
			controls[node] = nc;
			addChild(nc);
			nc.alpha = 0;
			HydroTween.go(nc, {alpha:1}, 0.7, 0, Quintic.easeOut, null, null, null,null);			
			return nc;
		}
		
		private function nodeControlSelected(event:Event):void
		{
			for(var node:Object in controls)
			{
				if(controls[node] == event.target)
				{
					nodeDisplay.selectNode(node as Node);
				}
			}
		}
		
		private function draw():void
		{
			var cy:uint = nodeListOffset;
			var nodes:Array = nodeContainer.getNodes();
			for(var i:uint = 0;i<nodes.length;i++)
			{
				controls[nodes[i]].y = cy;
				cy += 22;
			}
		}
	}
}