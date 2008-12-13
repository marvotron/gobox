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
	import com.relivethefuture.events.ChangeEvent;
	import com.relivethefuture.events.NodeEvent;
	
	import flash.events.EventDispatcher;
	
	[Event(name="change", type="com.relivethefuture.events.ChangeEvent")]
	
	public class Path extends EventDispatcher implements NodeContainer
	{
		private var nodes:Array;
		private var segments:Array;
		private var changeEvent:ChangeEvent;
		private var closed:Boolean;
		
		private var currentPosition:Node;
		
		public function Path()
		{
			nodes = [];
			segments = [];
			closed = true;
			currentPosition = new Node();
			
			changeEvent = new ChangeEvent();
		}

		public function isClosed():Boolean
		{
			return closed;
		}
		
		public function getNodes():Array
		{
			return nodes;
		}
		
		public function setNodes(newNodes:Array):void
		{
			if(newNodes && newNodes.length > 1)
			{
				if(nodes != null)
				{
					for each(var p:Node in nodes)
					{
						p.removeEventListener(ChangeEvent.CHANGE,nodeChanged);
					}
				}
				nodes = newNodes;
				for(var i:int = 0;i<nodes.length;i++)
				{
					nodes[i].addEventListener(ChangeEvent.CHANGE,nodeChanged);
				}
				updateSegments();
				fireChangeEvent();
			}
		}
		
		public function addNode(p:Node):void
		{
			nodes.push(p);
			nodeAdded(p);
		}

		public function insertNodeAfter(p:Node, index:int):void
		{
			nodes.splice(index + 1,0,p);
			nodeAdded(p);
		}

		public function removeNodeAt(index:int):void
		{
			var node:Node = nodes[index];
			nodes.splice(index,1);
			segments.splice(index,1);
			updateSegments();
			dispatchEvent(new NodeEvent(NodeEvent.REMOVE,node));
			fireChangeEvent();
		}
		
		public function removeNode(p:Node):void
		{
			removeNodeAt(nodes.indexOf(p));
		}
		
		public function getLastNode():Node
		{
			return nodes[nodes.length-1];
		}
		
		public function getFirstNode():Node
		{
			if(nodes.length > 0)
			{
				return nodes[0];
			}
			return null;
		}
		
		/**
		 * Add a new node at the supplied position by finding the nearest line
		 * segment and inserting after the start node of that segment
		 */ 
		public function connectNodeToNearest(node:Node,maxDistance:Number = 50):Number
		{
			// Distance of closest node, start at a value higher than it can actually be
			var minLength:Number = 1000;
			var closestNodeIndex:int;
			
			var numSegs:int = segments.length;
			var numNodes:int = nodes.length;
			
			for(var i:int = 0;i<numSegs;i++)
			{
				var p1:Node = nodes[i];
				var p2:Node = nodes[(i + 1) % numNodes];
				var len:Number = distanceToLine(node,p1,p2);
				if(len < minLength)
				{
					closestNodeIndex = i;
					minLength = len;
				}				
			}
			
			insertNodeAfter(node,closestNodeIndex);

			return minLength;
		}
		
		public function getCurrentPosition():Node
		{
			return currentPosition;
		}
		
		/**
		 * Find the position at a particular place along the path.
		 * @param pos : Number between 0 and 1. 0 is the start of the path and 1 is the end
		 * @return Node position along the path
		 */
		public function updatePosition(pos:Number):Node
		{
			for(var j:int = 0;j<segments.length;j++)
			{
				var s:Object = segments[j];
				if(s.start <= pos && pos <= s.end)
				{
					// Its in this segment
					var d:Number = (pos - s.start) / (s.end - s.start);
					var x:Number = nodes[j].x + (s.ndx * d);
					var y:Number = nodes[j].y + (s.ndy * d);
					currentPosition.moveTo(x,y);
					return currentPosition;
				}
			}
			return currentPosition;
		}
		
		/**
		 * Calculate the distance from Node p to a line defined by nodes s1 and s2
		 * NOTE : the result is actually the distance squared, but its only used for
		 * comparisons so that doesnt matter.
		 */
		private function distanceToLine( p:Node, s1:Node, s2:Node):Number
		{
		    var lineLen:Number = ((s2.x - s1.x) * (s2.x - s1.x)) + ((s2.y - s1.y) * (s2.y - s1.y));
		 	
		    var u:Number = (((p.x - s1.x) * (s2.x - s1.x)) + ((p.y - s1.y) * (s2.y - s1.y))) / lineLen;
		 
		 	var x:Number;
		 	var y:Number;
		 	
		 	if(u < 0)
		 	{
		 		// distance is from p to s1
		 		x = s1.x;
		 		y = s1.y;
		 	}
		 	else if(u > 1)
		 	{
		 		// distance is from p to s2
		 		x = s2.x;
		 		y = s2.y
		 	}
			else
			{		 
		    	x = s1.x + u * (s2.x - s1.x);
		    	y = s1.y + u * (s2.y - s1.y);
		 	}
		    return ((p.x - x) * (p.x - x)) + ((p.y - y) * (p.y - y));
		}
		
		/**
		 * Calculate useful information about the path.
		 * Length of each segment, their direction vectors (both actual and normalised)
		 * The start and end values for each segment represent the position in the whole
		 * path for that segment, if the whole path is considered to be a parametric line p(x)
		 * which runs from p(0) to p(1).
		 */
		private function updateSegments():void
		{
			if(nodes.length < 2) return;
			var totalLength:Number = 0;
			var pl:int = nodes.length;
			var max:int = pl + (closed ? 1 : 0);
			for(var i:int = 1;i<max;i++)
			{
				var p1:Node = nodes[i-1];
				var p2:Node = nodes[i % pl];
				var s:Object = segments[i-1];
				// Check if the segment has been built
				if(s == null)
				{
					// No segment so create a new one
					s = {length:0,start:0,end:1};
					segments[i-1] = s;
				}
				var dx:Number = p2.x - p1.x;
				var dy:Number = p2.y - p1.y;
				s.length = Math.sqrt((dx*dx) + (dy*dy));
				s.dx = dx;
				s.dy = dy;
				s.ndx = dx / length;
				s.ndy = dy / length;
				totalLength += s.length;  
			}
			
			var accumLength:Number = 0;
			for(var j:Number = 0;j<segments.length;j++)
			{
				var seg:Object = segments[j];
				seg.start = accumLength / totalLength;
				accumLength += seg.length;
				seg.end = accumLength / totalLength;
			}
		}
		
		private function nodeChanged(event:ChangeEvent):void
		{
			updateSegments();
			fireChangeEvent();
		}

		private function nodeAdded(p:Node):void
		{		
			p.addEventListener(ChangeEvent.CHANGE,nodeChanged);
			if(nodes.length > 1)
			{
				segments.push({length:0,start:0,end:1});
				// If its a closed path then there is a segment for every node
				if(closed && segments.length < nodes.length)
				{
					segments.push({length:0,start:0,end:1});
				}
				updateSegments();
			}
			dispatchEvent(new NodeEvent(NodeEvent.ADD,p));
			fireChangeEvent();
		}

		private function fireChangeEvent():void
		{
			dispatchEvent(changeEvent);
		}
		
		public function clone():Path
		{
			var p:Path = new Path();
			for each(var node:Node in nodes)
			{
				p.addNode(node.clone());
			}
			return p;
		}
	}
}