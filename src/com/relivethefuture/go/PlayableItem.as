package com.relivethefuture.go
{
	import org.goasap.GoEngine;
	import org.goasap.PlayStates;
	import org.goasap.events.GoEvent;
	import org.goasap.interfaces.IPlayable;
	import org.goasap.items.GoItem;

	public class PlayableItem extends GoItem implements IPlayable
	{
		public function PlayableItem()
		{
			super();
		}
		
		public function start():Boolean
		{
			stop(); // does nothing if already stopped.
			if (GoEngine.addItem(this)==false)
			{
				return false;
			}

			_state = PlayStates.PLAYING;
			dispatchEvent(new GoEvent(GoEvent.START));
			return true;
		}
		
		public function stop():Boolean
		{
			if (_state == PlayStates.STOPPED || GoEngine.removeItem(this)==false)
			{
				return false;
			}
			
			_state = PlayStates.STOPPED;
			dispatchEvent(new GoEvent(GoEvent.STOP));
			return true;		
		}
		
		public function pause():Boolean
		{
			if (_state == PlayStates.STOPPED || _state == PlayStates.PAUSED)
			{
				return false;
			}
			_state = PlayStates.PAUSED
			dispatchEvent(new GoEvent(GoEvent.PAUSE));
			return true;
		}
		
		public function resume():Boolean
		{
			if (_state != PlayStates.PAUSED)
			{
				return false;
			}
			_state = PlayStates.PLAYING
			dispatchEvent(new GoEvent(GoEvent.RESUME));
			return true;
		}
		
		public function skipTo(position:Number):Boolean
		{
			return false;
		}
		
		override public function update(time:Number):void
		{
			if(state == PlayStates.PLAYING)
			{
				onUpdate(time);
				dispatchEvent(new GoEvent(GoEvent.UPDATE));
			}	
		}
		
		protected function onUpdate(time:Number):void
		{
			trace("Implement onUpdate");
		}
	}
}