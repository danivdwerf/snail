package
{
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import Screens.StartScreen;
	import Screens.EndScreen;
	import Actor.Snail;
	import Actor.Fist;
	
	public class Main extends MovieClip 
	{
		private var startScreen:MovieClip=new StartScreen();
		private var endScreen:MovieClip=new EndScreen();
		private var fist:MovieClip=new Fist();
		
		private var intro:Boolean=true;
		private var game:Boolean=false;
		private var fistOnScreen:Boolean=false;
		
		private var snails:Array=[];
		
		private var spawner:Timer=new Timer(4000,1);
		private var failTimer:Timer=new Timer(1000,1);
		private var endScreenTimer:Timer=new Timer(2000,1);
		
		private var random:int=5+Math.round(Math.random()*10);
		private var amountOfSnails:int;
		
		public function Main() 
		{
			addListeners();
			buildIntro();
		}
		
		private function addListeners():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
			failTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fail);
			spawner.addEventListener(TimerEvent.TIMER_COMPLETE, spawnSnail);
			endScreenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, restartGame);
		}
		
		private function removeListeners():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage.removeEventListener(Event.ENTER_FRAME, Update);
			
			failTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fail);
			spawner.removeEventListener(TimerEvent.TIMER_COMPLETE, spawnSnail);
			endScreenTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, restartGame);
		}

		private function buildIntro():void
		{
			addChild(startScreen);
			intro=true;
		}
		
		private function destroyIntro():void
		{
			removeChild(startScreen);  
			intro=false;
		}
		
		private function buildGame():void
		{
			spawner.start();
			fistOnScreen=false;
			game=true;
		}
		
		private function destroyGame():void
		{
			removeChild(fist);
			buildOutro();
		}

		private function fail(te:TimerEvent):void
		{
			destroyGame();
		}
		
		private function buildOutro():void
		{
			addChild(endScreen);
			endScreenTimer.start();
		}

		private function destroyOutro():void
		{
			removeChild(endScreen);
			endScreenTimer.stop();
			endScreenTimer.reset();
		}
		
		private function restartGame(te:TimerEvent):void
		{
			destroyOutro();
			removeListeners();
			addListeners();
			buildIntro();
		}
		
		private function spawnSnail(te:TimerEvent):void
		{
			for(var i=random; snails.length<i; i--)
			{
				snails.push(new Snail);
				addChild(snails[snails.length-1]);
			}
		}
		
		private function Update(e:Event):void
		{
			amountOfSnails=snails.length;
		}
		
		private function onKeyDown(k:KeyboardEvent):void
		{
			if(k.keyCode==32&&game==true&&fistOnScreen==false)
			{
				addChild(fist);
				fistOnScreen=true;
			}
			
			if(k.keyCode==32&&game==true&&amountOfSnails<=0)
			{
				game=false;
				addChild(fist);
				spawner.stop();
				spawner.reset();
				failTimer.start();
			}
		}
		
		private function onKeyUp(k:KeyboardEvent):void
		{	
			if(k.keyCode==32&&intro==true)
			{
				destroyIntro();
				buildGame();
			}
			
			if(k.keyCode==32&&game==true&&fistOnScreen==true)
			{
				removeChild(fist);
				fistOnScreen=false;
			}
		}
	}
}
