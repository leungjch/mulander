// Code to create, move and remove enemy
package {
	import flash.display.*;
	import flash.events.*;
	import flash.events.KeyboardEvent;
	import flash.ui.*;
	public class Mulan extends MovieClip {

		public var isRotatingClockwise:Boolean=false;
		public var isRotatingCounterClockwise:Boolean=false;
		public var isAccelerating:Boolean=false;

		public var dir=90;
		public var speedX=0;
		public var speedY=0;
		public var maxSpeedX=12;
		public var maxSpeedY=10;

		public var gravity=Math.random()*0.01;
		
		
		public var fuel = 100;


		// constructor: Creates an empty world object.
		public function Mulan() {

			addEventListener(Event.ADDED_TO_STAGE, init);

		}
		public function init(e:Event) {
			this.y=-30;
			this.x=0;
			speedX=Math.random()*2.5
			speedY=Math.random()
			fuel = 100;			
			this.rotation=Math.random()*180
			this.addEventListener(Event.ENTER_FRAME, handleKeys);
			this.addEventListener(Event.ENTER_FRAME, moveMe);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);

		}
		public function handleKeys(e:Event):void {

		}
		private function moveMe(e:Event) {
			dir=this.rotation%360-90;// direction is facing up
			if (isAccelerating) {
				
				//change to thruster frame
				gotoAndStop(2)
				
					speedX+=0.02*Math.cos(dir*Math.PI/180);
					speedY+=0.02*Math.sin(dir*Math.PI/180);
					
					// limit x speed to a maximum.
					// account for speed towards the RIGHT direction.
					if (speedX >= maxSpeedX)
					{
						speedX = maxSpeedX
					}
					// account for speed towards the LEFT direction.
					else if (speedX <= -maxSpeedX)
					{
						speedX = -maxSpeedX
					}
					// limit y speed to a maximum.
					// account for speed DOWN.
					if (speedY >= maxSpeedY)
					{
						speedY = maxSpeedY
					}
					// account for speed UP.
					else if (speedY <= -maxSpeedY)
					{
						speedY = -maxSpeedY
					}
					// decrement fuel when accelerating.
					if (fuel >= 0)
					{
					fuel-=0.1;
					}
					else
					{
						fuel = 0;
						isAccelerating = false
					}

			}
			else
			{
				gotoAndStop(1)							
			}
			
			if (isRotatingCounterClockwise) {
				this.rotation-=2;
			}
			if (isRotatingClockwise) {
				this.rotation+=2;
			}

			this.x+=speedX;
			this.y+=speedY;
			speedY+=gravity;
			// add gravity
		}
		private function keyPressed(e:KeyboardEvent):void {
			// if spacebar is pressed, accelerate
			if (e.keyCode==Keyboard.UP) {
				
				
				if (fuel >= 0)
				{
				isAccelerating= true;
				}
				else
				{
				isAccelerating=false;					
				}
			}
			// if left key is pressed, rotate counterclockwise.
			if (e.keyCode==Keyboard.LEFT) {
				isRotatingCounterClockwise= true;
			}
			// if right key is pressed, rotate clockwise.
			if (e.keyCode==Keyboard.RIGHT) {
				isRotatingClockwise= true;
			}

		}
		private function keyReleased(e:KeyboardEvent):void {
			if ((e.keyCode == Keyboard.UP)) {
				isAccelerating=false;
			}
			// if left key is pressed, rotate counterclockwise.
			if ((e.keyCode == Keyboard.LEFT)) {
				isRotatingCounterClockwise=false;
			}
			// if right key is pressed, rotate clockwise.
			if ((e.keyCode == Keyboard.RIGHT)) {
				isRotatingClockwise=false;
			}
		}

	}
}