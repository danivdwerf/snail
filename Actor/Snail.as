package Actor
{	
	import flash.display.MovieClip;	
	import flash.events.Event;
	
	public class Snail extends MovieClip
	{		
		public static const ENEMY_OUT_OF_BOUNDS:String="enemy out of bounds";
		public var speed:int=10;
		
		public function Snail() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function init(e:Event):void
		{
			this.x = 100+Math.random()*1000;
			this.y = 750+Math.random()*500;
			this.rotation=360*Math.random();
		}
		
		private function update(e:Event):void
		{
			this.y-=speed;
			this.rotation +=20;
			
			if(this.y < -20)
			{	
				dispatchEvent(new Event(ENEMY_OUT_OF_BOUNDS));
				this.removeEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		private function removed(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
	
}
