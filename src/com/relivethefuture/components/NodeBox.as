package com.relivethefuture.components
{
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.visual.NodeDisplay;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public interface NodeBox extends Inspectable
	{
		function getDisplay():NodeDisplay;
		function setNodeManager(manager:DisplayObject):void;
		function getNodeManager():DisplayObject;
		function start():void;
		function getBoundingRect():Rectangle;
		function getModel():NodeContainer;
	}
}