// Code to create, move and remove enemy
package {
	import flash.display.*;
	import flash.events.*;
	
	public class World extends MovieClip {	
		// constructor: Creates an empty world object.
		public function World() {

		}
		function generateWorld()
		{
			
		}
		public function midPointDisplacementAlgorithm(width:Number, height:Number, roughness:Number, passes:Number, range:Number, startY:Number, endY:Number)
		{
				// pointsList will be returned
				var pointsList = []
				var low = height/2
				var high = range
				// array of X values. First point is 0, last point is width.
				var xArray = [0, width];
				
				// array of Y values. Both are randomized.
				var yArray = [startY, endY];
				
				for (var i:Number = 0; i < passes; i++)
				{
					var cur = 0;
					var nex = 1;
				
					while (nex < xArray.length)
					{
						// find the midpoint
						var midpoint:Number = (xArray[cur] + xArray[nex]) / 2;
						var displace:Number = ((yArray[cur] + yArray[nex]) / 2);
						var coinFlip = Math.random()
						if (coinFlip > 0.5)
						{
							displace += range
						}
						else
						{
							displace -= range
						}
						
						//trace(midpoint + ", " + displace)
						
						// insert x point in xArray
						xArray.splice(nex, 0, midpoint);
						// insert y point in yArray
						yArray.splice(nex, 0, displace);
						
						
						
						cur=nex+1;
						nex+=2;
						
					}
					// reduce range
					range *= Math.pow(2, -roughness)
					//high *= roughness
					
					low -= range
					high += low// + Math.pow(2, -(roughness));
					//high -= low + range // + Math.pow(2, -(roughness));
					
					
				}
				

				
				for (var k = 0; k < xArray.length; k++)
				{
						trace(xArray[k] + ", " + yArray[k])
						var temp = new Pair(xArray[k], yArray[k])
						pointsList.push(temp)	
				}
				
			// loop over pointsList to create randomly placed landing zones (LZs).
			
				var numOfLZs =  Math.random()*2; // create a random number of LZs to place, between 1 and 3.
				var lenOfLZ = Math.floor(pointsList.length / rand2N(10,38)) // randomize landing zone size.
				
				for (var j = 0; j < numOfLZs; j++)
				{
					// select a random spot. 
					var initLZ = int(Math.floor(Math.random()*pointsList.length)) - lenOfLZ // initial index.
					
										

					// weed out some nasty run-time errors
					// 1. initLZ can be too low (ex. 0), subtracted by lenOfLZ will be negative and thus out of range of pointsList.
					// 2. initLZ can be too high, added by lenOfLZ will be out of range of pointsList.
					while ((initLZ < 0) || (pointsList[initLZ].getThird() == 1) || (pointsList[initLZ+lenOfLZ].getThird() == 1))
					{
						initLZ = int(Math.floor(Math.random()*pointsList.length)) - lenOfLZ			
					}
					
					var diffHeight = (pointsList[initLZ].getSecond() - pointsList[initLZ+lenOfLZ].getSecond())
					var pointStep = Math.abs(diffHeight / lenOfLZ);
					trace("DIFFHEIGHT IS: " + diffHeight)
					// loop through pointsList and create new a LZ. 
					// to do so, Pair.thirdv is set to 1, and Pair.second (Y coordinate) is set to the initLZ's Y coordinate.
					var extraPoints = [];
					for (k = 0; k < lenOfLZ; k++) 
					{
						pointsList[initLZ+k].setThird(1);
						pointsList[initLZ+k].setSecond(pointsList[initLZ].getSecond())
						// if the difference in height is positive, then go UP
						if (diffHeight * -1 < diffHeight)
						{
							extraPoints.push(new Pair(pointsList[initLZ+lenOfLZ-1].getFirst(), pointsList[initLZ].getSecond()-(k*pointStep), 0));
						}
						// if difference is negative, then go DOWN
						else
						{
							extraPoints.push(new Pair(pointsList[initLZ+lenOfLZ-1].getFirst(), pointsList[initLZ].getSecond()+(k*pointStep), 0));
						}
					}
					trace(">>>>>>>>>>"+pointsList.length);
					for (k = 0; k < extraPoints.length; k++) 
					{
						pointsList.splice(initLZ+lenOfLZ+k,0,extraPoints[k]);
					}
					trace(">>>>>>>>>>"+pointsList.length);
				}
			
				return pointsList
		}
		public function drawPoints(points:Array, width:Number, height:Number)
		{
		var terrainShape = new Shape();
		terrainShape.graphics.clear(); 
		var circleColor:uint = 0;
		terrainShape.graphics.lineStyle(2, 0x000000, 0.75);
		terrainShape.graphics.moveTo(points[0].getFirst(), points[0].getSecond()); 
		terrainShape.graphics.beginFill(0x2a2a2a )
		for (var i = 0; i < points.length; i++)
		{
			// highlight the landing zones
			if (points[i].getThird() == 1)
			{
				terrainShape.graphics.lineStyle(2, 0xFFFF00, 1.25);
			}
			else
			{
				terrainShape.graphics.lineStyle(2, 0x000000, 0.75);
			}
			terrainShape.graphics.lineTo(points[i].getFirst(), points[i].getSecond())
		}
		
		terrainShape.graphics.lineTo(width, height)
		terrainShape.graphics.lineTo(0, height)
		terrainShape.graphics.endFill()
					
		return terrainShape;
		
		}
		// wraps terrain by splicing first n elements of pointsList and appends them at the back
		public function scrollTerrainRight(pointsList:Array, n:Number, width:Number, height:Number, startX:Number, endX:Number) // requires current pointList and number of points to wrap
		{
			var temp:Array = pointsList;
			var newList:Array = this.midPointDisplacementAlgorithm(width, height, 1.2, 12, 100, startX, endX);
			// redraw the shape and return the shape
			temp.concat(newList)
			return this.drawPoints(temp, width*2, height)
			
		}
		
		// wraps terrain by splicing last n elements of pointsList and puts them at the front
		public function scrollTerrainLeft(pointsList:Array, n:Number, width:Number, height:Number) // requires current pointList and number of points
		{
			var temp;
			for (var i = 0; i < n; i++)
			{
				temp = pointsList.pop()
				pointsList.unshift(temp);
			}
			for (var j = 0; j < pointsList.length; j++)
			{
				// loop through and edit X points
				var increment = width / (Math.log(pointsList.length-1)*Math.LOG2E)
				pointsList[j].setFirst(increment*j)
				trace("X: " + pointsList[j].getFirst() + "      Y: " + pointsList[j].getSecond())
			}
			
			// redraw the shape and return the shape
			return this.drawPoints(pointsList, width, height)
		}
		function rand2N(min:Number, max:Number)
		{
     		return Math.random()*(max-min)+min;			
		}
		/*public function remove() {
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME, moveMe);
		}
		*/
		
	}
}