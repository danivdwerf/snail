﻿package Particle
{
	import flash.events.TimerEvent;
	
	{
		private var deleteMe:Timer=new Timer(1000,1);
		public static const ENEMY_OUT_OF_SCREEN:String="enemy out of screen";
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			deleteMe.addEventListener(TimerEvent.TIMER_COMPLETE, deleteBlood);
		
		private function init(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onLoop, false, 0, true);
			deleteMe.start();
		}
		{
			addChild(p);
		
		private function deleteBlood(te:TimerEvent):void
		{
			dispatchEvent(new Event(ENEMY_OUT_OF_SCREEN));
		}