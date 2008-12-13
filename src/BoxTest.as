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
package
{
	import com.relivethefuture.components.PathBox;
	import com.relivethefuture.control.Node;
	import com.relivethefuture.control.NodeContainer;
	import com.relivethefuture.control.PathStorage;
	import com.relivethefuture.visual.PathStorageDisplay;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.effects.easing.*;
	
	public class BoxTest extends MovieClip
	{
		private var pathStorage:PathStorageDisplay;
		
		private var boxes:Sprite;
		
		private var pathBox:PathBox;
		private var pathBox2:PathBox;
		
		public function BoxTest()
		{
			pathStorage = new PathStorageDisplay();
			pathStorage.x = 20;
			pathStorage.y = 200;
			
			addChild(pathStorage);
			
			pathStorage.setPathStorage(new PathStorage());
			
			boxes = new Sprite();
			addChild(boxes);
				
			pathBox = new PathBox(new Rectangle(0,0,100,100));
			pathBox.x = 20;
			pathBox.y = 20;

			var p1:NodeContainer = pathBox.getModel();
			p1.addNode(new Node(0,0));
			p1.addNode(new Node(100,0));
			p1.addNode(new Node(100,100));
			p1.addNode(new Node(0,100));

			pathBox2 = new PathBox(new Rectangle(0,0,100,100));
			pathBox2.x = 200;
			pathBox2.y = 20;
			
			var p2:NodeContainer = pathBox2.getModel();
			p2.addNode(new Node(50,0));
			p2.addNode(new Node(100,40));
			p2.addNode(new Node(75,100));
			p2.addNode(new Node(25,100));
			p2.addNode(new Node(0,40));

			pathBox.start();
			pathBox2.start();
		}
	}
}