package ;
import org.flixel.FlxEmitter;
import org.flixel.FlxSprite;
import org.flixel.FlxG;

/**
 * ...
 * @author sirGustav
 */

class TimeBlock extends FlxSprite
{
	private var countdown : Bool = false;
	private var timer : Float = 1;
	private var em : FlxEmitter;
	
	public function new(X:Float, Y:Float, E:FlxEmitter) 
	{
		super(X, Y);
		em = E;
		
		loadGraphic("assets/items.png", true, false, 40, 40);
		
		height = 40;
		offset.y = 0;
		width = 40;
		offset.x = 0;
		immovable = true;
		addAnimation("idle", [22]);
		play("idle");
	}
	
	override public function kill():Void 
	{
		super.kill();
		Game.sfx("bang");
	}
	
	override public function update():Void 
	{
		if ( countdown )
		{
			timer -= FlxG.elapsed;
			
			if ( timer <= 0 ) 
			{
				em.at(this);
				em.start(true, 2, 1, 4);
				kill();
			}
		}
		super.update();
	}
	
	override public function hurt(Damage:Float):Void 
	{
		if ( flickering == false )
		{
			flicker(timer);
			countdown = true;
			Game.sfx("bonk");
		}
	}
}