package com.relivethefuture.components
{
	import flash.display.DisplayObject;
	
	public interface Inspectable
	{
		function getInspector():DisplayObject;
		function underInspection(i:Boolean):void;
	}
}