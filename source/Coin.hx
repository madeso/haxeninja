package ;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

/**
 * ...
 * @author sirGustav
 */

class Coin extends FlxSprite
{
	public function new(X:Float, Y:Float) 
	{
		super(X, Y+15);
		loadGraphic("assets/items.png", true, false, 40, 40);
		height = 15;
		offset.y = 15;
		width = 15;
		offset.x = 12;
		addAnimation("idle", [20]);
		play("idle");
	}
	
	override public function kill():Void 
	{
		super.kill();
		FlxG.score++;
		Game.sfx("coin");
	}
}