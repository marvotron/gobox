/**
 * Copyright (c) 2008 Martin Wood-Mitrovski
 * 
 * Adapted from code by J Tarbell : www.levitated.net
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
	import com.relivethefuture.go.PlayableItem;
	
	import flash.geom.Rectangle;

	/**
	 * Field of ConnectableNodes.
	 * 
	 * <p>The NodeField is basically a container for <code>ConnectableNodes</code> with
	 * the typical range of managment features like adding and removing nodes in various
	 * ways</p>
	 * 
	 * <p>Updates are driven by the GoEngine.
	 * Use <code>GoEngine.addItem(field);</code></p>
	 * 
	 * <p>Provides 'centroid' calculation for each chain of nodes.
	 * Its not a real centroid calculation at the moment, just the average
	 * position of all the nodes in a chain.</p>
	 */
	public class NodeField extends PlayableItem implements NodeContainer
	{
		// List of Nodes
		protected var nodes:Array;
		
		// Bounding rectangle
		protected var _bounds:Rectangle;
		
		/**
		 * Construct a new <code>NodeField</code> with optional bounding rectangle.
		 * 
		 * @param	bounds	Rectangle	the bounding rectangle for all nodes in the field
		 */
		public function NodeField(bounds:Rectangle = null)
		{
			nodes = new Array();
			
			if(bounds != null)
			{
				_bounds = bounds;
			}
		}

		/**
		 * Set the bounding rectangle for the field.
		 * 
		 * <p>Any existing nodes are updated.</p>
		 * 
		 * @param	b	Rectangle	bounding rectangle
		 */
		public function set bounds(b:Rectangle):void
		{
			_bounds = b;
			
			for(var i:int = 0;i<nodes.length;i++)
			{
				nodes[i].bounds = _bounds;
			}
		}
		
		/**
		 * Add a node to the field.
		 * 
		 * <p>If the node is a <code>PhysicalNode</code> it will be given the same
		 * bounding rectangle as this field.</p>
		 * 
		 * @param	node	Node	the node to add
		 */
		public function addNode(node:Node):void
		{
			nodes.push(node);
			if(node is PhysicalNode)
			{
				var pn:PhysicalNode = node as PhysicalNode;
				pn.bounds = _bounds;
			}
			dispatchEvent(new NodeEvent(NodeEvent.ADD,node));
		}
		
		/**
		 * Insert a node at a specific place in the list.
		 * 
		 * <p>The new node will have be at <code>index + 1</code> in the node list</p>
		 * 
		 * @param node	Node	the node to insert
		 * @param index	int		the index after which to insert the node
		 */
		public function insertNodeAfter(node:Node, index:int):void
		{
			nodes.splice(index + 1,0,node);
			dispatchEvent(new NodeEvent(NodeEvent.ADD,node));
		}

		/**
		 * Replace the current list of nodes with a new one
		 * 
		 * @param	newNodes	Array	the new node list
		 */
		public function setNodes(newNodes:Array):void
		{
			nodes = newNodes;
			fireChangeEvent();
		}
		
		/**
		 * Get a list of all the nodes in the field
		 * 
		 * @return Array	node list
		 */
		public function getNodes():Array
		{
			return nodes;
		}
		
		/**
		 * Get the last node in the field
		 * 
		 * @return Node 	the last node
		 */
		public function getLastNode():Node
		{
			return nodes[nodes.length-1];
		}
		
		/**
		 * Get the first node in the field
		 * 
		 * @return Node	the first node
		 */
		public function getFirstNode():Node
		{
			if(nodes.length > 0)
			{
				return nodes[0];
			}
			return null;
		}
		
		/**
		 * Connect the supplied node to the nearest node in the field.
		 * 
		 * @param	node	ConnectableNode	the node to connect
		 * @param	maxDistance	the maximum distance between nodes being considered for connection
		 * @return	Number	distance from the supplied node to the one it connected to. 
		 * returns -1 if no connection is made
		 */
		public function connectNodeToNearest(node:Node,maxDistance:Number = 50):Number
		{
			if(node is ConnectableNode)
			{
				var distance:Number = (node as ConnectableNode).connectToNearest(nodes,maxDistance);
				return distance;			
			}
			return -1;
		}
		
		/**
		 * Remove a node at the specified index.
		 * 
		 * @param	index	int	the array index where the node is stored
		 */
		public function removeNodeAt(index:int):void
		{
			var node:Node = nodes[index];
			removeNode(node);
		}
		
		/**
		 * Remove the specified node from the field.
		 * 
		 * @param	node	Node	the node to remove
		 */
		public function removeNode(node:Node):void
		{
			if(node is ConnectableNode)
			{
				// Remove all connections to children
				(node as ConnectableNode).removeChildren();
			}
			
			var srcIndex:int = -1;
			
			for(var i:int = 0;i<nodes.length;i++)
			{
				var dest:Node = nodes[i];
				
				if(node != dest)
				{
					if(dest is ConnectableNode && node is ConnectableNode)
					{
						// Disconnect this node from any parents.
						(dest as ConnectableNode).disconnectFrom(node as ConnectableNode);
					}
				}
				else
				{
					srcIndex = i;
				}
				
			}
			
			if(srcIndex != -1)
			{
				nodes.splice(srcIndex,1);
			}
			dispatchEvent(new NodeEvent(NodeEvent.REMOVE,node));
		}
		
		/**
		 * Apply a random force to all nodes in the field.
		 * 
		 * @param strength	Number	how strong the random force might be
		 */
		public function randomPush(strength:Number = 2):void 
		{
			var t:Number = Math.floor(Math.random() * (nodes.length));
			var fdx:Number = (Math.random()-Math.random()) * strength;
			var fdy:Number = (Math.random()-Math.random()) * strength;
			nodes[t].applyForce(fdx,fdy);
		}

		/**
		 * Connect 2 nodes in the field by selecting them at random.
		 * 
		 * <p>Its possible that the two random nodes chosen are the same node,
		 * in which case no connection is made</p>
		 */
		public function makeRandomConnection():void
		{
			var a:int = Math.floor(Math.random() * (nodes.length));
			var b:int = Math.floor(Math.random() * (nodes.length));
			var nodeA:ConnectableNode = nodes[a];
			var nodeB:ConnectableNode = nodes[b];
			
			if (nodeA != nodeB) 
			{
				nodeA.connectTo(nodeB);
				fireChangeEvent();
			}
		}

		/**
		 * The main update function called by the GoEngine.
		 * 
		 * <p>During the update each node is updated by a call to its <code>update</code> method
		 * Also a call to the <code>updateNode(node:ConnectableNode)</code> method
		 * is made for every node in the field which subclasses can use to implement
		 * custom update functionality.</p>
		 * 
		 * <p>Then the centroid of each node chain is calculated and a <code>GoEvent.UPDATE</code>
		 * event is dispatched</p>
		 * 
		 * @param time	Number
		 */ 		
		override protected function onUpdate(time:Number):void
		{
			var node:ConnectableNode;
			
			for(var i:int = 0;i<nodes.length;i++)
			{
				nodes[i].update();
			}
		}
		
		/**
		 * Update friction coefficient for all nodes in the field.
		 * 
		 * @param	friction	Number	the new friction coefficient
		 */
		public function setFriction(f:Number):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:ConnectableNode = nodes[i];
				node.friction = f;
			}
		}
		
		/**
		 * Update maximum velocity for all nodes in the field.
		 * 
		 * @param	mv	Number	the new maximum velocity
		 */
		public function setMaxVelocity(mv:Number):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:ConnectableNode = nodes[i];
				node.maxVelocity = mv;
			}
		}

		/**
		 * Update maximum acceleration for all nodes in the field.
		 * 
		 * @param	ma	Number	the new maximum acceleration
		 */
		public function setMaxAcceleration(ma:Number):void
		{
			for(var i:int = 0;i<nodes.length;i++)
			{
				var node:ConnectableNode = nodes[i];
				node.maxAcceleration = ma;
			}
		}
		
		/**
		 * Utility for dispatching a <code>ChangeEvent</code>.
		 */
		protected function fireChangeEvent():void
		{
			dispatchEvent(new ChangeEvent(false,false));
		}

	}
}