package
{
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform; 
	import Screens.StartScreen;
	import Screens.EndScreen;
	import Actor.Snail;
	import Actor.Fist;
	import Screens.Background;
	import Sounds.ManScreaming;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Sounds.Squish;
	
	public class Main extends MovieClip 
	{
		private var startScreen:MovieClip=new StartScreen();
		private var endScreen:MovieClip=new EndScreen();
		private var backGround:MovieClip=new Background();
		private var fist:MovieClip=new Fist();
		
		private var scoreText:TextField=new TextField();
		private var tf:TextFormat =new TextFormat();
		
		private var manScream:Sound=new ManScreaming();
		private var squish:Sound=new Squish();
		private var channel:SoundChannel=new SoundChannel();
		
		private var intro:Boolean=true;
		private var game:Boolean=false;
		private var outro:Boolean=false;
		private var fistOnScreen:Boolean=false;
		private var snailsOnScreen:Boolean=false;
		
		private var snails:Array=[];
		
		private var spawner:Timer=new Timer(4000,1);
		private var failTimer:Timer=new Timer(1000,1);
		private var endScreenTimer:Timer=new Timer(2000,1);
		
		private var random:int=10+Math.ceil(Math.random()*10);
		private var score:int=0;
		private var amountOfSnails:int;
		
		public function Main() 
		{
			addListeners();
			buildIntro();
			tf.size=60;
			tf.align="center";
			tf.font="yikes";
			spawner.stop();
			spawner.reset();
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
			addChild(backGround);
			addChild(scoreText);
			scoreText.x= stage.width/2;
			fistOnScreen=false;
			game=true;
		}
		
		private function destroyGame():void
		{
			removeChild(backGround);
			if(fistOnScreen)
			{
				removeChild(fist);
			}
			
			buildOutro();
			spawner.stop();
			spawner.reset();
			score=0;
		}

		private function fail(te:TimerEvent):void
		{
			destroyGame();
		}
		
		private function buildOutro():void
		{
			game=false;
			outro=true;
			addChild(endScreen);
			endScreenTimer.start();
		}

		private function destroyOutro():void
		{
			removeChild(endScreen);
			outro=false;
			endScreenTimer.stop();
			endScreenTimer.reset();
		}
		
		private function restartGame(te:TimerEvent):void
		{
			spawner.stop();
			spawner.reset();
			game=false;
			destroyOutro();
			removeListeners();
			addListeners();
			buildIntro();
		}
		
		private function spawnSnail(te:TimerEvent):void
		{
			snailsOnScreen=true;
			for(var i=0; snails.length <random; i++)
			{
				snails.push(new Snail);
				addChild(snails[snails.length-1]);
				snails[i].addEventListener(Snail.ENEMY_OUT_OF_BOUNDS, deleteSnails);
			}
		}
		
		private function Update(e:Event):void
		{
			scoreText.text= String (score);
			scoreText.setTextFormat(tf);
			amountOfSnails=snails.length;
			
			if(amountOfSnails==0&&game==true)
			{
				spawner.start();
				snailsOnScreen=false;
			}
		}
		
		private function deleteSnails(e:Event):void
		{
			var s:Snail = e.target as Snail;
			removeChild(s);
			snails.splice(snails.indexOf(s),1);
			if(snails.length==0)
			{
				spawner.stop();
				spawner.reset();
				destroyGame();
			}
		}
		
		private function onKeyDown(k:KeyboardEvent):void
		{
			if(k.keyCode==32&&game==true&&fistOnScreen==false&&amountOfSnails>0)
			{
				addChild(fist);
				channel=squish.play();
				fistOnScreen=true;
				removeChild(snails[0]);
				snails.splice(0,1);
				score++;
			}
			
			if(k.keyCode==32&&game==true&&amountOfSnails<=0)
			{
				game=false;
				addChild(fist);
				channel=manScream.play();
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
