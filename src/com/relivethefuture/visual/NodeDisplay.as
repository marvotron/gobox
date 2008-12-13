package com.relivethefuture.visual
{
	import com.relivethefuture.control.Node;
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.events.ChangeEvent;
	import com.relivethefuture.events.DeleteNodeEvent;
	import com.relivethefuture.events.NodeEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NodeDisplay extends Sprite
	{
		protected var nodes:Array;
		private var selectedNode:NodeSprite;

		private var nodeFactory:INodeSpriteFactory;

		protected var model:NodeContainer;
		
		public function NodeDisplay()
		{
			nodes = [];
			nodeFactory = new NodeSpriteFactory();			
		}
		
		public function setNodeFactory(factory:INodeSpriteFactory):void
		{
			nodeFactory = factory;
		}
				
		public function setModel(nc:NodeContainer):void
		{
			if(model != null)
			{
				unbindModel(model);
			}
			model = nc;
			
			bindModel(model);
		}
		
		protected function bindModel(model:NodeContainer):void
		{
			model.addEventListener(NodeEvent.ADD,nodeAdded);
			model.addEventListener(NodeEvent.REMOVE,nodeRemoved);
			model.addEventListener(ChangeEvent.CHANGE,modelChanged);
		}
		
		protected function unbindModel(model:NodeContainer):void
		{
			model.removeEventListener(NodeEvent.ADD,nodeAdded);
			model.removeEventListener(NodeEvent.REMOVE,nodeRemoved);
			model.removeEventListener(ChangeEvent.CHANGE,modelChanged);
			removeAllNodes();
		}
		
		protected function nodeAdded(event:NodeEvent):void
		{
			addNode(event.node);
			draw();
		}
		
		private function nodeRemoved(event:NodeEvent):void
		{
			removeNode(event.node);
			draw();
		}
		
		protected function modelChanged(event:Event):void
		{
			draw();
		}
		
		protected function removeAllNodes():void
		{
			while(nodes.length > 0)
			{
				removeNode(model.getLastNode());
			}	
		} 
		
		protected function addNode(node:Node = null):void
		{
			var ns:NodeSprite = nodeFactory.createNodeSprite();
			
			if(node == null)
			{
				node = model.getLastNode();
			}
			
			ns.setNode(node);

			addChild(ns);

			ns.addEventListener(DeleteNodeEvent.DELETE,deleteNode);
			ns.addEventListener(MouseEvent.CLICK,nodeClicked);
			nodes.push(ns);
		}
		
		protected function removeNode(node:Node):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{			
				var ns:NodeSprite = nodes[i];
				if(ns.getNode() == node)
				{
					ns.removeEventListener(DeleteNodeEvent.DELETE,deleteNode);
					ns.removeEventListener(MouseEvent.CLICK,nodeClicked);
					ns.dispose();
					removeChild(ns);
					nodes.splice(i,1);
					return;
				}
			}
		}
		
		/**
		 * User event
		 */
		protected function deleteNode(event:DeleteNodeEvent):void
		{
			model.removeNode(event.node.getNode());
		}
							
		protected function nodeClicked(event:MouseEvent):void
		{
			selectNodeSprite(event.target as NodeSprite);
		}
				
		public function selectNode(n:Node):void
		{
			for(var i:uint = 0;i<nodes.length;i++)
			{
				var ns:NodeSprite = nodes[i];
				if(ns.getNode() == n)
				{
					selectNodeSprite(ns);
					return;
				}
			}
		}
				
		protected function selectNodeSprite(n:NodeSprite):void
		{
			if(selectedNode != null)
			{
				selectedNode.selected = false;
			}
			selectedNode = n;
			selectedNode.selected = true;
			
			dispatchEvent(new NodeEvent(NodeEvent.SELECT,selectedNode.getNode(),true));
		}
	
		protected function draw(obj:* = null):void
		{
			
		}			
	}
}