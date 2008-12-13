package com.relivethefuture.components
{
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.goasap.PlayStates;
	import org.goasap.PlayableBase;
	import org.goasap.events.GoEvent;
	import org.goasap.interfaces.IPlayable;
	
	public class GoTransport extends Sprite
	{
		private var playButton:PushButton;
		private var stopButton:PushButton;
		
		private var playable:IPlayable;
		
		private var autoStart:Boolean = true;
		
		public function GoTransport()
		{
			super();
			
			playButton = new PushButton(this,0,0,">");
			playButton.addEventListener(MouseEvent.CLICK,playClicked);
			playButton.setSize(20,20);
			
			stopButton = new PushButton(this,20,0,"O");
			stopButton.addEventListener(MouseEvent.CLICK,stopClicked);
			stopButton.setSize(20,20);
		}
		
		public function setItem(item:IPlayable):void
		{
			if(playable != null)
			{
				playable.removeEventListener(GoEvent.START,stateChanged);
				playable.removeEventListener(GoEvent.STOP,stateChanged);
				playable.removeEventListener(GoEvent.PAUSE,stateChanged);
				playable.removeEventListener(GoEvent.RESUME,stateChanged);
			}
			
			playable = item;
			
			playable.addEventListener(GoEvent.START,stateChanged);
			playable.addEventListener(GoEvent.STOP,stateChanged);
			playable.addEventListener(GoEvent.PAUSE,stateChanged);
			playable.addEventListener(GoEvent.RESUME,stateChanged);
			
			if(autoStart)
			{
				playable.start();
			}
		}
		
		private function stateChanged(event:GoEvent):void
		{
			if(playable.state == PlayStates.PLAYING)
			{
				playButton.label = "||";
			}
			else if(playable.state == PlayStates.STOPPED || playable.state == PlayStates.PAUSED)
			{
				playButton.label = ">";
			}
		}
		
		private function playClicked(event:MouseEvent):void
		{
			if(playable.state == PlayStates.PLAYING)
			{
				playable.pause();
			}
			else if(playable.state == PlayStates.STOPPED)
			{
				playable.start();
			}
			else if(playable.state == PlayStates.PAUSED)
			{
				playable.resume();
			}
		}
		
		private function stopClicked(event:MouseEvent):void
		{
			playable.stop();
		}
	}
}