package Actor
{	
	import flash.display.MovieClip;	
	
	public class Snail extends MovieClip
	{		
		public function Snail() 
		{
			this.x = 1000*Math.random();
			this.y = 700*Math.random();
			this.rotation=360*Math.random();
		}
	}
	
}
