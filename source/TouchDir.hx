package ;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.system.input.TouchManager;
import org.flixel.system.input.Touch;

/**
 * ...
 * @author sirGustav
 */

class TouchDir 
{
	private var point : Vec;
	private var down = false;
	private var id : Int = 0;
	
	private var resDir : Int = 0;
	private var resPower : Float = 0;
	
	public static var LIM : Float = 25;
	
	public function new() 
	{
	}
	
	public function update() : Void
	{
		resDir = 0;
		resPower = 0;
		
		for (touch in FlxG.touchManager.touches)
		{
			if (touch.justPressed() && down == false)
			{
				point = new Vec(touch.screenX, touch.screenY);
				id = touch.touchPointID;
				down = true;
			}
			
			if ( touch.justReleased() && down == true && touch.touchPointID == id )
			{
				down = false;
				
				var newPoint : Vec = new Vec(touch.screenX, touch.screenY);
				
				var dist = Vec.Sub(newPoint, point);
				dist.y = -dist.y;
				
				if ( dist.len() < LIM )
				{
					resDir = 5;
				}
				else
				{
					resDir = Maths.Classify(dist);
				}
				resPower = dist.len() / LIM;
			}
		}
	}
	
	public function getDir() : Int
	{
		return resDir;
	}
	
	public function getPower() : Float
	{
		return resPower;
	}
}