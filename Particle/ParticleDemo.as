package Particle
{	import flash.display.MovieClip;	import flash.events.Event;	import flash.utils.Timer;
	import flash.events.TimerEvent;
		public class ParticleDemo extends MovieClip 
	{
		private var deleteMe:Timer=new Timer(1000,1);
		public static const ENEMY_OUT_OF_SCREEN:String="enemy out of screen";				public function ParticleDemo():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			deleteMe.addEventListener(TimerEvent.TIMER_COMPLETE, deleteBlood);		}
		
		private function init(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onLoop, false, 0, true);
			deleteMe.start();
		}				private function onLoop(evt:Event):void 
		{			var p:Particle = new Particle(0, 0, Math.random() * 1.8 + .2, Math.random() * 0.8 + .2, Math.random() * 10 - 5, Math.random() * -10, 1);
			addChild(p);		}
		
		private function deleteBlood(te:TimerEvent):void
		{
			dispatchEvent(new Event(ENEMY_OUT_OF_SCREEN));
		}	}}