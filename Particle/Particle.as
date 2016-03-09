package Particle
{    import flash.display.Sprite;    import flash.events.Event;        public class Particle extends Sprite 
	{                private var _xPos:Number;        private var _yPos:Number;        private var _xVel:Number;        private var _yVel:Number;        private var _grav:Number;        public function Particle(xPos:Number=0, yPos:Number=0,scale:Number=1, opacity:Number=1, xVel:Number=4, yVel:Number=-5, grav:Number=4)
		{
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			            _xPos = xPos;            _yPos = yPos;            _xVel = xVel            _yVel = yVel            _grav = grav;
			alpha = opacity;
            scaleX = scaleY = scale;        }
		
		private function init(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onRun, false, 0, true);
			
			var ball:Sprite = new Ball();
            addChild(ball);
            x = _xPos;
            y = _yPos;
		}
				private function onRun(evt:Event):void 
		{			_yVel += _grav;			_xPos += _xVel;			_yPos += _yVel;			x = _xPos;			y = _yPos;
			this.rotation+=30;			if (_xPos < 0 || _xPos >  stage.stageWidth||_yPos < 0 || _yPos > stage.stageHeight)
			{			   removeEventListener(Event.ENTER_FRAME, onRun);			   parent.removeChild(this);			}		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onRun);
			
		}	}}