package com.relivethefuture.components
{
	import com.bit101.components.PushButton;
	import com.relivethefuture.events.NodeBoxEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BoxButtonBar extends Sprite
	{
		private var showInspectorButton:PushButton;
		private var closeBoxButton:PushButton;
		private var zoomButton:PushButton;
		//private var zoomOutButton:PushButton;
		
		private var box:NodeBox;
		
		public function BoxButtonBar(b:NodeBox)
		{
			super();
			
			box = b;
			showInspectorButton = new PushButton(this,0,0,"I");
			closeBoxButton = new PushButton(this,20,0,"X");
			zoomButton = new PushButton(this,40,0,"+");
			
			showInspectorButton.setSize(20,20);
			closeBoxButton.setSize(20,20);
			zoomButton.setSize(20,20);
			
			showInspectorButton.addEventListener(MouseEvent.CLICK,showInspector);
			closeBoxButton.addEventListener(MouseEvent.CLICK,closeBox);
			zoomButton.addEventListener(MouseEvent.CLICK,zoom);
			
			zoomButton.toggle = true;
		}
		
		private function showInspector(event:MouseEvent):void
		{
			dispatchEvent(new NodeBoxEvent(NodeBoxEvent.INSPECT,box,true,true));
		}
		
		private function closeBox(event:MouseEvent):void
		{
			dispatchEvent(new NodeBoxEvent(NodeBoxEvent.CLOSE,box,true,true));
		}
		
		private function zoom(event:MouseEvent):void
		{
			trace("ZOOM : " + zoomButton.selected);
			zoomButton.label = zoomButton.selected ? "~" : "+";
			dispatchEvent(new NodeBoxEvent(NodeBoxEvent.ZOOM,box,true,true));
		}	
	}
}