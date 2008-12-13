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
	import com.relivethefuture.errors.PathNotFoundError;
	import com.relivethefuture.events.PathStorageEvent;
	
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	
	/**
	 * Storage for <code>Path</code> objects.
	 * Usual object storage stuff, add, remove..
	 */
	public class PathStorage extends EventDispatcher
	{
		private var paths:Array;
		
		private var maxSize:int = 18;
		
		public function PathStorage()
		{
			paths = [];
		}

		/**
		 * Check if there is spare capacity
		 * 
		 * @returns	Boolean	true if there is still space left
		 */
		public function canAdd():Boolean
		{
			return paths.length < maxSize;
		}

		/**
		 * Stores a copy of supplied path
		 * 
		 * @param path The path to copy and store
		 */
		public function addPath(path:Path):void
		{
			var p:Path = path.clone();
			paths.push(p);
			dispatchEvent(new PathStorageEvent(PathStorageEvent.ADD,p));
		}
		
		/**
		 * Get the path at the specified index.
		 * 
		 * @param	int					the path index
		 * @throws	PathNotFoundError	if the index is out of range
		 * @returns	Path				the path you were looking for
		 */
		public function getPathAt(index:int):Path
		{
			if(index < 0 || index > paths.length - 1)
			{
				throw new PathNotFoundError();
			}
			
			return paths[index];
		}
		
		/**
		 * Whats encapsulation again?
		 * 
		 * Just grab the data here and do what you like :)
		 * 
		 * @returns	Array	the stored paths
		 */
		public function getPaths():Array
		{
			return paths;
		}
		
		/**
		 * Removes the path at the supplied index
		 *
		 * @param	int					the path index
		 * @throws	PathNotFoundError	if the index is out of range
		 */
		public function removePathAt(index:int):void
		{
			if(index < 0 || index > paths.length - 1)
			{
				throw new PathNotFoundError();
			}

			var item:Path = paths[index];
			
			paths.splice(index,1);
			dispatchEvent(new PathStorageEvent(PathStorageEvent.REMOVE,item));
		}
		
		/**
		 * Remove a particular path from storage, never to be seen again.
		 * 
		 * @param	Path	the path to remove
		 */
		public function removePath(p:Path):void
		{
			for(var i:int = 0;i<paths.length;i++)
			{
				if(paths[i] == p)
				{
					removePathAt(i);
				}
			}
		}
		
		/**
		 * How many paths are in the freezer.
		 * 
		 * @returns	int
		 */
		public function size():int
		{
			return paths.length;
		}
	}
}