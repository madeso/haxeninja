package ;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

/**
 * ...
 * @author sirGustav
 */

class Spike extends FlxSprite
{
	public function new(X:Float, Y:Float) 
	{
		super(X, Y+20);
		loadGraphic("assets/items.png", true, false, 40, 40);
		height = 20;
		offset.y = 20;
		width = 40;
		offset.x = 0;
		addAnimation("idle", [21]);
		play("idle");
	}
	
	override public function kill():Void 
	{
		super.kill();
	}
}