package com.relivethefuture.components
{
	import com.relivethefuture.control.Node;
	
	import flash.display.DisplayObject;
	
	public interface NodeControlFactory
	{
		function createControl(node:Node,index:uint):DisplayObject;
	}
}