﻿package Particle
{
	{        
		{
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			alpha = opacity;
            scaleX = scaleY = scale;
		
		private function init(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onRun, false, 0, true);
			
			var ball:Sprite = new Ball();
            addChild(ball);
            x = _xPos;
            y = _yPos;
		}
		
		{
			this.rotation+=30;
			{
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onRun);
			
		}