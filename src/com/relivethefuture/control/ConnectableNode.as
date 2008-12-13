/**
 * Copyright (c) 2008 Martin Wood-Mitrovski
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.relivethefuture.control
{
	import com.relivethefuture.events.ConnectableNodeEvent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A connectable node can form part of a node chain
	 * 
	 * <p>Nodes can have multiple children, but only have one parent</p>
	 */
	public class ConnectableNode extends PhysicalNode
	{
		/**
		 * Children
		 */
		protected var connections:Array;
		
		/**
		 * Parent
		 */
		protected var parent:ConnectableNode;
		
		public function ConnectableNode(bounds:Rectangle,mass:Number)
		{
			super(bounds,mass);
			
			connections = [];
		}
		
		public function connectTo(node:ConnectableNode):void 
		{
			if (node.connections.length==0) 
			{
				connections.push(node);
				node.setParent(this);
			}
		}

		public function connectToNearest(nodeList:Array,maxDistance:Number = 50):Number
		{
			var minDistance:Number = maxDistance;
			var closestNode:ConnectableNode = null;
			
			for (var k:int = 0;k < nodeList.length;k++) 
			{
				var anode:ConnectableNode = nodeList[k];
				if (anode != this) 
				{
					var d:Number = distanceTo(anode);
					if (d < minDistance) 
					{
						minDistance = d;
						closestNode = anode;
					}
				}
			}
			
			if (closestNode != null) 
			{
				closestNode.connectTo(this);
				return minDistance;
			}
			return -1;
			
		}
		
		/**
		 * Disconnect this node from the passed node.
		 * 
		 * <p>Checks if the passed node is either a child of this node or is this nodes parent</p>
		 * 
		 * @param	node	the node to disconnect from
		 */
		public function disconnectFrom(node:ConnectableNode):void 
		{
			removeChild(node);
			if(node == parent)
			{
				removeParent();
			}
		}
		
		/**
		 * Remove the parent node
		 */
		private function removeParent():void
		{
			parent = null;
			dispatchEvent(new ConnectableNodeEvent(ConnectableNodeEvent.HEIRARCHY_CHANGED,this));		
		}
		
		/**
		 * Remove a single child
		 * 
		 * @param	child	the child node to remove
		 */
		public function removeChild(child:ConnectableNode):void
		{
			for (var n:int = 0;n<connections.length;n++)
			{
				if (connections[n] == child) 
				{
					connections[n].removeParent();
					connections.splice(n,1);
					break;
				}
			}
		}
		
		public function hasParent():Boolean
		{
			return parent != null;
		}
		
		/**
		 * Is this node the head of a chain
		 * 
		 * <p>A node is only considered the head of a chain 
		 * when it has no parent and has one or more children.</p>
		 * 
		 * @return	true if the node has no parent and has children
		 */
		public function isHead():Boolean
		{
			return (parent == null) && (connections.length > 0);
		}
		
		/**
		 * Remove all child connections.
		 */
		public function removeChildren():void
		{
			for (var n:int = 0;n<connections.length;n++)
			{
				var c:ConnectableNode = connections[n];
				c.disconnectFrom(this);
			}
			
			connections = [];
		}
		
		/**
		 * Make this node a child of the supplied node.
		 * 
		 * @param	node	the new parent
		 */
		private function setParent(node:ConnectableNode):void
		{
			parent = node;
			dispatchEvent(new ConnectableNodeEvent(ConnectableNodeEvent.HEIRARCHY_CHANGED,this));
		}
		
		public function getConnections():Array
		{
			return connections;
		}
		
		public function getParent():ConnectableNode
		{
			return parent;
		}
		
		public function seperate(nodes:Array):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:ConnectableNode = nodes[i];
				if(node == this) continue;
				var dist:Number = distanceTo(node);
				var dx:Number = (x - node.x) * 0.01;
				var dy:Number = (y - node.y) * 0.01;
				
				var _a:Point = node.acceleration.subtract(_acceleration);
				
				applyForce(new Point(dx + _a.x,dy + _a.y));
			}
		}
				
		public function calculateAverage():Object
		{
			var p:Point = new Point(x,y);
			
			var count:int = 1;
			
			for (var n:int = 0;n<connections.length;n++)
			{
				var node:ConnectableNode = connections[n];
				var c:Object = node.calculateAverage();
				p = p.add(c.point);
				count += c.count;
			}
			
			p.x = p.x;
			p.y = p.y;
			return {point:p,count:count};
		}		
	}
}