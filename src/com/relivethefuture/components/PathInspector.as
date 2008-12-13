package com.relivethefuture.components
{
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.relivethefuture.go.EasingPack;
	import com.relivethefuture.go.GoPath;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class PathInspector extends Sprite
	{
		private var container:Sprite;
		private var pingPongButton:PushButton;
		private var durationSlider:HUISlider;
		private var easingPreviousButton:PushButton;
		private var easingNextButton:PushButton;
		private var easingLabel:Label;
		
		private var easings:EasingPack;
		
		private var goPath:GoPath;
		
		public function PathInspector()
		{
			super();
			container = new Sprite();
			addChild(container);
			
			easings = new EasingPack();

			createControls();
		}
		
		public function setPath(path:GoPath):void
		{
			goPath = path;
			goPath.easing = easings.easing.fn;
		}
		
		private function createControls():void
		{
			pingPongButton = new PushButton(container,0,10,">>>",togglePingPong);
			pingPongButton.setSize(20,20);
			pingPongButton.toggle = true;
			
			durationSlider = new HUISlider(container,-8,30,"",durationChange);
			durationSlider.setSliderParams(0.2,20,1);
			durationSlider.setSize(150,20);
			
			easingPreviousButton = new PushButton(container, 0, 50,"<",previousEasing);
			easingPreviousButton.setSize(15,20);
			
			easingNextButton = new PushButton(container,90,50,">",nextEasing);
			easingNextButton.setSize(15,20);
			
			easingLabel = new Label(container, 15,50,easings.easing.name);
		}
		
		private function previousEasing(event:Event):void
		{
			easings.previous();
			easingLabel.text = easings.easing.name;
			goPath.easing = easings.easing.fn;
		}

		private function nextEasing(event:Event):void
		{
			easings.next();
			easingLabel.text = easings.easing.name;
			goPath.easing = easings.easing.fn;			
		}
		
		private function durationChange(event:Event):void
		{
			goPath.duration = durationSlider.value;
		}
		
		private function togglePingPong(event:Event):void
		{
			goPath.repeater.reverseOnCycle = !goPath.repeater.reverseOnCycle;
			pingPongButton.label = goPath.repeater.reverseOnCycle ? "<=>" : ">>>";
		}		
	}
}