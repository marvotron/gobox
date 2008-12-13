package com.relivethefuture.go
{
	import com.relivethefuture.control.Node;
	import com.relivethefuture.control.Path;
	
	public class GoPath extends LiveGo
	{
		private var path:Path;
		
		public function GoPath()
		{
			super();
			path = new Path();
		}

		public function setPath(p:Path):void
		{
			path = p;
		}
		
		public function getPath():Path
		{
			return path;
		}
		
		public function getPositionNode():Node
		{
			return path.getCurrentPosition();
		}
		
		override protected function onUpdate(type:String):void
		{
			var pos:Number = correctValue(_position);
			path.updatePosition(pos);
		}				
	}
}