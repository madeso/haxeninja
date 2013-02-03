package ;
import org.flixel.FlxEmitter;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

/**
 * ...
 * @author sirGustav
 */

class BreakBlock extends FlxSprite
{
	private var em: FlxEmitter;
	public function new(X:Float, Y:Float, E : FlxEmitter) 
	{
		super(X, Y);
		loadGraphic("assets/items.png", true, false, 40, 40);
		em = E;
		
		height = 40;
		offset.y = 0;
		width = 40;
		offset.x = 0;
		immovable = true;
		health = 3;
		addAnimation("idle", [23]);
		play("idle");
	}
	
	override public function kill():Void 
	{
		FlxG.shake(0.01);
		super.kill();
		
		Game.sfx("trash");
		
		em.at(this);
		em.start(true, 2, 1, 4);
	}
	
	override public function hurt(Damage:Float):Void 
	{
		if ( flickering == false && Damage > 0)
		{
			flicker(0.5);
			super.hurt(Damage);
			if ( health > 0 )
			{
				FlxG.shake(0.003);
				Game.sfx("smack");
			}
		}
	}
}