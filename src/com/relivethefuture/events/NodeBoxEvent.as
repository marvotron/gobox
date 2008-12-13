package com.relivethefuture.events
{
	import com.relivethefuture.components.NodeBox;
	
	import flash.events.Event;

	public class NodeBoxEvent extends Event
	{
		public static var ZOOM:String = "zoom";
		public static var CLOSE:String = "close";
		public static var INSPECT:String = "inspect";
		public static var CLEAR:String = "clear";
	
		public var nodeBox:NodeBox;
		
		public function NodeBoxEvent(type:String, box:NodeBox, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			nodeBox = box;
		}
		
	}
}