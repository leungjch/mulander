	package {
	import flash.display.*;
	import flash.events.*;

	// Pair class for storing X and Y coordinates for terrain data. 
	// firstv is used for x coordinate of terrain.
	// secondv is used for y coordinate of terrain.
	// thirdv is used to indicate whether the point is a landing zone or not.
	// isTouched is used to indicate whether the landing zone point has been touched already (used in scoring).
	public class Pair 
	{	
		private var firstv = 0;
		private var secondv = 0;		
		private var thirdv = 0;
		public var isTouched = false;
		public function Pair(x:Number, y:Number, z:Number = 0, a:Boolean = false)
		{
			this.firstv = x;
			this.secondv = y;
			this.thirdv = z;
			this.isTouched = false
		}
		
		// Getter functions
		public function getFirst()
		{
			return this.firstv;
		}
		public function getSecond()
		{
			return this.secondv;
		}		
		public function getThird()
		{
			return this.thirdv;
		}		

		
		// Setter functions
		public function setFirst(x:Number)
		{
			this.firstv = x
		}
		public function setSecond(y:Number)
		{
			this.secondv = y
		}		
		public function setThird(z:Number)
		{
			this.thirdv = z
		}	
			
	}
}
