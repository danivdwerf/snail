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
	import flash.net.*;
	import flash.media.Video;
	import flash.events.AsyncErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import Screens.StartScreen;
	import Screens.EndScreen;
	import Screens.LoseScreen;
	import Screens.Instructions;
	import Actor.Snail;
	import Actor.Fist;
	import Screens.Background;
	import Sounds.ManScreaming;
	import Sounds.Squish;
	import Particle.ParticleDemo;
	import flash.events.NetStatusEvent;
	
	public class Main extends MovieClip 
	{
		private var startScreen:MovieClip=new StartScreen();
		private var endScreen:MovieClip=new EndScreen();
		private var loseScreen:MovieClip=new LoseScreen();
		private var backGround:MovieClip=new Background();
		private var instructions:MovieClip=new Instructions();
		private var fist:MovieClip=new Fist();
		
		private var netConnect:NetConnection=new NetConnection();
		private var netStream:NetStream;
		var video:Video=new Video();
		
		private var scoreText:TextField=new TextField();
		private var tf:TextFormat =new TextFormat();
		
		private var manScream:Sound=new ManScreaming();
		private var squish:Sound=new Squish();
		private var channel:SoundChannel=new SoundChannel();
		
		private var fistOnScreen:Boolean=false;
		private var snailsOnScreen:Boolean=false;
		
		private var snails:Array=[];
		private var bloods:Array=[];
		
		private var gameState:String;
		private static const INTRO:String="intro";
		private static const INFO:String="info";
		private static const GAME:String="game";
		private static const OUTRO:String="outro";
		
		private var spawner:Timer=new Timer(4000,1);
		private var failTimer:Timer=new Timer(1000,1);
		private var endScreenLose:Timer=new Timer(2000,1);
		
		private var random:int=10+Math.ceil(Math.random()*15);
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

		private function async(e:AsyncErrorEvent):void
		{
			
		}
		
		private function addListeners():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
			failTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fail);
			spawner.addEventListener(TimerEvent.TIMER_COMPLETE, spawnSnail);
			endScreenLose.addEventListener(TimerEvent.TIMER_COMPLETE, restartLoseGame);
		}
		
		private function removeListeners():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage.removeEventListener(Event.ENTER_FRAME, Update);
			
			failTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fail);
			spawner.removeEventListener(TimerEvent.TIMER_COMPLETE, spawnSnail);
			endScreenLose.removeEventListener(TimerEvent.TIMER_COMPLETE, restartLoseGame);
		}

		private function buildIntro():void
		{
			addChild(startScreen);
			gameState = Main.INTRO;
		}
		
		private function destroyIntro():void
		{
			removeChild(startScreen);  
			buildInfo();
		}
		
		private function buildInfo():void
		{
			addChild(instructions);
			gameState = Main.INFO;
		}
		
		private function deleteInfo():void
		{
			removeChild(instructions);
			buildGame();
		}
		
		private function buildGame():void
		{
			spawner.start();
			addChild(backGround);
			addChild(scoreText);
			scoreText.x= stage.width/2;
			fistOnScreen=false;
			gameState = Main.GAME;
		}
		
		private function destroyGame():void
		{
			removeChild(backGround);
			addChild(endScreen);
			if(fistOnScreen)
			{
				removeChild(fist);
			}
			
			buildOutro();
			spawner.stop();
			spawner.reset();
			score=0;
		}
		
		private function loseGame():void
		{
			removeChild(backGround);
			addChild(loseScreen);
			
			if(fistOnScreen)
			{
				removeChild(fist);
			}
			
			buildOutro();
			spawner.stop();
			spawner.reset();
			score=0;
		}
		
		private function destroyWinGame():void
		{
			removeChild(backGround);
			if(fistOnScreen)
			{
				removeChild(fist);
			}
			
			for(var i:int=snails.length-1; i>=0; i--)
			{
				removeChild(snails[i]);
				snails.splice(i,1);
			}
			
			buildWinOutro();
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
			endScreenLose.start();
			gameState = Main.OUTRO;
		}
		
		private function buildWinOutro():void
		{
			netConnect.connect(null);
			netStream=new NetStream(netConnect);
			netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, async);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			
			netStream.play("WinScreen.mp4");
			video.attachNetStream(netStream);
			
			video.width=1280;
			video.height=720;
			addChild(video);
			gameState = Main.OUTRO;
		}
		private function netStatus(e:NetStatusEvent):void
		{
			if(e.info.code == "NetStream.Play.Stop")
			{
				restartWinGame();
			}
		}
		private function destroyWinOutro():void
		{
			removeChild(video);
		}
		
		private function destroyLoseOutro():void
		{
			endScreenLose.stop();
			endScreenLose.reset();
		}
		
		private function restartWinGame():void
		{
			spawner.stop();
			spawner.reset();
			destroyWinOutro();
			removeListeners();
			addListeners();
			buildIntro();
		}
		
		private function restartLoseGame(te:TimerEvent):void
		{
			spawner.stop();
			spawner.reset();
			destroyLoseOutro();
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
			
			if(amountOfSnails==0&&gameState == Main.GAME)
			{
				spawner.start();
				snailsOnScreen=false;
			}
			
			if(score==50+ Math.ceil(Math.random()*20))
			{
				destroyWinGame();
			}
		}
		
		private function deleteSnails(e:Event):void
		{
			for(var i:int=snails.length-1; i>=0; i--)
			{
				destroySnails(i, false);
			}
			
			if(snails.length==0)
			{
				spawner.stop();
				spawner.reset();
				loseGame();
			}
		}
		
		private function destroySnails(i:int, blood:Boolean):void
		{
			if(blood)
			{
				bloods.push(new ParticleDemo);
				addChild(bloods[bloods.length-1]);
				bloods[bloods.length-1].x=snails[i].x;
				bloods[bloods.length-1].y=snails[i].y;
				bloods[bloods.length-1].addEventListener(ParticleDemo.ENEMY_OUT_OF_SCREEN, removeBlood);
			}
			
			removeChild(snails[i]);
			snails.splice(i,1);
		}
		
		private function removeBlood(e:Event):void
		{
			var p:ParticleDemo = e.target as ParticleDemo;
			removeChild(p);
			p.removeEventListener(ParticleDemo.ENEMY_OUT_OF_SCREEN, removeBlood);
			bloods.splice(bloods.indexOf(p),1);
			
		}
		
		private function onKeyDown(k:KeyboardEvent):void
		{
			if(k.keyCode==32&&gameState == Main.GAME&&fistOnScreen==false&&amountOfSnails>0)
			{
				addChild(fist);
				channel=squish.play();
				fistOnScreen=true;
				destroySnails(0, true);
				score++;
			}
			
			else if(k.keyCode==32&&gameState == Main.INTRO)
			{
				destroyIntro();
			}
			
			else if(k.keyCode==32&&gameState == Main.INFO)
			{
				deleteInfo();
			}
			
			else if(k.keyCode==32&&gameState == Main.GAME&&amountOfSnails<=0)
			{
				addChild(fist);
				channel=manScream.play();
				spawner.stop();
				spawner.reset();
				failTimer.start();
			}
		}
		
		private function onKeyUp(k:KeyboardEvent):void
		{	
			
			if(k.keyCode==32&&gameState == Main.GAME&&fistOnScreen==true)
			{
				removeChild(fist);
				fistOnScreen=false;
			}
		}
	}
}
