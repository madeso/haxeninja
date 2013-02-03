package ;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

/**
 * ...
 * @author sirGustav
 */

class DeadSlime extends FlxSprite
{
	public function new() 
	{
		super();
		loadGraphic("assets/items.png", true, false, 40, 40);
		
		addAnimation("flying", [17 + 2]);
		addAnimation("walking", [14 + 2]);
		
		acceleration.y = 400;
		
		exists = false;
	}
	
	public function startDead(X:Float, Y:Float, flying : Bool) : Void
	{
		x = X;
		y = Y;
		
		velocity.x = Game.rnd(-100, 100);
		velocity.y = Game.rnd(-150, 0);
		
		if ( flying )
		{
			height = 14;
			offset.y = 13;
			width = 16;
			offset.x = 12;
		}
		else
		{
			height = 12;
			offset.y = 28;
			width = 18;
			offset.x = 11;
		}
		//y += offset.y;
		exists = true;
		
		if ( flying ) play("flying");
		else play("walking");
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		if ( onScreen() == false ) kill();
	}
	
	override public function kill():Void 
	{
		exists = false;
		super.kill();
	}
}