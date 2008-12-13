package com.relivethefuture.components
{
	import com.bit101.components.Panel;
	import com.bit101.components.RadioButton;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class BoxInspector extends Sprite
	{
		private static var BOX:String = "box";
		private static var NODES:String = "nodes";
		private var mode:String;
		
		private var inspectors:Dictionary;
		private var nodeManagers:Dictionary;
		
		private var currentTarget:Inspectable;
		
		private var currentDisplay:DisplayObject;
		
		private var panel:Panel;
		
		private var manageBoxButton:RadioButton;
		private var manageNodesButton:RadioButton;
		
		public function BoxInspector()
		{
			super();
			inspectors = new Dictionary();
			nodeManagers = new Dictionary();
			
			panel = new Panel(this,0,0);
			panel.setSize(250,250);
			
			manageBoxButton = new RadioButton(panel,4,4,"Box");
			manageNodesButton = new RadioButton(panel,54,4,"Nodes");
			
			manageBoxButton.addEventListener(MouseEvent.CLICK,manageBox);
			manageNodesButton.addEventListener(MouseEvent.CLICK,manageNodes);
			
			mode = BOX;
			manageBoxButton.selected = true;
		}
		
		private function manageBox(event:MouseEvent):void
		{
			currentDisplay.visible = false;
			
			currentDisplay = inspectors[currentTarget];
			
			currentDisplay.visible = true;
			
			mode = BOX;
		}
		
		private function manageNodes(event:MouseEvent):void
		{
			if(nodeManagers[currentTarget] == null)
			{
				return;
			}			
			
			if(currentDisplay != null)
			{
				currentDisplay.visible = false;
			}
			
			currentDisplay = nodeManagers[currentTarget];
			
			currentDisplay.visible = true;
			
			mode = NODES;
		}
		
		public function addItem(src:Inspectable):void
		{
			// General Inspector
			var display:DisplayObject = src.getInspector();
			panel.addChild(display);
			display.x = 8;
			display.y = 24;
			display.visible = false;
			inspectors[src] = display;
			
			// Node Manager
			if(src is NodeBox)
			{
				trace("ADD ITEM : NODEBOX");
				var nb:NodeBox = src as NodeBox;
				var manager:DisplayObject = nb.getNodeManager();
				if(manager != null)
				{
					manager.x = 8;
					manager.y = 24;
					panel.addChild(manager);
					manager.visible = false;
					nodeManagers[src] = manager;
				}
				else
				{
					manager = new Sprite();
				}
			}
		}
		
		public function show(src:Inspectable):void
		{
			trace("Show : " + src);
			
			if(currentDisplay != null)
			{
				currentDisplay.visible = false;
			}

			if(currentTarget != null)
			{
				currentTarget.underInspection(false);				
			}
			
			if(mode == BOX)
			{
				currentDisplay = inspectors[src];
			}
			else if(mode == NODES)
			{
				currentDisplay = nodeManagers[src];	
			}
			
			currentDisplay.visible = true;
			
			currentTarget = src;
			
			if(currentTarget != null)
			{
				currentTarget.underInspection(true);				
			}
		}
	}
}